const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { generateToken } = require("../utils/token");
const { isLoggedIn } = require("../middleware");
/*สมัครงาน
router.post('/sendApplicationJob',isLoggedIn, async (req, res) => {
    try {
      const { job_id, user_id } = req.body;
      const [result] = await pool.query(
        'INSERT INTO student_jobs (job_id, student_id, status) VALUES (?, ?, ?)',
        [job_id, user_id, 'pending']
      );
  
      res.json({ message: 'Application submitted successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Server error' });
    }
});*/
//สมัครงานอันใหม่
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
      'INSERT INTO student_jobs (job_id, student_id, status) VALUES (?, ?, ?)',
      [job_id, user_id, 'pending']
    );

    res.json({ message: 'Application submitted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


//Get job applications for a specific user
router.get('/getJobApplications', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
        SELECT ja.job_id, ja.student_id, ja.status, j.job_title, ja.student_job_id
        FROM student_jobs ja
        INNER JOIN jobs j ON ja.job_id = j.job_id
        WHERE ja.student_id = ?
      `, [userId]);
    const jobApplications = results.map((row) => {
      return {
        student_job_id: row.student_job_id,
        student_id: row.student_id,
        status: row.status,
        job: {
          job_id: row.job_id,
          title: row.title,
        },
      };
    });
    res.json(jobApplications);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

//ดึงมาเฉพาะงานที่ approve แล้ว
// ยังไม่ได้ใช้ เพราะใช้ v-if status = approve แทน
/*router.get('/getApproveJob', isLoggedIn, async (req, res) => {
  const userId = req.user.user_id;
  try {
    const [results] = await pool.query(`
        SELECT ja.job_id, ja.student_id, ja.status, j.title, ja.student_job_id
        FROM student_jobs ja
        INNER JOIN jobs j ON ja.job_id = j.job_id
        WHERE ja.student_id = ? AND ja.status = 'approve'
      `, [userId]);
    const approvedJobApplications = results.map((row) => {
      return {
        student_job_id: row.student_job_id,
        student_id: row.student_id,
        status: row.status,
        job: {
          job_id: row.job_id,
          title: row.title,
        },
      };
    });
    res.json(approvedJobApplications);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});*/



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
router.put('/updateStatus/:applicationId', isLoggedIn, async (req, res) => {
  const applicationId = req.params.applicationId;
  const { status } = req.body;
  try {
    await pool.query('UPDATE student_jobs SET status = ? WHERE student_job_id = ?', [status, applicationId]);
    res.json({ message: 'Update application status successful' });
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
        SELECT fj.*, j.job_title as job_title
        FROM favorite_jobs fj
        INNER JOIN jobs j ON fj.job_id = j.job_id
        WHERE fj.user_id = ?
      `, [userId]);
    const FavoriteJobs = results.map((row) => {
      return {
        favorite_job_id: row.favorite_job_id,
        job_id: row.job_id,  // เพิ่มค่า job_id ที่ตรงกับ user_id
        jobTitle: row.job_title,
        likedDate: row.liked_date,
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
    const updatedJobId = (title === 'Company') ? job_id : null;

    // Save the report details to the database or perform any necessary actions ใส่ now()เพื่อให้เอาวันที่ปัจจุบันมา
    const query = `INSERT INTO report_company (user_id, job_id, title, description, created_at) VALUES (?, ?, ?, ?, NOW())`;

    // ใช้ pool.query แทน connection.query
    pool.query(query, [user_id, updatedJobId, title, description], (error, results, fields) => {
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




module.exports = router;

