const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { isLoggedIn } = require("../middleware");
const multer = require('multer');
const path = require('path');
const fs = require('fs');


// รายชื่อนักศึกษาทั้งหมด และ จำนวนงานที่สมัคร
router.get('/students/application-stats', async (req, res) => {
    try {
        const [results] = await pool.query(`
           SELECT 
                students.user_id, 
                students.students_id,
                students.studentID, 
                students.academic_year, 
                students.firstName, 
                students.lastName, 
                students.email, 
                COUNT(applications.application_id) AS applications_count
            FROM students
            LEFT JOIN applications ON students.user_id = applications.student_id
            GROUP BY students.user_id,students.academic_year,  students.students_id, students.studentID, students.firstName, students.lastName, students.email;
        `);
        res.json(results);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// รายละเอียดของนักศึกษา
router.get('/studentDetail/:studentId', async (req, res) => {
    try {
        const { studentId } = req.params; // รับ studentId จาก URL parameter
        const [results] = await pool.query(`
            SELECT *
            FROM students
            WHERE students.user_id = ?
        `, [studentId]);

        if (results.length > 0) {
            res.json(results[0]); // ส่งค่ากลับเป็น JSON ของรายละเอียดนักศึกษา
        } else {
            res.status(404).json({ message: 'Student not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// งานที่นักศึกษาแต่ละคนสมัคร
router.get('/studentApplications/:studentId', async (req, res) => {
    try {
        const { studentId } = req.params;
        const [results] = await pool.query(`
                SELECT ja.*, j.*, c.*
        FROM applications ja
        INNER JOIN jobs j ON ja.job_id = j.job_id
        LEFT JOIN companies c ON j.user_id = c.user_id
        WHERE ja.student_id = ?
        `, [studentId]);
    res.json(results); 
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// รายชื่อบริษัททั้งหมด และข้อมูลการสมัครงาน
router.get('/companyList', async (req, res) => {
    try {
        const [companyList] = await pool.query(`
            SELECT
                c.user_id,
                c.company_name,
                c.profile_image, 
                c.status,
                COUNT(DISTINCT j.job_id) AS total_jobs,
                COUNT(a.application_id) AS total_applications,
                SUM(CASE WHEN a.application_status = 'approve' THEN 1 ELSE 0 END) AS approve_applications,
                COALESCE(AVG(r.rating), 0) AS average_rating
            FROM companies c
            LEFT JOIN jobs j ON c.user_id = j.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            LEFT JOIN reviews r ON c.user_id = r.company_id
            GROUP BY c.user_id, c.company_name, c.profile_image, c.status;
        `);
        res.json(companyList);
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal server error');
    }
});

// รายละเอียดของบริษัท
router.get('/companyDetail/:companyId', async (req, res) => {
    try {
        const { companyId } = req.params; // รับ studentId จาก URL parameter
        const [results] = await pool.query(`
            SELECT *
            FROM companies
            WHERE companies.user_id = ?
        `, [ companyId ]);
        if (results.length > 0) {
            res.json(results[0]);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
// งานที่บริษัทประกาศ
router.get('/companyJobs/:companyId', async (req, res) => {
    try {
        const { companyId } = req.params;
        const [results] = await pool.query(`
         SELECT
                j.job_id,
                j.job_title,
                j.salary,
                j.job_status,
                j.job_type,
                COUNT(a.application_id) AS total_applications,
                SUM(CASE WHEN a.application_status = 'approve' THEN 1 ELSE 0 END) AS approve_applications
            FROM jobs j
            LEFT JOIN applications a ON j.job_id = a.job_id
            WHERE j.user_id = ?
            GROUP BY j.job_id, j.job_title, j.salary, j.job_status, j.job_type
        `, [companyId]);
        res.json(results); 
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

//แสดงงานทั้งหมดที่ประกาศ
router.get("/getAllJobs", async (req, res) => {
  try {
     const [jobList] = await pool.query(`
            SELECT
                c.user_id,
                c.company_name,
                c.profile_image,
                j.job_id,
                j.job_title,
                j.job_type,
                j.job_status,
                J.date_posted,
                j.salary,
                COUNT(DISTINCT j.job_id) AS total_jobs,
                COUNT(a.application_id) AS total_applications,
                SUM(CASE WHEN a.application_status = 'approve' THEN 1 ELSE 0 END) AS approve_applications,
                COALESCE(AVG(r.rating), 0) AS average_rating
            FROM companies c
            LEFT JOIN jobs j ON c.user_id = j.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            LEFT JOIN reviews r ON c.user_id = r.company_id
            GROUP BY c.user_id, j.job_id, c.company_name, c.profile_image, j.job_type, j.job_title, j.job_status, J.date_posted, j.salary;
        `);
        res.json(jobList);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// คำร้องเรียนทั้งหมด
router.get('/ReportList', async (req, res) => {
  try {
    const query = `
      SELECT
        rc.user_id,
        rc.report_id,
        rc.report_title,
        rc.report_description,
        rc.report_description,
        rc.report_status,
        rc.job_id,
        j.job_title,
        j.job_type,
        j.job_status,
        j.date_posted,
        s.firstName,
        s.lastName,
        SUM(CASE WHEN rc.report_status != 'pending' THEN 1 ELSE 0 END) AS processed_report,
        SUM(CASE WHEN rc.report_status = 'pending' THEN 1 ELSE 0 END) AS pending_report
      FROM report_company rc
      LEFT JOIN jobs j ON rc.job_id = j.job_id
      LEFT JOIN students s ON rc.user_id = s.user_id
      GROUP BY rc.user_id, rc.report_id, rc.report_title, rc.report_description, rc.report_description, rc.report_status, rc.job_id, j.job_type, j.job_title, j.job_status, j.date_posted, s.firstName, s.lastName;
    `;
    const [jobList] = await pool.query(query);
    res.json(jobList);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

// รายละเอียดคำร้องเรียน
router.get('/ReportDetail/:reportId', async (req, res) => {
    try {
        const { reportId } = req.params; // รับ studentId จาก URL parameter
        const [results] = await pool.query(`
            SELECT rc.*, j.user_id, j.job_title, s.firstName, s.lastName, c.company_name, c.profile_image
            FROM report_company rc
            LEFT JOIN students s ON rc.user_id = s.user_id
            LEFT JOIN jobs j ON rc.job_id = j.job_id
            LEFT JOIN companies c ON j.user_id = c.user_id
            WHERE rc.report_id = ?
        `, [ reportId ]);
        if (results.length > 0) {
            res.json(results[0]);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.get('/ApplicationList', async (req, res) => {
    try {
        const [results] = await pool.query(`
            SELECT a.*, j.user_id, j.job_title, s.firstName, s.lastName, j.job_type, c.company_name, c.profile_image
            FROM applications a
            LEFT JOIN students s ON a.student_id = s.user_id
            LEFT JOIN jobs j ON a.job_id = j.job_id
            LEFT JOIN companies c ON j.user_id = c.user_id
            
        `,);
        if (results.length > 0) {
            res.json(results);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/BenefitList', async (req, res) => {
    try {
        const [results] = await pool.query(`
            SELECT br.*, j.user_id, j.job_title, s.firstName, s.lastName,s.studentID, j.job_type, c.company_name, c.profile_image
            FROM benefit_reports br
            LEFT JOIN students s ON br.user_id = s.user_id
            LEFT JOIN jobs j ON br.job_id = j.job_id
            LEFT JOIN companies c ON j.user_id = c.user_id
            
        `,);
        if (results.length > 0) {
            res.json(results);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// รายละเอียดคำร้องเรียน
router.get('/BenefitDetail/:benefitId', async (req, res) => {
    try {
        const { benefitId } = req.params; // รับ studentId จาก URL parameter
        const [results] = await pool.query(`
            SELECT br.*, j.user_id, j.job_title, s.firstName, s.lastName, s.studentID, c.company_name, c.profile_image
            FROM benefit_reports br
            LEFT JOIN students s ON br.user_id = s.user_id
            LEFT JOIN jobs j ON br.job_id = j.job_id
            LEFT JOIN companies c ON j.user_id = c.user_id
            WHERE br.benefit_id = ?
        `, [ benefitId ]);
        if (results.length > 0) {
            res.json(results[0]);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


// รายชื่อบริษัททั้งหมด และข้อมูลการสมัครงาน
router.get('/companyReview', async (req, res) => {
    try {
        const [companyList] = await pool.query(`
            SELECT
                c.user_id,
                c.company_name,
                c.profile_image, 
                c.status,
                COUNT(DISTINCT r.review_id) AS total_reviews,
                COUNT(a.application_id) AS total_applications,
                SUM(CASE WHEN a.application_status = 'approve' THEN 1 ELSE 0 END) AS approve_applications,
                COALESCE(AVG(r.rating), 0) AS average_rating
            FROM companies c
            LEFT JOIN jobs j ON c.user_id = j.user_id
            LEFT JOIN applications a ON j.job_id = a.job_id
            LEFT JOIN reviews r ON c.user_id = r.company_id
            GROUP BY c.user_id, c.company_name, c.profile_image, c.status;
        `);
        res.json(companyList);
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal server error');
    }
});


router.get('/getRecruiterReviews/:companyId', async (req, res) => {
  const { companyId } = req.params;

  try {
      const reviewsQuery = `
          SELECT 
            r.*,
            c.user_id AS company_user_id,
            j.job_title,
            s.firstName,
            s.lastName,
            (SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE company_id = ?) AS average_rating
          FROM reviews AS r
          JOIN companies AS c ON r.company_id = c.user_id
          JOIN jobs AS j ON j.job_id = r.job_id
          JOIN students AS s ON s.user_id = r.student_id
          WHERE r.company_id = ?
      `;

      const [reviews] = await pool.query(reviewsQuery, [companyId, companyId]);
      res.json(reviews);
  } catch (error) {
      console.error('Error getting recruiter reviews:', error);
      res.status(500).json({ message: 'Error getting recruiter reviews' });
  }
});

//overview
router.get('/ApproveApplicationList', async (req, res) => {
    try {
        const [results] = await pool.query(`
            SELECT a.*, j.user_id, j.job_title, s.firstName, s.lastName, j.job_type, c.company_name, c.profile_image
            FROM applications a
            LEFT JOIN students s ON a.student_id = s.user_id
            LEFT JOIN jobs j ON a.job_id = j.job_id
            LEFT JOIN companies c ON j.user_id = c.user_id
            WHERE a.application_status = "approve"
        `,);
        if (results.length > 0) {
            res.json(results);
        } else {
            res.status(404).json({ message: 'Company not found' }); // ถ้าไม่พบนักศึกษา
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/Allusers', async (req, res) => {
    try {
        const [results] = await pool.query(` SELECT * FROM users WHERE users.role != "admin" `);
        res.json(results);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
module.exports = router;
