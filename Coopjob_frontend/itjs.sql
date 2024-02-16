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
USE itjs;
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (58,62,'mo7rR12cXUUWvJ$jhTiEShsHn8$!q^dPZKUdjH56rh2&0$rl&0yq7j1!If0aBGurE$sLpQFtk0a13v6Y3M$B^a49!HBK@7jb-D=Y'),(61,63,'3rAmxOtubMuFh2d7UXG18FkmmhoSjSDB&w*J*47b/yWMTUgxCmnwGAhos@vcizL8Xk1JYL=AzQZY8BkNmb&Oadhyq=kpHmyN*BvJ');
/*!40000 ALTER TABLE `access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`benefit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `benefit_reports`
--

LOCK TABLES `benefit_reports` WRITE;
/*!40000 ALTER TABLE `benefit_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `benefit_reports` ENABLE KEYS */;
UNLOCK TABLES;

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
  `location` varchar(255) DEFAULT NULL COMMENT 'สถานที่ตั้งบริษัท',
  `description` varchar(255) DEFAULT NULL COMMENT 'เกี่ยวกับเรา\\nเกี่ยวกับบริษัทและการดำเนินกิจการ',
  `expedition` varchar(255) DEFAULT NULL COMMENT 'การเดินทางมาบริษัท',
  `company_video` varchar(500) DEFAULT NULL COMMENT 'วิดีโอแนะนำบริษัท',
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(45) DEFAULT 'recruiter',
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `recruiter_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (13,62,'Company5@gmail.com','jiminjeong','09999999999','jiminjeong@gmail.com','hr','/static/uploads/cd8f-attachment_57810318-e1539290902964.avif','/static/uploads/dd23-1600w-A3NKTylTNBQ.webp','GEORGE VINCENT','[{\"title\":\"สายการบิน\"},{\"title\":\"องค์กรการกุศล\"},{\"title\":\"หห\"}]','08787877','www.google.com','2 ถ.บางมด 1303-2','Based in Bangkok, we pride ourselves in providing comprehensive yet bespoke solutions to service cross-border eCommerce brands.','bts ','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/QyhwSYhX09s?si=16A9HXfOqaWpDzvg\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `favorite_jobs`
--

LOCK TABLES `favorite_jobs` WRITE;
/*!40000 ALTER TABLE `favorite_jobs` DISABLE KEYS */;
INSERT INTO `favorite_jobs` VALUES (1,63,32);
/*!40000 ALTER TABLE `favorite_jobs` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (32,62,'sfdsf','internship','sdfsdf','sfsfsdf','3','[{\"title\":\"นักพัฒนาแอปพลิเคชันมือถือ (Mobile App Developer)\"}]',33,'3',33,'3sfsdf','sdfsdf',3,'2024-01-10','open',NULL,NULL),(33,62,'asdasdas','internship','dasdasda','sdasdasa','22','[{\"title\":\"asdas\"},{\"title\":\"นักพัฒนาเว็บ (Web Developer)\"}]',3,'2',4,'2','asdasdas',222,'2024-01-10','open',NULL,NULL),(34,62,'หปฟห','internship','ปฟหป','ฟหปฟห','ปฟหปฟห','[{\"title\":\"asdaas\"},{\"title\":\"นักพัฒนาเว็บ (Web Developer)\"}]',3,'2',4,'asd','sda',1,'2024-01-10','open',NULL,NULL),(36,62,NULL,NULL,'dgdfg','dfgdfdfg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-10','open','upload','9c94-209456.jpg');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `report_company`
--

LOCK TABLES `report_company` WRITE;
/*!40000 ALTER TABLE `report_company` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_company` ENABLE KEYS */;
UNLOCK TABLES;

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
  `datetime` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`student_job_id`),
  KEY `app_job_id_idx` (`job_id`),
  KEY `app_user_id_idx` (`student_id`),
  CONSTRAINT `app_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `app_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`user_id`),
  CONSTRAINT `app_user_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_jobs`
--

LOCK TABLES `student_jobs` WRITE;
/*!40000 ALTER TABLE `student_jobs` DISABLE KEYS */;
INSERT INTO `student_jobs` VALUES (67,32,63,'canceled',NULL),(68,32,63,'approve',NULL);
/*!40000 ALTER TABLE `student_jobs` ENABLE KEYS */;
UNLOCK TABLES;

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
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`students_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (35,63,NULL,NULL,'Ploythanat1@gmail.com',NULL,NULL,NULL,NULL,'static\\resume\\f7ea-resume4.pdf',NULL,NULL,'close','applicant');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (62,'Company5@gmail.com','$2b$10$Rw8UTyxUDEO0TikJYJrPtOEuIh1meI5mHqkYIUjBpfid9Y3FGiALy','recruiter','open'),(63,'Ploythanat1@gmail.com','$2b$10$XusJmdqk2k4ZjxxAsBsLvOonyxLRaet9zVpSYP6vlKycuOkls4k0G','applicant','close');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-10  7:51:51
