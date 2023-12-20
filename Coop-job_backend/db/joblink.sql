-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	8.0.22

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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (33,37,'ITcJ4/f54TWa2SFf-k@j^2aMVRqvymF4$iKbO03MexLxi/$CbVM7O#APXaA7kzBznj0dKGuabw@hkKgPo4f#DNRWkRdCt6sRt5R$'),(34,39,'j1eW^vDmHIw7DgS0NK2XSI*V*IylAV8$g&i0f!&rudmub!!EJU^QjgJEwHm6VAsPomy1Q*MZ!VGdKUynzs5qk&aR@*kmH8J1hSbJ'),(35,40,'vl^^44aZHGlMFhJMr6U#uktA0t&PM23Hh&a^vg*jsYRB12jcfD5E9mit=IyeFWztfzoOF-YzjRKyyPmyNHVbom#Ej4k*i/xMsdIs');
/*!40000 ALTER TABLE `access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicants`
--

DROP TABLE IF EXISTS `applicants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicants` (
  `applicant_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `resume` varchar(255) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(255) DEFAULT 'applicant',
  PRIMARY KEY (`applicant_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `applicant_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicants`
--

LOCK TABLES `applicants` WRITE;
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
INSERT INTO `applicants` VALUES (12,37,'ธนัชพร','รัศมีสุริยะ','Applicant1@gmail.com','2007-10-24','หญิง','bankkok','0999999999','static\\uploads\\resume2.pdf','close','applicant'),(16,39,'Toydddd','P','Ploy1@gmail.com','1969-12-30','ชาย','aaaaaa','0999999999','static\\resume\\2470-resume1.pdf','close','applicant');
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;
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
-- Table structure for table `job_applications`
--

DROP TABLE IF EXISTS `job_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `job_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `status` enum('pending','approve','reject') DEFAULT 'pending',
  PRIMARY KEY (`application_id`),
  KEY `app_job_id_idx` (`job_id`),
  KEY `app_user_id_idx` (`user_id`),
  CONSTRAINT `app_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `app_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_applications`
--

LOCK TABLES `job_applications` WRITE;
/*!40000 ALTER TABLE `job_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_applications` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (15,40,'กฟหกฟหsss','wwwwwwwwwwww',23,'ฟหกฟห','asdsa','2023-05-21',21,'close'),(16,40,'sssssssss','adasdas',222,'sssssssssssssssss','asdasdasd','2023-05-22',222,'close');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recruiters`
--

DROP TABLE IF EXISTS `recruiters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recruiters` (
  `recruiter_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `company_video` varchar(500) DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'close',
  `role` varchar(45) DEFAULT 'recruiter',
  PRIMARY KEY (`recruiter_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  CONSTRAINT `recruiter_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recruiters`
--

LOCK TABLES `recruiters` WRITE;
/*!40000 ALTER TABLE `recruiters` DISABLE KEYS */;
INSERT INTO `recruiters` VALUES (2,40,'zzzs','Company1@gmail.com','zzzzf','static\\uploads\\6d72-winter.jpg','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/yK4mTN3B1d8\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','close','recruiter');
/*!40000 ALTER TABLE `recruiters` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (37,'Applicant1@gmail.com','Applicant1@gmail.com','applicant','close'),(39,'Ploy1@gmail.com','$2b$10$swV71IAgTbttL6XQg8KMX.xsQnOkXuSeiq4h71ntsBxnPPapjK6j.','applicant','close'),(40,'Company1@gmail.com','$2b$10$AXgvfaiSEnNDTt1D53esxeju0KyED0USQIbxMBIzAXRG232Th5JcK','recruiter','close');
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

-- Dump completed on 2023-05-22  1:44:09
