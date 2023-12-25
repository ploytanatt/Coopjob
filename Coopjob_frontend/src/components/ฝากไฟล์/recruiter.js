const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { isLoggedIn } = require("../middleware");
const { v4: uuidv4 } = require('uuid');
const multer = require('multer');
router.get('/getData', isLoggedIn, async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM companies WHERE user_id=?', [req.user.user_id]);
    console.log("applicant GetData", req.user.user_id)
    res.status(200).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// GET all companies
router.get("/getRecruiter", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM companies");
    res.status(200).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

const passwordValidator = (value, helpers) => {
    if (value.length < 8) {
      throw new Joi.ValidationError("Password must contain at least 8 characters");
    }
    if (!(value.match(/[a-z]/) && value.match(/[A-Z]/) && value.match(/[0-9]/))) {
      throw new Joi.ValidationError("Password must be harder");
    }
    return value;
  };
  
  const signupSchema = Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required().custom(passwordValidator),
    confirm_password: Joi.string().required().valid(Joi.ref("password")),
  });
  
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM users');
    res.status(200).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

router.post('/signup', async (req, res) => {
  try {
    await signupSchema.validateAsync(req.body, { abortEarly: false });
  } catch (err) {
    return res.status(400).send(err);
  }
  try {
    const email = req.body.email;
    const password = req.body.password;
    const role = "recruiter";

    // เข้ารหัสรหัสผ่านก่อนเก็บในฐานข้อมูล
    const hashedPassword = await bcrypt.hash(password, 10);

    const [existingUser] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);

    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // บันทึกผู้ใช้ในฐานข้อมูล
    await pool.query('INSERT INTO users (email, password, role) VALUES (?, ?, ? )', [email, hashedPassword, role]);
    console.log("User registered successfully")
    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

//สำหรับตรวจสอบไฟล์ ที่รับมา
const profileEditSchema = Joi.object({
  company_name: Joi.string().required(),
  email: Joi.string().email().required(),
  description: Joi.string().required(),
  company_video: Joi.string().required(),
});

// ตั้งค่า multer upload
const upload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'static/uploads/'); // กำหนดโฟลเดอร์ที่จะเก็บไฟล์ให้เป็น static/resume/
    },
    filename: function (req, file, cb) {
      const uniqueFileName = `${uuidv4().slice(0, 4)}-${file.originalname}`;
      cb(null, uniqueFileName); // กำหนดชื่อไฟล์เก็บในโฟลเดอร์เป็นชื่อที่ไม่ซ้ำกัน
    }
  }),
  limits: {
    fileSize: 15 * 1024 * 1024  // กำหนดขนาดสูงสุดของไฟล์เป็น 15MB
  }
});

router.post("/editProfile", isLoggedIn, upload.single('profile_image'), async (req, res) => {
  try {
    // ตรวจสอบความถูกต้องของข้อมูลที่รับเข้ามา
    const { error } = profileEditSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ message: error.details[0].message });
    }

    // ดึงข้อมูลบริษัทที่ต้องการแก้ไขจากฐานข้อมูล
    const {
      company_name,
      email,
      description,
      company_video,
    } = req.body;
    const companyId = req.user.user_id;
    const filePath = req.file.path;
    const status = 'open'
    // ตรวจสอบว่าอีเมลใหม่ซ้ำกับที่มีอยู่ในตาราง companies หรือไม่
    const [existingRecruiter] = await pool.query('SELECT * FROM companies WHERE email = ?', [email]);
    if (existingRecruiter.length > 0 && existingRecruiter[0].user_id !== companyId) {
      return res.status(400).json({ message: 'Email already exists' });
    }
      await pool.query('UPDATE companies SET company_name = ?, email = ?, description = ?, profile_image = ?, company_video = ?, status = ? WHERE user_id = ?',[company_name, email, description, filePath, company_video, status, companyId]);
      await pool.query('UPDATE users SET status = ? WHERE user_id = ?', [status, companyId])
      console.log("Recruiter edit Successfuly")

       res.json({ message: 'File uploaded successfully', profile_image:filePath , });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server error" });
  }
});

const addJobSchema = Joi.object({
  title: Joi.string().required(),
  location: Joi.string().required(),
  salary: Joi.number().required().min(0),
  status: Joi.string().valid("open", "close").required(),
  description: Joi.string().required(),
  qualifications: Joi.string().required(),
  internship_duration: Joi.number().min(0),
});

router.post("/addJob", isLoggedIn, async (req, res) => {
  try {
    // ตรวจสอบความถูกต้องของข้อมูลที่รับเข้ามา
    const { error, value } = addJobSchema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({ message: error.details.map((detail) => detail.message) });
    }
    // สร้างข้อมูลงานใหม่
    const {
      title,
      location,
      salary,
      description,
      qualifications,
      internship_duration,
      status,
    } = value;

    // เพิ่มข้อมูลวันที่
    const datePosted = new Date(); // เวลาปัจจุบัน
    // เพิ่มข้อมูลงานใหม่ลงในตาราง jobs
    await pool.query(
      'INSERT INTO jobs (user_id, title, location, salary, description, qualifications, date_posted, internship_duration, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [req.user.user_id, title, location, salary, description, qualifications, datePosted, internship_duration, status]
    );

    console.log("addJob ", );
    res.status(200).json({ message: "Job added successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

//แสดงงานทั้งหมด ของผู้ใช้
router.get("/getJob", isLoggedIn, async (req, res) => {
  try {
    const userId = req.user.user_id;
    const [rows] = await pool.query("SELECT * FROM jobs WHERE user_id = ?", [userId]);
    res.status(200).json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

//ลบงานตาม job_id ที่ส่งมา
router.delete("/deleteJob/:job_id", isLoggedIn, async (req, res) => {
  try {
    const { job_id } = req.params;

    await pool.query('DELETE FROM jobs WHERE job_id = ?', [job_id]);
    res.status(200).json({ message: "Job deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

//ดึงรายละเอียดของงานตามjob_id ที่ส่งมา
router.get("/getJobDetails/:job_id", isLoggedIn, async (req, res) => {
  try {
    const { job_id } = req.params;
    const [jobDetails] = await pool.query("SELECT * FROM jobs WHERE job_id = ?", [job_id]);
    if (jobDetails.length === 0) {
      return res.status(404).json({ message: "Job not found" });
    }
  //ส่งรายละเอียดกลับไป
    res.status(200).json(jobDetails[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

const updateJobSchema = Joi.object({
  title: Joi.string().required(),
  location: Joi.string().required(),
  salary: Joi.number().min(0).required(),
  status: Joi.string().valid('open', 'close').required(),
  description: Joi.string().required(),
  qualifications: Joi.string().required(),
  internship_duration: Joi.number().min(0).required(),
});

router.put('/updateJob/:jobId', isLoggedIn, async (req, res) => {
  try {
    const { jobId } = req.params;
    const { error, value } = updateJobSchema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({ message: error.details.map((detail) => detail.message) });
    }
    const {
      title,
      location,
      salary,
      status,
      description,
      qualifications,
      internship_duration,
    } = value;
  
    await pool.query(
      'UPDATE jobs SET title = ?, location = ?, salary = ?, status = ?, description = ?, qualifications = ?, internship_duration = ? WHERE job_id = ?',
      [title, location, salary, status, description, qualifications, internship_duration, jobId]
    );
  
    res.status(200).json({ message: 'Job updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});


// Get recruiter details
router.get('/getRecruiterDetails/:companyId', async (req, res) => {
  const companyId = req.params.companyId;
  try {
    const [results] = await pool.query('SELECT * FROM companies WHERE user_id = ?', [companyId]);
    if (results.length > 0) {
      const recruiter = results[0];
      res.json(recruiter);
    } else {
      res.status(404).json({ message: 'Recruiter not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get company jobs
router.get('/getCompanyJobs/:companyId', async (req, res) => {
  const companyId = req.params.companyId;
  try {
    const [results] = await pool.query('SELECT * FROM jobs WHERE user_id = ?', [companyId]);
    if (results.length > 0) {
      res.json(results);
    } else {
      res.status(404).json({ message: 'No jobs found for this company' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// job details
router.get('/getJobDetail/:jobId', async (req, res) => {
  try {
    const jobId = req.params.jobId;
    const [results] = await pool.query('SELECT * FROM jobs WHERE job_id = ?', [jobId]);
    // Assuming the results contain a single job object
    const job = results[0];
    res.json(job);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;