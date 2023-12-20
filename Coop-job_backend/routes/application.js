const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { generateToken } = require("../utils/token");
const { isLoggedIn } = require("../middleware");
//สมัครงาน
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
});
// //Get job applications for a specific user
router.get('/getJobApplications', isLoggedIn, async (req, res) => {
    const userId = req.user.user_id;
    try {
        const [results] = await pool.query(`
        SELECT ja.job_id, ja.student_id, ja.status, j.title, ja.student_job_id
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
        SELECT ja.*, j.title as job_title
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
module.exports = router;
