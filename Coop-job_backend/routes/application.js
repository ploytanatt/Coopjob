const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { generateToken } = require("../utils/token");
const { v4: uuidv4 } = require('uuid');
const { isLoggedIn } = require("../middleware");
const multer = require('multer');
//สมัครงาน
router.post('/sendApplicationJob', isLoggedIn, async (req, res) => {
  try {
    const { job_id, user_id } = req.body;

    // ตรวจสอบว่า user_id นี้เคยสมัคร job_id นี้แล้วหรือไม่ (รวมถึงสถานะ 'cancelled' ถ้าเกิดว่า ยกเลิกแล้วให้สมัครใหม่ได้)
    const [existingApplication] = await pool.query(
      'SELECT * FROM student_jobs WHERE job_id = ? AND student_id = ? AND status != "canceled"',
      [job_id, user_id]
    );

    console.log(existingApplication);

    if (existingApplication.length > 0) {
      // ถ้ามีการสมัครซ้ำแล้วหรือถูกยกเลิก
      return res.status(400).json({ error: 'You have already applied for this job.' });
    }

    // ถ้ายังไม่มีการสมัคร
    const [result] = await pool.query(
      'INSERT INTO student_jobs (job_id, student_id, status, datetime) VALUES (?, ?, ?, now())',
      [job_id, user_id, 'pending']
    );

    res.json({ message: 'Application submitted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Get job applications for a specific user with additional details ใหม่
router.get('/getJobApplications', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
        SELECT ja.student_job_id, ja.student_id, ja.status, ja.datetime, j.job_id, j.job_title AS job_title, j.job_position, c.company_id, c.company_name, c.profile_image
        FROM student_jobs ja
        INNER JOIN jobs j ON ja.job_id = j.job_id
        LEFT JOIN companies c ON j.user_id = c.user_id
        WHERE ja.student_id = ?
    `, [userId]);

    console.log(results); // ล็อกผลลัพธ์เพื่อตรวจสอบโครงสร้าง

    const jobApplications = results.map((row) => {
        return {
            student_job_id: row.student_job_id,
            student_id: row.student_id,
            status: row.status,
            datetime: row.datetime,
            job: {
                job_id: row.job_id,
                title: row.job_title,
                job_position: row.job_position,
            },
            company: {
                company_id: row.company_id,
                company_name: row.company_name,
                profile_image: row.profile_image,
            },
        };
    });

    res.json(jobApplications);
} catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
}

});

router.put('/cancelJob/:applicationId', isLoggedIn, async (req, res) => {
  const { status } = req.body;
  const applicationId = req.params.applicationId;
  try {
    await pool.query('UPDATE student_jobs SET status = ? WHERE student_job_id = ?', [status, applicationId]);
    res.json({ message: 'Cancel job application successful' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Get job applications for a specific recruiter
router.get('/getApplication/:applicationId', isLoggedIn, async (req, res) => {
  const applicationId = req.params.applicationId;
  try {
    // ดึงข้อมูลแอพลิเคชันโดยใช้ applicationId
    const applications = await pool.query('SELECT * FROM student_jobs WHERE student_job_id = ?', [applicationId]);
    res.json(applications);
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
    SELECT ja.*, j.job_title as job_title
    FROM student_jobs ja
    INNER JOIN jobs j ON ja.job_id = j.job_id
    WHERE j.user_id = ?
    
      `, [recruiterId]);
    const applications = results.map((row) => {
      return {
        id: row.student_job_id,
        studentName: row.student_name,
        position: row.job_title,
        applicationDate: row.application_date,
        status: row.status,
      };
    });
    // console.log(applications)
    res.json(applications);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

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

router.put('/updateStatus/:applicationId', isLoggedIn, upload.single('coopfile'), async (req, res) => {
  const applicationId = req.params.applicationId;
  const { status } = req.body;
  const filePath = req.file.path;
  try {
    await pool.query('UPDATE student_jobs SET status = ?, coop302 = ? WHERE student_job_id = ?', [status, filePath, applicationId]);
    res.json({ message: 'อัพโหลดไฟล์สำเร็จ' });
    console.log("update job apllication successfuly")
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

router.get('/getApplicationDetails/:applicationId', async (req, res) => {
  try {
    const applicationId = req.params.applicationId;
    const [applicationResult] = await pool.query('SELECT student_id FROM student_jobs WHERE student_job_id = ?', [applicationId]);
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
// Add this to your backend routes
router.post('/sendReport', isLoggedIn, async (req, res) => {
  console.log('Received a POST request to /application/sendReport', req.body);
  try {
    const { job_id, user_id, title, description } = req.body;

    // Set job_id based on title
    const updatedJobId = job_id;

    // Save the report details to the database or perform any necessary actions ใส่ now()เพื่อให้เอาวันที่ปัจจุบันมา
    const query = `INSERT INTO report_company (user_id, job_id, title, description, created_at) VALUES (?, ?, ?, ?, NOW())`;

    // ใช้ pool.query แทน connection.query
    pool.query(query, [user_id, job_id, title, description], (error, results, fields) => {
      if (error) {
        console.error(error);
        res.status(500).json({ error: 'Server error' });
      } else {
        res.json({ message: 'Report submitted successfully' });
      }
    });

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

    // ตัวแปรที่จำเป็นสำหรับ benefit_reports
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



module.exports = router;

