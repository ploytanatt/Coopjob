CREATE DATABASE  IF NOT EXISTS `itjs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `itjs`;
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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (41,46,'^*N0b6/kc9VQwLNaob&KnNnxUyfUNNArwxsQn/Jl9iX!$YP5St*-YR1O/hBs@pFpzw977@zz/!5mm8RDu1bHZeDi0gj-r3$7McFs'),(42,47,'HdPtRAtXo-NhB!GBtmCCaWgr@a7kPXOkoQ6!/4t#4v*G$1COTWa**WDjm!!5$KwFom0bZvmirJXs^nCjXkq#^QNj3gC64TGPCb!R'),(43,48,'DDDhyXSHT9s/FNBW5qu-CQd*=q7X*$d$fYCC#*HuVUhqWqUJWqQ!*j=!sKANQi$^aWY9Jum0=Nj/vk$qknv1UKO1iqh!FKodySe9'),(44,49,'gFnIqIc5tWVkLbWcRu-yQH^4qwuiR4xctX9O@n2ICAV5jDB9fIKNv*sxxha&lvZXSAn44kzYwlAT8AQzGjKBOZw#=vamy0W2&$Jp'),(45,50,'Z4S$V-w8c7NDdN$B88/hqdm!AH9N!Qf0k&4XoIgnucKZfzs^nHtYB6DeRs771HwikQbp0Q5H2&RVC1C&MJ25CojKwree2r6mVA=c'),(46,51,'Mojm/OrOl09W^POd-V^YQCj=$hM!JgJS8&Vofs!U705H9L=F1VgH15vDittUWvJWlHZQkLGUmvvJ/8^Mw3=kL@E4Z2HGWwf9!gzi'),(47,52,'oq0^Sw5wzX!Jdj9/JiWlRi2=NmYndoluDmiNii8WE&U=p=Z0Z^Zvw-P2mpU5R5G17&2SAj4E$MQYTIi=UCU0YZ$mpH@4x89XAC56'),(54,56,'-SJ1/uS$qSF6nwL&XFA-nhxiXqS^#h91n2KScK5AF9LlEI=sqfz46oSW6m-J0ESwea8/RNQ^2e0VhAzJ!cK/ceu#xMMThoqwwcT1');
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
  `company_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT 'static\\uploads\\sorry.png',
  `company_video` varchar(500) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(45) DEFAULT 'recruiter',
  `cover_image_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `recruiter_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (7,48,'one nine one','recruiterTest2@gmail.com','xxxxxxxxxxxxxxxxxxx','static\\uploads\\42cb-209456.jpg','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/H35PG5zerC0\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter',NULL),(8,49,'jvberage','recruiterTest3@gmail.com','coffeee','static\\uploads\\1508-ee4dce1061f3f616224767ad58cb2fc751b8d2dc (1).jfif','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/o-Ikkh5oxuo\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter',NULL),(9,50,'SUSHIRO2','recruiterTest4@gmail.com','sushi','static\\uploads\\c6ee-ee4dce1061f3f616224767ad58cb2fc751b8d2dc.jfif','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/7UFy4xyYe0s\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter',NULL),(10,52,'aaaa','ploythanat2@gmail.com','aaaa','static\\uploads\\54fc-pf2.jfif','null','open','recruiter',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_jobs`
--

LOCK TABLES `favorite_jobs` WRITE;
/*!40000 ALTER TABLE `favorite_jobs` DISABLE KEYS */;
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
  `company_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `salary` int DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `qualifications` varchar(255) DEFAULT NULL,
  `date_posted` date DEFAULT NULL,
  `internship_duration` int DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'open',
  PRIMARY KEY (`job_id`),
  KEY `job_recruiter_id_idx` (`user_id`),
  CONSTRAINT `job_recruiter_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (20,48,NULL,'SMT Test-Engineerxxxxxx','Function test program debugging',400,'อ.บ้านบึง จ.ชลบุรี','Good English listening, speaking, reading and writing skills. Toeic 500(inclusive)or more','2023-05-22',2,'open'),(22,48,NULL,'Lab Engineer','Carry out test verification work , issue test reports, and assist in problem analysis and improvement',100,'อ.บ้านบึง จ.ชลบุรี','Bachelor degree or above','2023-05-22',2,'open'),(23,49,NULL,'Purchasing Office','ประสานงานภายใน และภายนอกองค์กร ใช้ภาษาอังกฤษ เป็นหลัก',333,'อ.บางพลี จ.สมุทรปราการ','การศึกษาระดับปริญญาตรี ปี 3','2023-05-22',2,'open'),(24,49,NULL,'Engineer','ติดตั้งเครื่องจักร (เครื่องกลึงอัตโนมัติ หรือ CNC Lathe) และให้บริการซ่อมบำรุง\n',1222,'อ.บางพลี จ.สมุทรปราการ','เพศ : ชาย อายุ (ปี) : 22 - 35ปี\nระดับการศึกษา : ปวช , ปวส , ช่างกล , ช่างไฟฟ้า หรือปริญญาตรี','2023-05-22',1,'open'),(25,50,NULL,'trainee','ดูแลเกี่ยวกับ Infrastructure ที่ให้บริการ Cloud Server ให้มีประสิทธิภาพ ทำงานได้อย่างสมบูรณ์',600,'อ.บางพลี จ.สมุทรปราการ','จบการศึกษาระดับปริญญาตรี ในสาขาคอมพิวเตอร์ หรือสาขาที่เกี่ยวข้อง','2023-05-22',2,'open'),(26,52,NULL,'aaa','1das',1111,'aaa','das','2023-09-21',1,'open'),(27,50,NULL,'ux/ui','zzzzzzzzzzzzzzz',100,'zzzzzzz','zzzzzzzzz','2023-09-22',1,'open'),(28,50,NULL,'ux design','zzzzzzz',111,'zzzzzzzzzz','zzzzzzzz','2023-09-22',2,'open'),(29,50,NULL,'ux ui design','xxxxxx',1000,'sssss','xxxx','2023-09-22',2,'open');
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
  `title` enum('company','mentor','work','other') DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_jobs`
--

LOCK TABLES `student_jobs` WRITE;
/*!40000 ALTER TABLE `student_jobs` DISABLE KEYS */;
INSERT INTO `student_jobs` VALUES (15,20,46,'canceled',NULL),(16,22,46,'approve',NULL),(17,20,51,'canceled',NULL),(18,25,51,'approve',NULL),(19,25,51,'approve',NULL),(20,25,51,'pending',NULL),(21,22,51,'pending',NULL),(22,23,51,'pending',NULL),(51,20,NULL,'pending',NULL),(56,27,NULL,'pending',NULL);
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
  `porfolio` varchar(255) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`students_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (30,46,'ธนัชพร','รัศมีสุริยะ','applicantTest1@gmail.com','1970-01-30','ลาดกระบัง ','หญิง','0999999999','static\\resume\\6f82-resume1.pdf',NULL,NULL,'close','applicant'),(31,47,NULL,NULL,'recruiterTest1@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'close','applicant'),(32,51,'aaaa','ssss','ploythanat1@gmail.com','1969-12-31','sss','ชาย','0944444444','static\\resume\\a0a3-resume1.pdf',NULL,NULL,'close','applicant'),(33,56,'aaaa','bbbbbb','student1@gmail.com','1970-01-01','xxxxxxx','หญิง','0999999999','static\\resume\\4d62-resume1.pdf',NULL,NULL,'close','applicant');
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (46,'applicantTest1@gmail.com','$2b$10$xPsE/O7VhmGaybtNbbO6AOLOXc/Ynh.xarPlYPCpww4Qe9kWB/TA2','applicant','close'),(47,'recruiterTest1@gmail.com','$2b$10$bFSxXwtZiqO79SBKfYA2Ke9NT6Qi0lBYplDGzMJrFPtJIHp6oQ.H2','applicant','close'),(48,'recruiterTest2@gmail.com','$2b$10$s2W5WfJnx5z0W7Zxp5.pBeDd014p0GFIi9WbXKZQmcdgmqrkxG7Dq','recruiter','open'),(49,'recruiterTest3@gmail.com','$2b$10$qXsuaWuR2CjWJZc8lmfSZupC7BEuq/jPTIsVZ4J8LZKuaDRgScIy2','recruiter','open'),(50,'recruiterTest4@gmail.com','$2b$10$g6x.mUE4NEszvI/imGxZSOLyQsbPIBT6XIXi/R2r0kBfMyckLg/4K','recruiter','open'),(51,'ploythanat1@gmail.com','$2b$10$TtGe/FTr4KjnhOpbBKPm/uIC1poJcCK8GNEORjFdcZRfblOt79vIu','applicant','close'),(52,'ploythanat2@gmail.com','$2b$10$mtipBQYQ0bNTX4LXGMKMQ.uZZ0/kDLeLTtJmJ/KicdnH3TbFzXhvq','recruiter','open'),(53,'ploythanat3@gmail.com','$2b$10$2OhjSgBb5g97Zo02S3BW1OPgMXv5oWFuEeBlxPZdv4QQbMlQeHPnm','recruiter','close'),(54,'ploythanat4@gmail.com','$2b$10$cWTYH/UGD0qAf9h1Vc8.fO.tn9txvx4rd2/gbvY3goCK17HK4CiZO','recruiter','close'),(55,'studenttest1@gmail.com','$2b$10$ogLGxNkTnjmIdUbINJ3l7u97ISzvgDGJGko2NytuYUFJriTv0FmVe','applicant','close'),(56,'student1@gmail.com','$2b$10$tJuDk602ZF4jMxYz0ssSQO7dWiKeGDFzBH5kuVtvrU3JaPRgwqY1.','applicant','close');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'itjs'
--

--
-- Dumping routines for database 'itjs'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-07 19:58:39
