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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (58,62,'mo7rR12cXUUWvJ$jhTiEShsHn8$!q^dPZKUdjH56rh2&0$rl&0yq7j1!If0aBGurE$sLpQFtk0a13v6Y3M$B^a49!HBK@7jb-D=Y'),(61,63,'3rAmxOtubMuFh2d7UXG18FkmmhoSjSDB&w*J*47b/yWMTUgxCmnwGAhos@vcizL8Xk1JYL=AzQZY8BkNmb&Oadhyq=kpHmyN*BvJ'),(62,64,'eSzm&wT3#xd0hqwMArQGeXlDC&SRAA2KVZ@qqF7IBjFx7/@8c&*1Z^$aoVji$qk/9xq&C=qET7MZ18e4#Clw^X^Wq8NqFGg4fMY6'),(63,65,'8Qkd7DfLj3xonsQdqoIdCTeSfL9FSV4PLQNJfSrL$xEOZOwmWF7gt$1KsePUfc#FUN6D#xAAioz&IZqqU^nq=55JPq2QlrVlUR-#'),(64,66,'6gOVmBvUjVnRL^Z*g4iTKGmd!9Zl!0Dh-j#a@KK9N$gORgGzMGPUGJ&/2936&7X&oZLVcVj1Ve2dC!ZU49EN1eVIWBVx8Mq67raY'),(65,67,'yr#W*&^/5!bNhWJaPJ54RN6Wz3*wNelQLJu23QNBulAL@uMN&1CK@cGWeuv/LuCH=@2#=OX4!EyN^1Pjh=reL2rWD#ZxUtu#Z28L'),(66,68,'fJ9H2RXrT&mlue!Cxt$ZwI9Ags/EG3HvQ3Z&c4/GXtyQRrX4$PJuZhcxf8DSBxLEshqFBzojK8XKpV3OZVLh4cTZhCr#Q2AaGch!'),(68,69,'W6NkOL6V!IJaJS*kHDIcn-NveEacXweCQztDcR/O82yKO5fkTniXgzsjU@v9JKb*=cDQIhb5OA1/f2kBZRlUsCd49HPIffFc8@X$'),(69,70,'2m648eF&K@fzk$nGa@COBss=Yfdc54-P6Z4D*LN-o@aUjH7tmJMhwszyWU$SWkeWjJcbkx1rk#BnA^/ZAGqtOLuD!o6YITGRF1jG');
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
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `admin_id_UNIQUE` (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'69',NULL,NULL,NULL,'Admin1@gmail.com');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `job_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `application_status` enum('pending','approve','declined','canceled') DEFAULT 'pending',
  `coop302` varchar(255) DEFAULT NULL COMMENT 'เก็บที่อยู่ไฟล์ coop 302',
  `applied_datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  KEY `app_job_id_idx` (`job_id`),
  KEY `app_user_id_idx` (`student_id`),
  CONSTRAINT `app_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `app_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`user_id`),
  CONSTRAINT `app_user_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (73,80,68,'canceled','static\\coop302\\b549-coop302.pdf','2024-03-17 07:42:15'),(76,71,68,'canceled',NULL,'2024-03-13 11:06:41'),(77,75,68,'canceled',NULL,'2024-03-14 11:08:45'),(78,77,68,'canceled','static\\coop302\\27cf-coop302.pdf','2024-03-12 11:15:09'),(79,77,68,'canceled','static\\coop302\\860b-coop302.pdf','2024-03-18 11:17:53'),(80,78,68,'canceled','static\\coop302\\684a-coop302.pdf','2024-03-18 11:31:55'),(81,84,68,'declined','static\\coop302\\22fc-coop302.pdf','2024-03-21 14:30:57'),(82,77,68,'pending',NULL,'2024-03-27 19:41:52');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
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
  `salary` varchar(45) DEFAULT NULL,
  `created_at` varchar(45) DEFAULT NULL,
  `position` varchar(225) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `benefit_status` enum('pending','complete') DEFAULT 'pending',
  `company_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`benefit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `benefit_reports`
--

LOCK TABLES `benefit_reports` WRITE;
/*!40000 ALTER TABLE `benefit_reports` DISABLE KEYS */;
INSERT INTO `benefit_reports` VALUES (19,68,78,'xxx','100','2024-03-27 19:00:30','xxxx','xxxx','complete',NULL);
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
INSERT INTO `companies` VALUES (13,62,'Company5@gmail.com','jiminjeong','09999999999','jiminjeong@gmail.com','hr','/static/uploads/cd8f-attachment_57810318-e1539290902964.avif','/static/uploads/dd23-1600w-A3NKTylTNBQ.webp','GEORGE VINCENT','[{\"title\":\"สายการบิน\"},{\"title\":\"องค์กรการกุศล\"},{\"title\":\"หห\"}]','08787877','www.google.com','2 ถ.บางมด 1303-2','[{\"province\":\"ปทุมธานี\"},{\"amphure\":\"หนองเสือ\"},{\"tambon\":\"บึงบา\"},{\"zip_code\":12170}]','Based in Bangkok, we pride ourselves in providing comprehensive yet bespoke solutions to service cross-border eCommerce brands.','bts ','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter'),(14,64,'Ploythanat2@gmail.com','jhone','0999999999','jhone@gmail.com','hr','/static/uploads/d7fc-gradient-quill-pen-design-template_23-2149837194.avif','/static/uploads/2f53-1600w-45OLilHu81U.webp','Quillen','[{\"title\":\"เครื่องดื่ม / อาหาร / ภัตตาคาร\"}]','0933333333','www.google.com','13 ','[{\"province\":\"ปทุมธานี\"},{\"amphure\":\"หนองเสือ\"},{\"tambon\":\"บึงบา\"},{\"zip_code\":12170}]','Middle English, from Anglo-French tiste, texte, from Medieval Latin textus, from Latin, texture, context, from texere to weave — more at TECHNICAL','mrt','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter'),(15,65,'Company1@gmail.com','nanon','07777777','nanon@gmail.com','hr','/static/uploads/db3e-attachment_81643561.jpg','/static/uploads/9883-1600w-gw3gy3_2quM.webp','GC square','[{\"title\":\"ไอที - ฮาร์ดแวร์\"}]','0988978983','www.google.com','1223 dsd ','[{\"province\":\"นนทบุรี\"},{\"amphure\":\"บางกรวย\"},{\"tambon\":\"บางขุนกอง\"},{\"zip_code\":11130}]','에스파, 데뷔 3주년 꿈의 기록을 담은 영화 ','bts','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter'),(16,66,'CompanyFortest@gmail.com','่thiti','099-9999-9999','ploythanat1@gmail.com','hr','/static/uploads/087e-a4011003-ae32-4f3a-bb6f-219c6d76b2c0.png','/static/uploads/6099-1600w-45OLilHu81U.webp','PEN LOGO','[{\"title\":\"สายการบิน\"},{\"title\":\"องค์กรการกุศล\"},{\"title\":\"หห\"}]','099-9999-9999','https://www.google.com/','1023','[{\"province\":\"สระแก้ว\"},{\"amphure\":\"เมืองสระแก้ว\"},{\"tambon\":\"ศาลาลำดวน\"},{\"zip_code\":27000}]','เราเป็นบริษัท ที่ให้บริการด้าน SEO และ การตลาดออนไลน์ ได้แก่ SEO, Google AdWords, Social Media ต่างๆ และ อื่นๆ (SEO & Digital Marketing Agency) ให้บริการลูกค้าทั่วโลก ทั้งในประเทศและต่างประเทศ','ARL : พญาไท','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter'),(17,67,'PPloythanat1@gmail.com','test1','09999998','test1@gmail.com','hr','/static/uploads/b6ef-275953_logo_20201202155742.webp','/static/uploads/5f57-3857872f87a1921.jpg','sss','[{\"title\":\"ไอที - ฮาร์ดแวร์\"}]','099999','-','198 หมู่ 1 ','[{\"province\":\"ปทุมธานี\"},{\"amphure\":\"หนองเสือ\"},{\"tambon\":\"บึงบา\"},{\"zip_code\":12170}]','-','-','https://www.youtube.com/watch?v=aPT26Dd3OzE&pp=ygUFZmZ4dmk%3D','open','recruiter');
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
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_jobs`
--

LOCK TABLES `favorite_jobs` WRITE;
/*!40000 ALTER TABLE `favorite_jobs` DISABLE KEYS */;
INSERT INTO `favorite_jobs` VALUES (1,63,32),(145,66,77);
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
  `quantity` int DEFAULT NULL COMMENT 'จำนวนที่รับ',
  `gpa` varchar(45) DEFAULT NULL COMMENT 'GPA',
  `salary` int DEFAULT NULL COMMENT 'ค่าตอบแทน',
  `benefit` varchar(255) DEFAULT NULL COMMENT 'สวัสดิการ',
  `specification` varchar(255) DEFAULT NULL COMMENT 'คุณสมบัติผู้สมัคร\n',
  `internship_duration` int DEFAULT NULL COMMENT 'ระยะเวลาฝึกงาน',
  `date_posted` date DEFAULT NULL COMMENT 'วันที่โพสประกาศ',
  `job_status` enum('close','open') DEFAULT 'close' COMMENT 'สถานะของโพส เปิด/ปิด',
  `create_type` enum('upload','form') DEFAULT NULL COMMENT 'ประเภทที่สร้างประกาศงาน อัพโหลด/กรอกฟอร์ม',
  `job_upload_file` varchar(255) DEFAULT NULL,
  `position_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `job_recruiter_id_idx` (`user_id`),
  CONSTRAINT `job_recruiter_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (32,62,'sfdsf','internship','sdfsdf','sfsfsdf','3',33,'3',300,'3sfsdf','sdfsdf',3,'2024-01-10','open','form',NULL,NULL),(33,62,'asdasdas','internship','dasdasda','sdasdasa','22',3,'2',330,'2','asdasdas',222,'2024-01-10','open','form',NULL,NULL),(71,65,'ssssssssss','internship','sssssssss','sssssssssss','sssssssssssssssssss',2,'2',400,'sss','sss',22,'2024-01-18','open','form',NULL,NULL),(75,65,NULL,'cooperative','ffff','ff',NULL,NULL,NULL,250,NULL,NULL,NULL,'2024-01-18','open','upload','static\\uploads\\job-upload-b6bd-88423311_2653218664911246_1011963624299692032_n.png',NULL),(77,66,'-2','internship','Graphic Designer  1','-ออกแบบสื่อประชาสัมพันธ์ และสื่อมัลติมีเดีย สำหรับลง Website , Line , FB , FB Live , เพจ , Youtube , Content Online\n-ถ่ายภาพนิ่งและวิดีโอ และตัดต่อสำหรับลง Social Media / Website\n-งานอื่นๆ ตามที่ได้รับมอบหมาย','Graphic Designer',6,'2.5',400,'[{\"text\":\"เสื้อฟอร์ม\"},{\"text\":\"สัมนาท่องเที่ยวปลายปี\"}]','[{\"text\":\"เพศ : ชาย-หญิง\"},{\"text\":\"ไม่จำกัดอายุ\"}]',4,'2024-01-28','close','form',NULL,'[{\"title\":\"Graphic Designer \"},{\"title\":\"design\"}]'),(78,66,NULL,'cooperative','ds','sdsds',NULL,NULL,NULL,450,NULL,NULL,NULL,'2024-01-28','open','upload','static\\uploads\\job-upload-2d67-à¸§à¸´à¹à¸à¸à¸´à¸¥.jpg',NULL),(79,67,'พพพพ','cooperative','พพพพ','พพพพ','พพพ',1,'11',400,'พพ1','พพพพ',2,'2024-02-16','open','form',NULL,NULL),(80,66,'fullstack','cooperative','Fullstack','222','22',234,'2',350,'asdas','sadsd',222,'2024-03-06','close','form',NULL,'[{\"title\":\"Web Developer\"}]'),(83,66,'asdad','internship','asdas','dasdasd',NULL,20,'2',500,'[{\"text\":\"2\"},{\"text\":\"3\"},{\"text\":\"5\"}]','[{\"text\":\"2\"}]',2,'2024-03-19','open','form',NULL,'[{\"title\":\"Web Developer\"}]'),(84,66,'sss','internship','ss','ssss',NULL,1,'1',400,'[{\"text\":\"1\"},{\"text\":\"2\"},{\"text\":\"3\"},{\"text\":\"4\"}]','[{\"text\":\"3\"},{\"text\":\"4\"}]',1,'2024-03-19','open','form',NULL,'[{\"title\":\"Software Developer\"}]'),(86,66,'test','internship','test','test',NULL,1,'2',100,'[{\"text\":\"test1\"},{\"text\":\"test2\"},{\"text\":\"test3\"}]','[{\"text\":\"คุณสมบัติtest1\"},{\"text\":\"คุณสมบัติtest2\"},{\"text\":\"คุณสมบัติtest3\"}]',1,'2024-03-27','open','form',NULL,'[{\"title\":\"Front-end Developer\"}]');
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
  `report_title` enum('job','company','mentor','work','other') DEFAULT NULL,
  `report_description` varchar(45) DEFAULT NULL,
  `report_created_at` varchar(45) DEFAULT NULL,
  `report_status` enum('pending','banned','rejected') DEFAULT 'pending',
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_company`
--

LOCK TABLES `report_company` WRITE;
/*!40000 ALTER TABLE `report_company` DISABLE KEYS */;
INSERT INTO `report_company` VALUES (26,68,'job','ฟหกฟห','2024-03-27 18:25:02','pending',78),(27,68,'work','xxxx','2024-03-27 19:01:01','pending',78);
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
  `job_id` int DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `review_created_at` datetime DEFAULT NULL,
  `review_status` enum('complete','pending') DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `review_student_id_idx` (`student_id`),
  KEY `review_job_id_idx` (`job_id`),
  KEY `review_company_id_idx` (`company_id`),
  CONSTRAINT `review_company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`user_id`),
  CONSTRAINT `review_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `review_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (20,68,78,66,5,'good','2024-03-27 19:00:42','complete');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
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
  `academic_year` varchar(45) DEFAULT NULL COMMENT 'ปีการศึกษา',
  `studentID` varchar(45) DEFAULT NULL,
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
  `student_status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`students_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (35,63,NULL,'63070078','ทะนัด','รัาส','Ploythanat1@gmail.com',NULL,NULL,NULL,NULL,'static\\resume\\f7ea-resume4.pdf',NULL,NULL,NULL,'close','applicant'),(36,68,'2563','63070078','ธนัชพร','รัศมีสุริยะ','63070078@kmitl.ac.th','1969-12-25','104 หมู่ 4 ต.เมือง จ.ฉะเชิงเทรา 24110','หญิง','0944445444','static\\resume\\710d-à¸¥à¸à¸à¸°à¹à¸à¸µà¸¢à¸à¹à¸£à¸µà¸¢à¸ à¹à¸à¸­à¸¡ 2 à¸à¸µ 2565.pdf','static\\transcript\\2256-resume3.pdf','static\\portfolio\\74c6-resume4.pdf',NULL,'open','applicant'),(37,70,'2566','63070000','จิรภา','เธียรนิติฐาดล','Ploystudent2@gmail.cos','2000-09-30','นนท์ธารา อพาร์ทเม้นท์ 78/4/6 ซอย เทียนทะเล 20 แขวงแสมดำ เขตบางขุนเทียน กรุงเทพมหานคร 10150','หญิง','0998988552',NULL,NULL,NULL,NULL,'close','applicant');
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
  `role` enum('applicant','recruiter','admin') DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `created_at` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (62,'Ploythanat3@gmail.com','qeqdqdqwdqwq','recruiter','open','2022-03-23 18:30:48.299'),(63,'Ploythanat1@gmail.com','2222222222','applicant','close','2022-03-23 18:30:48.299'),(64,'Ploythanat21@gmail.com','$2b$10$rIbJ9kEqdikKYzxUks2kt.7f5JIJ016mKgSsc4pn8WViGJHEvkSXa','recruiter','open','2023-03-23 18:30:48.299'),(65,'Company2@gmail.com','$2b$10$3zCDuxbuaZVnUIoKF4VLzOOd5uiVV1mzUUYD.io8HnGgLMiXuN/Ru','recruiter','open','2023-03-23 18:30:48.299'),(66,'CompanyFortest@gmail.com','$2b$10$rK5dOIymj0Jvay/pMtrYR.Q67pKWTyUhaGGW4j6nUYfwYGherlSuG','recruiter','close','2024-03-23 18:30:48.299'),(67,'PPloythanat1@gmail.com','$2b$10$mj53bp83pYiQJA1TNNQckuZ.lHgoBkqRhjMFyI5ONrYm3zXHKEkxG','recruiter','close','2024-03-23 18:30:48.299'),(68,'63070078@kmitl.ac.th','$2b$10$s2955G7bdBfYY76Ls24YX.1oyerHds1vm.HndomrTrh3jS3KOGooS','applicant','close','2024-03-23 18:30:48.299'),(69,'Admin1@gmail.com','$2b$10$lTkv53A4RLtdzMAtTzHq..i/BOTODpUDSwj/gG/BfjKJ5drVncYCm','admin','close','2024-03-23 18:30:48.299'),(70,'Ploystudent2@gmail.com','$2b$10$rcQkjDRem/GljpV/g5TlqOWUfp2zCNhnydI2dFOYFm5a9vL5LNbnS','applicant','close','2024-03-23 18:30:48.299');
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

-- Dump completed on 2024-03-28 10:55:12
