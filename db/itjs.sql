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
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (58,62,'mo7rR12cXUUWvJ$jhTiEShsHn8$!q^dPZKUdjH56rh2&0$rl&0yq7j1!If0aBGurE$sLpQFtk0a13v6Y3M$B^a49!HBK@7jb-D=Y'),(61,63,'3rAmxOtubMuFh2d7UXG18FkmmhoSjSDB&w*J*47b/yWMTUgxCmnwGAhos@vcizL8Xk1JYL=AzQZY8BkNmb&Oadhyq=kpHmyN*BvJ'),(62,64,'eSzm&wT3#xd0hqwMArQGeXlDC&SRAA2KVZ@qqF7IBjFx7/@8c&*1Z^$aoVji$qk/9xq&C=qET7MZ18e4#Clw^X^Wq8NqFGg4fMY6'),(63,65,'8Qkd7DfLj3xonsQdqoIdCTeSfL9FSV4PLQNJfSrL$xEOZOwmWF7gt$1KsePUfc#FUN6D#xAAioz&IZqqU^nq=55JPq2QlrVlUR-#'),(64,66,'6gOVmBvUjVnRL^Z*g4iTKGmd!9Zl!0Dh-j#a@KK9N$gORgGzMGPUGJ&/2936&7X&oZLVcVj1Ve2dC!ZU49EN1eVIWBVx8Mq67raY'),(65,67,'yr#W*&^/5!bNhWJaPJ54RN6Wz3*wNelQLJu23QNBulAL@uMN&1CK@cGWeuv/LuCH=@2#=OX4!EyN^1Pjh=reL2rWD#ZxUtu#Z28L'),(66,68,'fJ9H2RXrT&mlue!Cxt$ZwI9Ags/EG3HvQ3Z&c4/GXtyQRrX4$PJuZhcxf8DSBxLEshqFBzojK8XKpV3OZVLh4cTZhCr#Q2AaGch!');
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
  `position` varchar(225) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
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
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (13,62,'Company5@gmail.com','jiminjeong','09999999999','jiminjeong@gmail.com','hr','/static/uploads/cd8f-attachment_57810318-e1539290902964.avif','/static/uploads/dd23-1600w-A3NKTylTNBQ.webp','GEORGE VINCENT','[{\"title\":\"สายการบิน\"},{\"title\":\"องค์กรการกุศล\"},{\"title\":\"หห\"}]','08787877','www.google.com','2 ถ.บางมด 1303-2','กรุงเทพ 15020','Based in Bangkok, we pride ourselves in providing comprehensive yet bespoke solutions to service cross-border eCommerce brands.','bts ','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/QyhwSYhX09s?si=16A9HXfOqaWpDzvg\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter'),(14,64,'Ploythanat2@gmail.com','jhone','0999999999','jhone@gmail.com','hr','/static/uploads/d7fc-gradient-quill-pen-design-template_23-2149837194.avif','/static/uploads/2f53-1600w-45OLilHu81U.webp','Quillen','[{\"title\":\"เครื่องดื่ม / อาหาร / ภัตตาคาร\"}]','0933333333','www.google.com','13 ','กรุงเทพ 10520','Middle English, from Anglo-French tiste, texte, from Medieval Latin textus, from Latin, texture, context, from texere to weave — more at TECHNICAL','mrt','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/rNSIwjmynYQ?si=pDQ3TBi6wpQJUi-j\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter'),(15,65,'Company1@gmail.com','nanon','07777777','nanon@gmail.com','hr','/static/uploads/db3e-attachment_81643561.jpg','/static/uploads/9883-1600w-gw3gy3_2quM.webp','GC square','[{\"title\":\"ไอที - ฮาร์ดแวร์\"}]','0988978983','www.google.com','1223 dsd ','[{\"province\":\"นนทบุรี\"},{\"amphure\":\"บางกรวย\"},{\"tambon\":\"บางขุนกอง\"},{\"zip_code\":11130}]','에스파, 데뷔 3주년 꿈의 기록을 담은 영화 ','bts','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/xVK5MzuXlWQ?si=TWcJ7esxtufiO0k8\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter'),(16,66,'Ploythanat2@gmail.com','่thiti','099-9999-9999','thiti@gmail.com','hr','/static/uploads/0957-gradient-quill-pen-logo-with-tagline-template_23-2149813051.avif','/static/uploads/bb38-stylish-glowing-digital-red-lines-banner_1017-23964.avif','PEN LOGO','[{\"title\":\"สายการบิน\"},{\"title\":\"องค์กรการกุศล\"},{\"title\":\"หห\"}]','099-9999-9999','https://www.google.com/','1023','[{\"province\":\"กรุงเทพมหานคร\"},{\"amphure\":\"เขตพญาไท\"},{\"tambon\":\"สามเสนใน\"},{\"zip_code\":10400}]','เราเป็นบริษัท ที่ให้บริการด้าน SEO และ การตลาดออนไลน์ ได้แก่ SEO, Google AdWords, Social Media ต่างๆ และ อื่นๆ (SEO & Digital Marketing Agency) ให้บริการลูกค้าทั่วโลก ทั้งในประเทศและต่างประเทศ','ARL : พญาไท','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter'),(17,67,'PPloythanat1@gmail.com','test1','09999998','test1@gmail.com','hr','/static/uploads/b6ef-275953_logo_20201202155742.webp','/static/uploads/5f57-3857872f87a1921.jpg','sss','[{\"title\":\"ไอที - ฮาร์ดแวร์\"}]','099999','-','198 หมู่ 1 ','[{\"province\":\"ปทุมธานี\"},{\"amphure\":\"หนองเสือ\"},{\"tambon\":\"บึงบา\"},{\"zip_code\":12170}]','-','-','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/dfVIBGEXISQ?si=UcbMHzIf-XCHNBC9\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter');
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
-- Dumping data for table `interesting_applicant`
--

LOCK TABLES `interesting_applicant` WRITE;
/*!40000 ALTER TABLE `interesting_applicant` DISABLE KEYS */;
/*!40000 ALTER TABLE `interesting_applicant` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (32,62,'sfdsf','internship','sdfsdf','sfsfsdf','3','[{\"title\":\"นักพัฒนาแอปพลิเคชันมือถือ (Mobile App Developer)\"}]',33,'3',33,'3sfsdf','sdfsdf',3,'2024-01-10','open',NULL,NULL),(33,62,'asdasdas','internship','dasdasda','sdasdasa','22','[{\"title\":\"asdas\"},{\"title\":\"นักพัฒนาเว็บ (Web Developer)\"}]',3,'2',4,'2','asdasdas',222,'2024-01-10','open',NULL,NULL),(71,65,'ssssssssss','internship','sssssssss','sssssssssss','sssssssssssssssssss','[{\"title\":\"นักพัฒนาซอฟต์แวร์ (Software Developer)\"}]',2,'2',4,'sss','sss',22,'2024-01-18','open','form',NULL),(75,65,NULL,NULL,'ffff','ff',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-18','open','upload','static\\uploads\\job-upload-b6bd-88423311_2653218664911246_1011963624299692032_n.png'),(77,66,'-','internship','รับนักศึกษาฝึกงาน ตำแหน่ง Graphic Designer','-ออกแบบสื่อประชาสัมพันธ์ และสื่อมัลติมีเดีย สำหรับลง Website , Line , FB , FB Live , เพจ , Youtube , Content Online\n-ถ่ายภาพนิ่งและวิดีโอ และตัดต่อสำหรับลง Social Media / Website\n-งานอื่นๆ ตามที่ได้รับมอบหมาย','Graphic Designer','[{\"title\":\"graphic designer\"}]',6,'2.5',0,'เสื้อยูนิฟอร์ม ที่พัก แอร์ ,WIFI , พัดลมผนัง , ตู้เย็น ,เครื่องทำน้ำอุ่น','-สามารถใช้งาน lllustrator / Photoshop เบื้องต้นได้\n-ถ่ายภาพได้เบื้องต้น\n-มีความรับผิดชอบต่องานที่ทำ\n-มีมารยาทที่ดี\n-มีทัศนคติ\n-รักในงานบริการ\n-ตรงต่อเวลา\n-มีบุคลิกภาพที่คล่องแคล่วและกระตือรือร้น พร้อมที่เรียนรู้',4,'2024-01-28','close','form',NULL),(78,66,NULL,NULL,'รับสมัครนักศึกษาฝึกงาน','-',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-28','close','upload','static\\uploads\\job-upload-322a-88423311_2653218664911246_1011963624299692032_n.png'),(79,67,'พพพพ','internship','พพพพ','พพพพ','พพพ','[{\"title\":\"พพพพพ\"}]',1,'11',11,'พพ1','พพพพ',2,'2024-02-16','open','form',NULL);
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
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
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
  `coop302` varchar(255) DEFAULT NULL COMMENT 'เก็บที่อยู่ไฟล์ coop 302',
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
-- Dumping data for table `student_jobs`
--

LOCK TABLES `student_jobs` WRITE;
/*!40000 ALTER TABLE `student_jobs` DISABLE KEYS */;
INSERT INTO `student_jobs` VALUES (67,32,63,'canceled',NULL,NULL),(68,32,63,'approve','static\\coop302\\d510-[object Object]ss',NULL),(69,77,68,'approve','static\\coop302\\6b3b-63070078 (1).pdf',NULL);
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
  `coop.302` varchar(255) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`students_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (35,63,NULL,NULL,'Ploythanat1@gmail.com',NULL,NULL,NULL,NULL,'static\\resume\\f7ea-resume4.pdf',NULL,NULL,NULL,'close','applicant'),(36,68,'ธนัชพร3','รัศมีสุริยะ','Ploystudent1@gmail.com','1970-01-01','104 หมู่ 4 ต.เมือง จ.ฉะเชิงเทรา 24110','หญิง','0944434838','static\\resume\\1318-resume3.pdf',NULL,'static\\portfolio\\74c6-resume4.pdf',NULL,'close','applicant');
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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (62,'Ploythanat3@gmail.com','qeqdqdqwdqwq','recruiter','open'),(63,'Ploythanat1@gmail.com','2222222222','applicant','close'),(64,'Ploythanat21@gmail.com','$2b$10$rIbJ9kEqdikKYzxUks2kt.7f5JIJ016mKgSsc4pn8WViGJHEvkSXa','recruiter','open'),(65,'Company2@gmail.com','$2b$10$3zCDuxbuaZVnUIoKF4VLzOOd5uiVV1mzUUYD.io8HnGgLMiXuN/Ru','recruiter','open'),(66,'Ploythanat2@gmail.com','$2b$10$byqm6aRnoeN2vG4PIl1oweWIDDUvFY7ILecoFqLSX0zlrH1hR0mA.','recruiter','close'),(67,'PPloythanat1@gmail.com','$2b$10$mj53bp83pYiQJA1TNNQckuZ.lHgoBkqRhjMFyI5ONrYm3zXHKEkxG','recruiter','close'),(68,'Ploystudent1@gmail.com','$2b$10$s2955G7bdBfYY76Ls24YX.1oyerHds1vm.HndomrTrh3jS3KOGooS','applicant','close');
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

-- Dump completed on 2024-03-06  1:12:04
