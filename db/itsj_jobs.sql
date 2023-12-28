-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: itjs
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
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `job_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `job_position` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `application_start_date` date DEFAULT NULL,
  `application_end_date` date DEFAULT NULL,
  `salary` int DEFAULT NULL,
  `benefit` varchar(45) DEFAULT NULL,
  `specification` varchar(255) DEFAULT NULL,
  `date_posted` date DEFAULT NULL,
  `internship_duration` int DEFAULT NULL,
  `status` enum('close','open') DEFAULT 'open',
  `job_type` enum('internship','cooperative') DEFAULT NULL,
  `GPA` float DEFAULT NULL,
  `woking_time` varchar(45) DEFAULT NULL,
  `expedition` varchar(255) DEFAULT NULL,
  `coop_title` varchar(45) DEFAULT NULL,
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
INSERT INTO `jobs` VALUES (20,48,NULL,'SMT Test-Engineerxxxxxx',NULL,'Function test program debugging','อ.บ้านบึง จ.ชลบุรี',NULL,NULL,NULL,400,NULL,'Good English listening, speaking, reading and writing skills. Toeic 500(inclusive)or more','2023-05-22',2,'open',NULL,NULL,NULL,NULL,NULL),(22,48,NULL,'Lab Engineer',NULL,'Carry out test verification work , issue test reports, and assist in problem analysis and improvement','อ.บ้านบึง จ.ชลบุรี',NULL,NULL,NULL,100,NULL,'Bachelor degree or above','2023-05-22',2,'open',NULL,NULL,NULL,NULL,NULL),(23,49,NULL,'Purchasing Office',NULL,'ประสานงานภายใน และภายนอกองค์กร ใช้ภาษาอังกฤษ เป็นหลัก','อ.บางพลี จ.สมุทรปราการ',NULL,NULL,NULL,333,NULL,'การศึกษาระดับปริญญาตรี ปี 3','2023-05-22',2,'open',NULL,NULL,NULL,NULL,NULL),(24,49,NULL,'Engineer',NULL,'ติดตั้งเครื่องจักร (เครื่องกลึงอัตโนมัติ หรือ CNC Lathe) และให้บริการซ่อมบำรุง\n','อ.บางพลี จ.สมุทรปราการ',NULL,NULL,NULL,1222,NULL,'เพศ : ชาย อายุ (ปี) : 22 - 35ปี\nระดับการศึกษา : ปวช , ปวส , ช่างกล , ช่างไฟฟ้า หรือปริญญาตรี','2023-05-22',1,'open',NULL,NULL,NULL,NULL,NULL),(25,50,NULL,'trainee',NULL,'ดูแลเกี่ยวกับ Infrastructure ที่ให้บริการ Cloud Server ให้มีประสิทธิภาพ ทำงานได้อย่างสมบูรณ์','อ.บางพลี จ.สมุทรปราการ',NULL,NULL,NULL,600,NULL,'จบการศึกษาระดับปริญญาตรี ในสาขาคอมพิวเตอร์ หรือสาขาที่เกี่ยวข้อง','2023-05-22',2,'open',NULL,NULL,NULL,NULL,NULL),(26,52,NULL,'aaa',NULL,'1das','aaa',NULL,NULL,NULL,1111,NULL,'das','2023-09-21',1,'open',NULL,NULL,NULL,NULL,NULL),(27,50,NULL,'ux/ui',NULL,'zzzzzzzzzzzzzzz','zzzzzzz',NULL,NULL,NULL,100,NULL,'zzzzzzzzz','2023-09-22',1,'open',NULL,NULL,NULL,NULL,NULL),(28,50,NULL,'ux design',NULL,'zzzzzzz','zzzzzzzzzz',NULL,NULL,NULL,111,NULL,'zzzzzzzz','2023-09-22',2,'open',NULL,NULL,NULL,NULL,NULL),(29,50,NULL,'ux ui design',NULL,'xxxxxx','sssss',NULL,NULL,NULL,1000,NULL,'xxxx','2023-09-22',2,'open',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-28 12:34:30
