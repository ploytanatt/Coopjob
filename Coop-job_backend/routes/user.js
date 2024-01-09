const express = require('express');
const { pool } = require("../config");
const router = express.Router();
const Joi = require('joi');
const bcrypt = require('bcrypt');
const { generateToken } = require("../utils/token");
const { isLoggedIn } = require("../middleware");

const loginSchema = Joi.object({
  email: Joi.string().required(),
  password: Joi.string().required(),
});
router.post("/signin", async (req, res, next) => {
  
  try {
    await loginSchema.validateAsync(req.body, { abortEarly: false });
  } catch (err) {
    return res.status(400).send(err);
  }
  const email = req.body.email;
  const password = req.body.password;
  const conn = await pool.getConnection();
  await conn.beginTransaction();
  try {
    // Check if username is correct
    const [users] = await conn.query("SELECT * FROM users WHERE email=?", [email]);
    const user = users[0];
    if (!user) {
      throw new Error("Incorrect username or password");
    }
    // Check if password is correct
    if (!(await bcrypt.compare(password, user.password))) {
      throw new Error("Incorrect username or password");
    }
    // Check if token already existed
    const [tokens] = await conn.query("SELECT * FROM access_tokens WHERE user_id=?", [user.user_id]);
    let token = tokens[0]?.token;
    if (!token) {
      // Generate and save token into database
      token = generateToken();
      await conn.query("INSERT INTO access_tokens(user_id, token) VALUES (?, ?)", [user.user_id, token]);
        if (user.role === 'applicant') {
          await pool.query('INSERT INTO students (user_id, email) VALUES (?, ?)',[user.user_id, email]);
        }else if (user.role === 'recruiter') {
          await pool.query('INSERT INTO companies (user_id, email) VALUES (?, ?)', [user.user_id, email]);
        
      }
    }
    conn.commit();
    res.status(200).json({ token: token });
  } catch (error) {
    conn.rollback();
    res.status(400).json(error.toString());
  } finally {
    conn.release();
  }
});


router.get("/me", isLoggedIn, async (req, res, next) => {
    // req.user ถูก save ข้อมูล user จาก database ใน middleware function "isLoggedIn"
    
    res.json(req.user);
  });

module.exports = router;
