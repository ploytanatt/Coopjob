-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: joblink2
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
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
INSERT INTO `access_tokens` VALUES (41,46,'^*N0b6/kc9VQwLNaob&KnNnxUyfUNNArwxsQn/Jl9iX!$YP5St*-YR1O/hBs@pFpzw977@zz/!5mm8RDu1bHZeDi0gj-r3$7McFs'),(42,47,'HdPtRAtXo-NhB!GBtmCCaWgr@a7kPXOkoQ6!/4t#4v*G$1COTWa**WDjm!!5$KwFom0bZvmirJXs^nCjXkq#^QNj3gC64TGPCb!R'),(43,48,'DDDhyXSHT9s/FNBW5qu-CQd*=q7X*$d$fYCC#*HuVUhqWqUJWqQ!*j=!sKANQi$^aWY9Jum0=Nj/vk$qknv1UKO1iqh!FKodySe9'),(44,49,'gFnIqIc5tWVkLbWcRu-yQH^4qwuiR4xctX9O@n2ICAV5jDB9fIKNv*sxxha&lvZXSAn44kzYwlAT8AQzGjKBOZw#=vamy0W2&$Jp'),(45,50,'Z4S$V-w8c7NDdN$B88/hqdm!AH9N!Qf0k&4XoIgnucKZfzs^nHtYB6DeRs771HwikQbp0Q5H2&RVC1C&MJ25CojKwree2r6mVA=c');
/*!40000 ALTER TABLE `access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `applicants`
--

LOCK TABLES `applicants` WRITE;
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
INSERT INTO `applicants` VALUES (30,46,'ธนัชพร','รัศมีสุริยะ','applicantTest1@gmail.com','1970-01-30','หญิง','ลาดกระบัง ','0999999999','static\\resume\\6f82-resume1.pdf','close','applicant'),(31,47,NULL,NULL,'recruiterTest1@gmail.com',NULL,NULL,NULL,NULL,NULL,'close','applicant');
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `favorite_jobs`
--

LOCK TABLES `favorite_jobs` WRITE;
/*!40000 ALTER TABLE `favorite_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `job_applications`
--

LOCK TABLES `job_applications` WRITE;
/*!40000 ALTER TABLE `job_applications` DISABLE KEYS */;
INSERT INTO `job_applications` VALUES (15,20,46,'canceled'),(16,22,46,'approve');
/*!40000 ALTER TABLE `job_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (20,48,'SMT Test-Engineerxxxxxx','Function test program debugging',400,'อ.บ้านบึง จ.ชลบุรี','Good English listening, speaking, reading and writing skills. Toeic 500(inclusive)or more','2023-05-22',2,'open'),(22,48,'Lab Engineer','Carry out test verification work , issue test reports, and assist in problem analysis and improvement',100,'อ.บ้านบึง จ.ชลบุรี','Bachelor degree or above','2023-05-22',2,'open'),(23,49,'Purchasing Office','ประสานงานภายใน และภายนอกองค์กร ใช้ภาษาอังกฤษ เป็นหลัก',333,'อ.บางพลี จ.สมุทรปราการ','การศึกษาระดับปริญญาตรี ปี 3','2023-05-22',2,'open'),(24,49,'Engineer','ติดตั้งเครื่องจักร (เครื่องกลึงอัตโนมัติ หรือ CNC Lathe) และให้บริการซ่อมบำรุง\n',1222,'อ.บางพลี จ.สมุทรปราการ','เพศ : ชาย อายุ (ปี) : 22 - 35ปี\nระดับการศึกษา : ปวช , ปวส , ช่างกล , ช่างไฟฟ้า หรือปริญญาตรี','2023-05-22',1,'open'),(25,50,'trainee','ดูแลเกี่ยวกับ Infrastructure ที่ให้บริการ Cloud Server ให้มีประสิทธิภาพ ทำงานได้อย่างสมบูรณ์',600,'อ.บางพลี จ.สมุทรปราการ','จบการศึกษาระดับปริญญาตรี ในสาขาคอมพิวเตอร์ หรือสาขาที่เกี่ยวข้อง','2023-05-22',2,'open');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `recruiters`
--

LOCK TABLES `recruiters` WRITE;
/*!40000 ALTER TABLE `recruiters` DISABLE KEYS */;
INSERT INTO `recruiters` VALUES (7,48,'one nine one','recruiterTest2@gmail.com','xxxxxxxxxxxxxxxxxxx','static\\uploads\\42cb-209456.jpg','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/H35PG5zerC0\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter'),(8,49,'jvberage','recruiterTest3@gmail.com','coffeee','static\\uploads\\1508-ee4dce1061f3f616224767ad58cb2fc751b8d2dc (1).jfif','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/o-Ikkh5oxuo\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter'),(9,50,'SUSHIRO','recruiterTest4@gmail.com','sushi','static\\uploads\\965a-275953_logo_20201202155742.webp','<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/7UFy4xyYe0s\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen></iframe>','open','recruiter');
/*!40000 ALTER TABLE `recruiters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (46,'applicantTest1@gmail.com','$2b$10$xPsE/O7VhmGaybtNbbO6AOLOXc/Ynh.xarPlYPCpww4Qe9kWB/TA2','applicant','close'),(47,'recruiterTest1@gmail.com','$2b$10$bFSxXwtZiqO79SBKfYA2Ke9NT6Qi0lBYplDGzMJrFPtJIHp6oQ.H2','applicant','close'),(48,'recruiterTest2@gmail.com','$2b$10$s2W5WfJnx5z0W7Zxp5.pBeDd014p0GFIi9WbXKZQmcdgmqrkxG7Dq','recruiter','open'),(49,'recruiterTest3@gmail.com','$2b$10$qXsuaWuR2CjWJZc8lmfSZupC7BEuq/jPTIsVZ4J8LZKuaDRgScIy2','recruiter','open'),(50,'recruiterTest4@gmail.com','$2b$10$g6x.mUE4NEszvI/imGxZSOLyQsbPIBT6XIXi/R2r0kBfMyckLg/4K','recruiter','open');
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

-- Dump completed on 2023-05-22 12:20:26
