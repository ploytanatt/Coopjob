-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: itjs
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_tokens`
--

DROP TABLE IF EXISTS `access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_tokens` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`token_id`),
  KEY `token_user_id_idx` (`user_id`),
  CONSTRAINT `token_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `role` enum('admin') DEFAULT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `benefit_reports`
--

DROP TABLE IF EXISTS `benefit_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `benefit_reports` (
  `benefit_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  `benefit` varchar(45) DEFAULT NULL,
  `salary` int DEFAULT NULL,
  `created_at` varchar(45) DEFAULT NULL,
  `position` varchar(225) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`benefit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL COMMENT 'emailของบัญชี',
  `contact_person_name` varchar(255) DEFAULT NULL COMMENT 'ชื่อผู้ติดต่อ',
  `contact_phone_number` varchar(45) DEFAULT NULL COMMENT 'เบอร์ติดต่อ ของตัวแทนบริษัท',
  `contact_email` varchar(255) DEFAULT NULL COMMENT 'อีเมลของตัวดทนบริษัท',
  `contact_person_department` varchar(255) DEFAULT NULL COMMENT 'แผนก',
  `profile_image` varchar(255) DEFAULT 'static\\uploads\\sorry.png' COMMENT 'โลโก้บริษัท',
  `cover_image` varchar(100) DEFAULT 'static\\uploads\\sorry.png' COMMENT 'ภาพปก',
  `company_name` varchar(255) DEFAULT NULL COMMENT 'ชื่อบริษัท',
  `business_type` varchar(255) DEFAULT NULL COMMENT 'ประเภทธุรกิจ',
  `company_phone_number` varchar(25) DEFAULT NULL COMMENT 'เบอร์โทรศัพท์บริษัท',
  `website` varchar(255) DEFAULT NULL COMMENT 'เว็บไซต์ของบริษัท',
  `address` varchar(255) DEFAULT NULL COMMENT 'บ้านเลขที่ / ซอย',
  `location` varchar(255) DEFAULT '[{"province":""},{"amphure":""},{"tambon":""},{"zip_code":""}]' COMMENT 'สถานที่ตั้งบริษัท จังหวัด, อำเภอ, ตำบล, หรือ รหัสไปรษณีย์',
  `description` varchar(255) DEFAULT NULL COMMENT 'เกี่ยวกับเรา\\nเกี่ยวกับบริษัทและการดำเนินกิจการ',
  `expedition` varchar(255) DEFAULT NULL COMMENT 'การเดินทางมาบริษัท',
  `company_video` longtext COMMENT 'วิดีโอแนะนำบริษัท',
  `status` enum('close','open') DEFAULT 'open',
  `role` varchar(45) DEFAULT 'recruiter',
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `recruiter_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `favorite_jobs`
--

DROP TABLE IF EXISTS `favorite_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_jobs` (
  `favorite_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`favorite_id`),
  KEY `fav_user_id_idx` (`user_id`),
  KEY `fav_job_id_idx` (`job_id`),
  CONSTRAINT `fav_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `fav_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interesting_applicant`
--

DROP TABLE IF EXISTS `interesting_applicant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interesting_applicant` (
  `interesting_id` varchar(45) NOT NULL,
  `student_id` int DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`interesting_id`),
  KEY `interesting_student_id_idx` (`student_id`),
  KEY `interesting_company_id_idx` (`company_id`),
  KEY `interesting_job_id_idx` (`job_id`),
  CONSTRAINT `interesting_company_id` FOREIGN KEY (`company_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `interesting_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `interesting_student_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `job_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL COMMENT 'หัวข้อโครงงาน',
  `job_type` enum('internship','cooperative') DEFAULT NULL COMMENT 'ประเภทงาน',
  `job_title` varchar(255) DEFAULT NULL COMMENT 'ชื่องาน',
  `description` varchar(255) DEFAULT NULL COMMENT 'คำอธิบาย',
  `job_position` varchar(255) DEFAULT NULL COMMENT 'ตำแหน่ง',
  `position_type` varchar(255) DEFAULT NULL COMMENT 'ประเภทตำแหน่งงาน',
  `quantity` int DEFAULT NULL COMMENT 'จำนวนที่รับ',
  `gpa` varchar(45) DEFAULT NULL COMMENT 'GPA',
  `salary` int DEFAULT NULL COMMENT 'ค่าตอบแทน',
  `benefit` varchar(255) DEFAULT NULL COMMENT 'สวัสดิการ',
  `specification` varchar(255) DEFAULT NULL COMMENT 'คุณสมบัติผู้สมัคร\n',
  `internship_duration` int DEFAULT NULL COMMENT 'ระยะเวลาฝึกงาน',
  `date_posted` date DEFAULT NULL COMMENT 'วันที่โพสประกาศ',
  `status` enum('close','open') DEFAULT 'close' COMMENT 'สถานะของโพส เปิด/ปิด',
  `create_type` enum('upload','form') DEFAULT NULL COMMENT 'ประเภทที่สร้างประกาศงาน อัพโหลด/กรอกฟอร์ม',
  `job_upload_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `job_recruiter_id_idx` (`user_id`),
  CONSTRAINT `job_recruiter_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_company`
--

DROP TABLE IF EXISTS `report_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_company` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  `title` enum('job','company','mentor','work','other') DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `created_at` varchar(45) DEFAULT NULL,
  `status` enum('pending','banned','rejected') DEFAULT NULL,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `review_student_id_idx` (`student_id`),
  KEY `review_company_id_idx` (`company_id`),
  KEY `review_job_id_idx` (`job_id`),
  CONSTRAINT `review_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`user_id`),
  CONSTRAINT `review_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `review_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_jobs`
--

DROP TABLE IF EXISTS `student_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_jobs` (
  `student_job_id` int NOT NULL AUTO_INCREMENT,
  `job_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `status` enum('pending','approve','reject','canceled') DEFAULT 'pending',
  `coop.302` varchar(255) DEFAULT NULL COMMENT 'เก็บที่อยู่ไฟล์ coop 302',
  `datetime` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`student_job_id`),
  KEY `app_job_id_idx` (`job_id`),
  KEY `app_user_id_idx` (`student_id`),
  CONSTRAINT `app_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `app_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`user_id`),
  CONSTRAINT `app_user_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `students_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `resume` varchar(255) DEFAULT NULL,
  `transcript` varchar(255) DEFAULT NULL,
  `portfolio` varchar(255) DEFAULT NULL,
  `coop.302` varchar(255) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`students_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('applicant','recruiter') DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-22  2:16:14
