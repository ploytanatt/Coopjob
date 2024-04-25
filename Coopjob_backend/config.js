
const mysql = require("mysql2/promise");
require("dotenv").config(); //ใข้งาน .env

const password = `${process.env.DB_PASSWORD}`;
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password:password, // ใช้ env 
  database: 'coop',
  connectionLimit: 10,
});

module.exports = {
  pool,
};
