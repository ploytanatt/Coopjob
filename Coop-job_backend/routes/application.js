const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { generateToken } = require("../utils/token");
const { v4: uuidv4 } = require('uuid');
const { isLoggedIn } = require("../middleware");
const multer = require('multer');
const { json } = require('body-parser');

// ตั้งค่า multer upload
const upload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'static/coop302/'); 
    },
    filename: function (req, file, cb) {
      const uniqueFileName = `${uuidv4().slice(0, 4)}-${file.originalname}`;
      cb(null, uniqueFileName); // กำหนดชื่อไฟล์เก็บในโฟลเดอร์เป็นชื่อที่ไม่ซ้ำกัน
    }
  }),
});

//สมัครงาน
router.post('/sendApplicationJob', isLoggedIn, async (req, res) => {
  try {
    const { job_id, user_id } = req.body;

    // ตรวจสอบว่า user_id นี้เคยสมัคร job_id นี้แล้วหรือไม่ (รวมถึงสถานะ 'cancelled' ถ้าเกิดว่า ยกเลิกแล้วให้สมัครใหม่ได้)
    const [existingApplication] = await pool.query(
      'SELECT * FROM applications WHERE job_id = ? AND student_id = ? AND application_status != "canceled"',
      [job_id, user_id]
    );

    console.log(existingApplication);

    if (existingApplication.length > 0) {
      // ถ้ามีการสมัครซ้ำแล้วหรือถูกยกเลิก
      return res.status(400).json({ error: 'You have already applied for this job.' });
    }

    // ถ้ายังไม่มีการสมัคร
    const [result] = await pool.query(
      'INSERT INTO applications (job_id, student_id, application_status, datetime) VALUES (?, ?, ?, now())',
      [job_id, user_id, 'pending']
    );

    res.json({ message: 'Application submitted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Get job applications for a specific user with additional details //แสดงรายการงานที่สมัคร
router.get('/getJobApplications', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
        SELECT ja.*, j.*, c.*
        FROM applications ja
        INNER JOIN jobs j ON ja.job_id = j.job_id
        LEFT JOIN companies c ON j.user_id = c.user_id
        WHERE ja.student_id = ?
    `, [userId]);

    console.log(results);

    res.json(results);
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Server error' });
  }
});

//ยกเลิกการสมัครงาน
router.put('/cancelJob/:applicationId', isLoggedIn, async (req, res) => {
  const { application_status } = req.body;
  const applicationId = req.params.applicationId;
  try {
    await pool.query('UPDATE applications SET application_status = ? WHERE application_id = ?', [application_status, applicationId]);
    res.json({ message: 'ยกเลิกการสมัครงานเรียบร้อย' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Get job applications for a specific recruiter // ใบสมัครทั้งหมดของบริษัทนั้นๆ
router.get('/getApplication/:applicationId', isLoggedIn, async (req, res) => {
  const applicationId = req.params.applicationId;
  try {
    // ดึงข้อมูลแอพลิเคชันโดยใช้ applicationId
    const applications = await pool.query('SELECT * FROM applications WHERE application_id = ?', [applicationId]);
    res.json(applications);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

// List ใบสมัครแบบเจาะจงเฉพาะงานนั้นๆ
router.get('/getApplicationByJob/:jobId', isLoggedIn, async (req, res) => {
  const jobId = req.params.jobId;
  try {
    const [applicationsByjob] = await pool.query(`
      SELECT sj.*, st.* , js.*
      FROM applications sj
      JOIN students st ON sj.student_id = st.user_id
      JOIN jobs js ON js.job_id = sj.job_id
      
      WHERE sj.job_id = ?
    `, [jobId]);
    res.json(applicationsByjob);
    console.log("getApplicationByJob with student details success");
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});



// Get job applications for all recruiter
router.get('/getApplications', isLoggedIn, async (req, res) => {
  const recruiterId = req.user.user_id;
  try {
    const [results] = await pool.query(`
    SELECT sj.*, st.*, j.*
    FROM applications sj
    JOIN students st ON sj.student_id = st.user_id
    JOIN jobs j ON sj.job_id = j.job_id
    WHERE j.user_id = ?;
      `, [recruiterId]);
    res.json(results);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


//ตอบรับการสมัครงาน, อัพโหลดไฟล์ coop
router.put('/updateStatus/:applicationId', isLoggedIn, upload.single('coopfile'), async (req, res) => {
  const applicationId = req.params.applicationId;
  const { application_status } = req.body;
  const filePath = req.file.path;
  try {
    await pool.query('UPDATE applications SET application_status = ?, coop302 = ? WHERE application_id = ?', [application_status, filePath, applicationId]);
    res.json({ message: 'อัพโหลดไฟล์สำเร็จ' });
    console.log("update job apllication successfuly")
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

//ดูรายละเอียดของผู้สมัคร
router.get('/getApplicationDetails/:applicationId', async (req, res) => {
  try {
    const applicationId = req.params.applicationId;
    const [applicationResult] = await pool.query('SELECT student_id FROM applications WHERE application_id = ?', [applicationId]);
    const userId = applicationResult[0].student_id;
    const [studentResult] = await pool.query('SELECT * FROM students WHERE user_id = ?', [userId]);
    res.json(studentResult);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

//กดถูกใจงาน
router.post('/sendFavoriteJob/:jobId', isLoggedIn, async (req, res) => {
  const jobId = req.params.jobId;
  const userId = req.user.user_id;

  try {
    // ตรวจสอบว่าผู้ใช้ได้กดถูกใจงานนี้ไปแล้วหรือไม่
    const [existingFavorite] = await pool.query(
      'SELECT * FROM favorite_jobs WHERE job_id = ? AND user_id = ?',
      [jobId, userId]
    );

    if (existingFavorite.length > 0) {
      // ถ้าได้กดถูกใจไปแล้ว
      return res.status(400).json({ error: 'You have already liked this job.' });
    }

    // ถ้ายังไม่ได้กดถูกใจ
    await pool.query(
      'INSERT INTO favorite_jobs (user_id, job_id) VALUES (?, ?)',
      [userId, jobId]
    );

    res.json({ message: 'Job liked successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});



router.get('/getFavoriteJobs', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
      SELECT fj.*, j.job_title as job_title, c.company_name
      FROM favorite_jobs fj
      INNER JOIN jobs j ON fj.job_id = j.job_id
      LEFT JOIN companies c ON j.user_id = c.user_id
      WHERE fj.user_id = ?
    `, [userId]);
    const FavoriteJobs = results.map((row) => {
      return {
        favorite_job_id: row.favorite_job_id,
        job_id: row.job_id,
        job_title: row.job_title,
        company_name: row.company_name, 
      };
    });
    res.json(FavoriteJobs);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});



// ยกเลิกการถูกใจงาน
router.delete('/cancelFavoriteJob/:jobId', isLoggedIn, async (req, res) => {
  const jobId = req.params.jobId;
  const userId = req.user.user_id;

  try {
    // ตรวจสอบว่าผู้ใช้ได้กดถูกใจงานนี้ไปแล้วหรือไม่
    const [existingFavorite] = await pool.query(
      'SELECT * FROM favorite_jobs WHERE job_id = ? AND user_id = ?',
      [jobId, userId]
    );

    if (existingFavorite.length === 0) {
      // ถ้ายังไม่ได้กดถูกใจ
      return res.status(400).json({ error: 'You have not liked this job.' });
    }

    // ถ้าได้กดถูกใจไปแล้ว
    await pool.query(
      'DELETE FROM favorite_jobs WHERE user_id = ? AND job_id = ?',
      [userId, jobId]
    );

    res.json({ message: 'Job unliked successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

//รีพอร์ตงาน
router.post('/sendReport', isLoggedIn, async (req, res) => {
  console.log('Received a POST request to /application/sendReport', req.body);
  try {
    const { job_id, user_id, title, description } = req.body;

    // Save the report details to the database or perform any necessary actions ใส่ now()เพื่อให้เอาวันที่ปัจจุบันมา
    const query = `INSERT INTO report_company (user_id, job_id, title, description, created_at) VALUES (?, ?, ?, ?, NOW())`;

    pool.query(query, [user_id, job_id, title, description])
    res.json({ message: 'Report submitted successfully' });;

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

router.get('/getReports', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
      SELECT report_id, title, description, created_at
      FROM report_company
      WHERE user_id = ?
    `, [userId]);
    const reports = results.map((row) => {
      return {
        report_id: row.report_id,
        title: row.title,
        description: row.description,
        created_at: row.created_at,
      };
    });
    res.json(reports);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


//benefitreport
const benefitReportSchema = Joi.object({
  company_name: Joi.string().required(),
  job_position: Joi.string().required(),
  description: Joi.string().required(),
  salary: Joi.number().required().min(0),
  benefit: Joi.string().required(),
  job_id: Joi.string().required(), // สมมุติว่าเป็น string ในการอ้างอิงไอดีงาน
});

module.exports = benefitReportSchema;
router.post("/addBenefitReport", isLoggedIn, async (req, res) => {
  try {
    const { error, value } = benefitReportSchema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({ message: error.details.map((detail) => detail.message) });
    }

    const {
      company_name,
      job_position,
      description,
      salary,
      benefit,
    } = value;

    const user_id = req.user.user_id;
    const job_id = req.body.job_id; // สมมุติว่ามี property job_id ใน req.body

    const datePosted = new Date(); // เวลาปัจจุบัน

    // เพิ่มข้อมูลลงในตาราง benefit_reports
    await pool.query(
      'INSERT INTO benefit_reports (user_id, job_id, company_name, position, description, salary, benefit, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())',
      [user_id, job_id, company_name, job_position, description, salary, benefit, datePosted]
    );

    res.status(200).json({ message: "Benefit report added successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.get('/checkBenefitHistory', isLoggedIn, async (req, res) => {
  try {
    const { jobId } = req.query;
    const userId = req.user.user_id;

    // Check if the user has filled out benefit information for this job
    const [benefitHistory] = await pool.query(
      'SELECT * FROM benefit_reports WHERE job_id = ? AND user_id = ?',
      [jobId, userId]
    );

    // Check if benefitHistory exists
    if (benefitHistory.length > 0) {
      res.json({ benefitHistory });
    } else {
      res.json({ message: 'No benefit information found.' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


/*ให้คะแนนบริษัท*/
// Route for submitting a review
router.post('/sendReview', isLoggedIn, async (req, res) => {
  try {
    const { job_id, rating, comment } = req.body;
    const student_id = req.user.user_id; // Assuming user_id is available in req.user

    // Check if the user has already submitted a review for this job
    const [existingReview] = await pool.query(
      'SELECT * FROM reviews WHERE job_id = ? AND student_id = ?',
      [job_id, student_id]
    );

    if (existingReview.length > 0) {
      // If the user has already submitted a review for this job
      return res.status(400).json({ error: 'You have already submitted a review for this job.' });
    }

    // Insert the review into the database
    const [result] = await pool.query(
      `INSERT INTO reviews (job_id, student_id, rating, comment, created_at, company_id) 
       SELECT ?, ?, ?, ?, NOW(), j.user_id
       FROM jobs AS j 
       WHERE j.job_id = ?`,
      [job_id, student_id, rating, comment, job_id]
    );

    res.json({ message: 'Review submitted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Route for checking review history for a job
router.get('/checkReviewHistory', isLoggedIn, async (req, res) => {
  try {
    const { jobId } = req.query;
    const studentId = req.user.user_id; // Assuming user_id is available in req.user

    // Check if the user has reviewed this job
    const [reviewHistory] = await pool.query(
      'SELECT * FROM reviews WHERE job_id = ? AND student_id = ?',
      [jobId, studentId]
    );

    res.json(reviewHistory);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Route เพื่อดึงข้อมูล applications จากฐานข้อมูล // เน้น coop302
router.get('/getStudentJobs', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  const jobId = req.query.job_id; // รับค่า jobId จาก query parameter ที่ส่งมาจาก frontend
  try {
    const [results] = await pool.query(`
      SELECT *
      FROM applications
      WHERE student_id = ? AND job_id = ?
    `, [userId, jobId]);
    
    const data = results.map((row) => {
      return {
        job_id: row.job_id,
        student_id: row.student_id,
        datetime: row.datetime,
        coop302: row.coop302,
      };
    });
    res.json(data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


module.exports = router;

