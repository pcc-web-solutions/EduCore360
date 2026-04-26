-- MySQL dump 10.13  Distrib 9.1.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: educore360
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `academic_level`
--

DROP TABLE IF EXISTS `academic_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_level` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `level_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stage_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `level_name` (`level_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_level`
--

/*!40000 ALTER TABLE `academic_level` DISABLE KEYS */;
INSERT INTO `academic_level` VALUES (1,'Pre-Primary',1),(2,'Lower Primary',2),(3,'Upper Primary',3),(4,'Junior Secondary',4),(5,'Senior Secondary',5),(6,'Tertiary Education',6);
/*!40000 ALTER TABLE `academic_level` ENABLE KEYS */;

--
-- Table structure for table `academic_session`
--

DROP TABLE IF EXISTS `academic_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `year` year NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `term_no` int NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_code` (`session_code`),
  KEY `school` (`school`),
  CONSTRAINT `academic_session_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_session`
--

/*!40000 ALTER TABLE `academic_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_session` ENABLE KEYS */;

--
-- Table structure for table `admission_request`
--

DROP TABLE IF EXISTS `admission_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admission_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'other',
  `level_applied` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `docs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('submitted','under_review','accepted','rejected','waitlisted') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'submitted',
  `application_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `decision_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_admissions_school` (`school`),
  CONSTRAINT `fk_admissions_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission_request`
--

/*!40000 ALTER TABLE `admission_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `admission_request` ENABLE KEYS */;

--
-- Table structure for table `assessment`
--

DROP TABLE IF EXISTS `assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `assessment_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `assessment_type` enum('Formative','Summative','National','Practical','Project','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Formative',
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `term` smallint DEFAULT NULL,
  `year` year DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_assessment_code` (`assessment_code`),
  KEY `idx_ass_class` (`class`),
  KEY `ass_fk_school` (`school`),
  KEY `ass_fk_subject` (`subject`),
  CONSTRAINT `ass_fk_class` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ass_fk_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ass_fk_subject` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment`
--

/*!40000 ALTER TABLE `assessment` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessment` ENABLE KEYS */;

--
-- Table structure for table `assessment_result`
--

DROP TABLE IF EXISTS `assessment_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_result` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `assessment_id` int NOT NULL,
  `competency_id` int DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `level_descriptor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `recorded_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `recorded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ar_adm` (`adm_no`),
  KEY `idx_ar_ass` (`assessment_id`),
  KEY `ar_fk_school` (`school`),
  KEY `ar_fk_competency` (`competency_id`),
  CONSTRAINT `ar_fk_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `assessment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ar_fk_competency` FOREIGN KEY (`competency_id`) REFERENCES `competency` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ar_fk_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ar_fk_student` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_result`
--

/*!40000 ALTER TABLE `assessment_result` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessment_result` ENABLE KEYS */;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `record_id` int DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `audit_log_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,NULL,'UPDATE','chart_of_account',1,'','','2025-09-22 07:00:49',NULL),(2,NULL,'UPDATE','chart_of_account',2,'','','2025-09-22 07:00:49',NULL),(3,NULL,'UPDATE','chart_of_account',3,'','','2025-09-22 07:00:49',NULL),(4,NULL,'UPDATE','chart_of_account',4,'','','2025-09-22 07:00:49',NULL),(5,NULL,'UPDATE','chart_of_account',5,'','','2025-09-22 07:00:49',NULL),(6,NULL,'UPDATE','chart_of_account',6,'','','2025-09-22 07:00:49',NULL),(7,NULL,'UPDATE','chart_of_account',7,'','','2025-09-22 07:00:49',NULL),(8,NULL,'UPDATE','chart_of_account',8,'','','2025-09-22 07:00:49',NULL),(9,NULL,'UPDATE','chart_of_account',9,'','','2025-09-22 07:00:49',NULL),(10,NULL,'UPDATE','chart_of_account',10,'','','2025-09-22 07:00:49',NULL),(11,NULL,'UPDATE','chart_of_account',11,'','','2025-09-22 07:00:49',NULL),(12,NULL,'UPDATE','chart_of_account',12,'','','2025-09-22 07:00:49',NULL),(13,NULL,'UPDATE','chart_of_account',13,'','','2025-09-22 07:00:49',NULL),(14,NULL,'UPDATE','chart_of_account',14,'','','2025-09-22 07:00:49',NULL),(15,NULL,'UPDATE','chart_of_account',15,'','','2025-09-22 07:00:49',NULL),(16,NULL,'UPDATE','chart_of_account',16,'','','2025-09-22 07:00:49',NULL),(17,NULL,'UPDATE','chart_of_account',17,'','','2025-09-22 07:00:49',NULL),(18,NULL,'UPDATE','chart_of_account',18,'','','2025-09-22 07:00:49',NULL),(19,NULL,'UPDATE','chart_of_account',19,'','','2025-09-22 07:00:49',NULL),(20,NULL,'UPDATE','chart_of_account',20,'','','2025-09-22 07:00:49',NULL),(21,NULL,'UPDATE','chart_of_account',21,'','','2025-09-22 07:00:49',NULL),(22,NULL,'UPDATE','chart_of_account',22,'','','2025-09-22 07:00:49',NULL),(23,NULL,'UPDATE','chart_of_account',23,'','','2025-09-22 07:00:49',NULL),(24,NULL,'UPDATE','chart_of_account',24,'','','2025-09-22 07:00:49',NULL),(25,NULL,'UPDATE','chart_of_account',25,'','','2025-09-22 07:00:49',NULL),(26,NULL,'UPDATE','chart_of_account',26,'','','2025-09-22 07:00:49',NULL),(27,NULL,'UPDATE','chart_of_account',27,'','','2025-09-22 07:00:49',NULL),(28,NULL,'UPDATE','chart_of_account',28,'','','2025-09-22 07:00:49',NULL),(29,NULL,'UPDATE','chart_of_account',29,'','','2025-09-22 07:00:49',NULL),(30,NULL,'UPDATE','chart_of_account',30,'','','2025-09-22 07:00:49',NULL),(31,NULL,'UPDATE','chart_of_account',31,'','','2025-09-22 07:00:49',NULL),(32,NULL,'UPDATE','chart_of_account',32,'','','2025-09-22 07:00:49',NULL),(33,NULL,'UPDATE','chart_of_account',33,'','','2025-09-22 07:00:49',NULL),(34,NULL,'UPDATE','chart_of_account',34,'','','2025-09-22 07:00:49',NULL),(35,NULL,'UPDATE','chart_of_account',35,'','','2025-09-22 07:00:49',NULL),(36,NULL,'UPDATE','chart_of_account',36,'','','2025-09-22 07:00:49',NULL),(37,NULL,'UPDATE','chart_of_account',37,'','','2025-09-22 07:00:49',NULL),(38,NULL,'UPDATE','chart_of_account',38,'','','2025-09-22 07:00:49',NULL),(39,NULL,'UPDATE','chart_of_account',39,'','','2025-09-22 07:00:49',NULL),(40,NULL,'UPDATE','chart_of_account',40,'','','2025-09-22 07:00:49',NULL),(41,NULL,'UPDATE','chart_of_account',41,'','','2025-09-22 07:00:49',NULL),(42,NULL,'UPDATE','chart_of_account',42,'','','2025-09-22 07:00:49',NULL),(43,NULL,'UPDATE','chart_of_account',43,'','','2025-09-22 07:00:49',NULL),(44,NULL,'UPDATE','chart_of_account',44,'','','2025-09-22 07:00:49',NULL),(45,NULL,'UPDATE','chart_of_account',45,'','','2025-09-22 07:00:49',NULL),(46,NULL,'UPDATE','chart_of_account',46,'','','2025-09-22 07:00:49',NULL),(47,NULL,'UPDATE','chart_of_account',47,'','','2025-09-22 07:00:49',NULL),(48,NULL,'UPDATE','chart_of_account',48,'','','2025-09-22 07:00:49',NULL),(49,NULL,'UPDATE','chart_of_account',49,'','','2025-09-22 07:00:49',NULL),(50,NULL,'UPDATE','chart_of_account',50,'','','2025-09-22 07:00:49',NULL),(51,NULL,'UPDATE','chart_of_account',51,'','','2025-09-22 07:00:49',NULL),(52,NULL,'UPDATE','chart_of_account',52,'','','2025-09-22 07:00:49',NULL),(53,NULL,'UPDATE','chart_of_account',53,'','','2025-09-22 07:00:49',NULL),(54,NULL,'UPDATE','chart_of_account',54,'','','2025-09-22 07:00:49',NULL),(55,NULL,'UPDATE','chart_of_account',55,'','','2025-09-22 07:00:49',NULL),(56,NULL,'UPDATE','chart_of_account',56,'','','2025-09-22 07:00:49',NULL),(57,NULL,'UPDATE','chart_of_account',57,'','','2025-09-22 07:00:49',NULL),(58,NULL,'UPDATE','chart_of_account',58,'','','2025-09-22 07:00:49',NULL),(59,NULL,'UPDATE','chart_of_account',59,'','','2025-09-22 07:00:49',NULL),(60,NULL,'UPDATE','chart_of_account',60,'','','2025-09-22 07:00:49',NULL),(61,NULL,'UPDATE','chart_of_account',1,'','','2025-09-22 07:38:53',NULL),(62,NULL,'UPDATE','chart_of_account',2,'','','2025-09-22 07:38:53',NULL),(63,NULL,'UPDATE','chart_of_account',3,'','','2025-09-22 07:38:53',NULL),(64,NULL,'UPDATE','chart_of_account',4,'','','2025-09-22 07:39:29',NULL),(65,NULL,'UPDATE','chart_of_account',5,'','','2025-09-22 07:39:29',NULL),(66,NULL,'UPDATE','chart_of_account',6,'','','2025-09-22 07:39:29',NULL),(67,NULL,'UPDATE','chart_of_account',7,'','','2025-09-22 07:39:29',NULL),(68,NULL,'UPDATE','chart_of_account',8,'','','2025-09-22 07:39:29',NULL),(69,NULL,'UPDATE','chart_of_account',9,'','','2025-09-22 07:39:29',NULL),(70,NULL,'UPDATE','chart_of_account',10,'','','2025-09-22 07:39:29',NULL),(71,NULL,'UPDATE','chart_of_account',11,'','','2025-09-22 07:41:13',NULL),(72,NULL,'UPDATE','chart_of_account',12,'','','2025-09-22 07:41:14',NULL),(73,NULL,'UPDATE','chart_of_account',13,'','','2025-09-22 07:41:14',NULL),(74,NULL,'UPDATE','chart_of_account',14,'','','2025-09-22 07:41:14',NULL),(75,NULL,'UPDATE','chart_of_account',15,'','','2025-09-22 07:41:14',NULL),(76,NULL,'UPDATE','chart_of_account',16,'','','2025-09-22 07:41:14',NULL),(77,NULL,'UPDATE','chart_of_account',17,'','','2025-09-22 07:41:14',NULL),(78,NULL,'UPDATE','chart_of_account',18,'','','2025-09-22 07:41:14',NULL),(79,NULL,'UPDATE','chart_of_account',19,'','','2025-09-22 07:41:14',NULL),(80,NULL,'UPDATE','chart_of_account',20,'','','2025-09-22 07:41:14',NULL),(81,NULL,'UPDATE','chart_of_account',21,'','','2025-09-22 07:41:14',NULL),(82,NULL,'UPDATE','chart_of_account',22,'','','2025-09-22 07:41:14',NULL),(83,NULL,'UPDATE','chart_of_account',23,'','','2025-09-22 07:41:14',NULL),(84,NULL,'UPDATE','chart_of_account',24,'','','2025-09-22 07:41:14',NULL),(85,NULL,'UPDATE','chart_of_account',25,'','','2025-09-22 07:41:14',NULL),(86,NULL,'UPDATE','chart_of_account',26,'','','2025-09-22 07:41:14',NULL),(87,NULL,'UPDATE','chart_of_account',27,'','','2025-09-22 07:41:14',NULL),(88,NULL,'UPDATE','chart_of_account',28,'','','2025-09-22 07:43:17',NULL),(89,NULL,'UPDATE','chart_of_account',29,'','','2025-09-22 07:43:18',NULL),(90,NULL,'UPDATE','chart_of_account',30,'','','2025-09-22 07:43:18',NULL),(91,NULL,'UPDATE','chart_of_account',31,'','','2025-09-22 07:43:18',NULL),(92,NULL,'UPDATE','chart_of_account',32,'','','2025-09-22 07:43:18',NULL),(93,NULL,'UPDATE','chart_of_account',33,'','','2025-09-22 07:43:18',NULL),(94,NULL,'UPDATE','chart_of_account',34,'','','2025-09-22 07:43:18',NULL),(95,NULL,'UPDATE','chart_of_account',35,'','','2025-09-22 07:43:18',NULL),(96,NULL,'UPDATE','chart_of_account',36,'','','2025-09-22 07:43:18',NULL),(97,NULL,'UPDATE','chart_of_account',37,'','','2025-09-22 07:43:18',NULL),(98,NULL,'UPDATE','chart_of_account',38,'','','2025-09-22 07:43:18',NULL),(99,NULL,'UPDATE','chart_of_account',39,'','','2025-09-22 07:43:18',NULL),(100,NULL,'UPDATE','chart_of_account',40,'','','2025-09-22 07:43:18',NULL),(101,NULL,'UPDATE','chart_of_account',41,'','','2025-09-22 07:43:18',NULL),(102,NULL,'UPDATE','chart_of_account',42,'','','2025-09-22 07:43:18',NULL),(103,NULL,'UPDATE','chart_of_account',43,'','','2025-09-22 07:43:18',NULL),(104,NULL,'UPDATE','chart_of_account',44,'','','2025-09-22 07:43:18',NULL),(105,NULL,'UPDATE','chart_of_account',45,'','','2025-09-22 07:43:18',NULL),(106,NULL,'UPDATE','chart_of_account',46,'','','2025-09-22 07:44:24',NULL),(107,NULL,'UPDATE','chart_of_account',47,'','','2025-09-22 07:44:24',NULL),(108,NULL,'UPDATE','chart_of_account',48,'','','2025-09-22 07:44:24',NULL),(109,NULL,'UPDATE','chart_of_account',49,'','','2025-09-22 07:44:24',NULL),(110,NULL,'UPDATE','chart_of_account',50,'','','2025-09-22 07:44:24',NULL),(111,NULL,'UPDATE','chart_of_account',51,'','','2025-09-22 07:44:24',NULL),(112,NULL,'UPDATE','chart_of_account',52,'','','2025-09-22 07:44:24',NULL),(113,NULL,'UPDATE','chart_of_account',53,'','','2025-09-22 07:44:25',NULL),(114,NULL,'UPDATE','chart_of_account',54,'','','2025-09-22 07:44:25',NULL),(115,NULL,'UPDATE','chart_of_account',55,'','','2025-09-22 07:44:25',NULL),(116,NULL,'UPDATE','chart_of_account',56,'','','2025-09-22 07:44:25',NULL),(117,NULL,'UPDATE','chart_of_account',57,'','','2025-09-22 07:44:25',NULL),(118,NULL,'UPDATE','chart_of_account',58,'','','2025-09-22 07:44:25',NULL),(119,NULL,'UPDATE','chart_of_account',59,'','','2025-09-22 07:44:25',NULL),(120,NULL,'UPDATE','chart_of_account',60,'','','2025-09-22 07:44:25',NULL),(121,NULL,'UPDATE','chart_of_account',27,'','','2025-09-22 07:02:21',NULL),(122,NULL,'UPDATE','chart_of_account',28,'','','2025-09-22 07:02:21',NULL),(123,NULL,'UPDATE','chart_of_account',29,'','','2025-09-22 07:02:21',NULL),(124,NULL,'UPDATE','chart_of_account',30,'','','2025-09-22 07:02:21',NULL),(125,NULL,'UPDATE','chart_of_account',31,'','','2025-09-22 07:02:22',NULL),(126,NULL,'UPDATE','chart_of_account',32,'','','2025-09-22 07:02:22',NULL),(127,NULL,'UPDATE','chart_of_account',33,'','','2025-09-22 07:02:22',NULL),(128,NULL,'UPDATE','chart_of_account',34,'','','2025-09-22 07:02:22',NULL),(129,NULL,'UPDATE','chart_of_account',35,'','','2025-09-22 07:02:22',NULL),(130,NULL,'UPDATE','chart_of_account',36,'','','2025-09-22 07:02:22',NULL),(131,NULL,'UPDATE','chart_of_account',37,'','','2025-09-22 07:02:22',NULL),(132,NULL,'UPDATE','chart_of_account',38,'','','2025-09-22 07:02:22',NULL);
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;

--
-- Table structure for table `bank_account`
--

DROP TABLE IF EXISTS `bank_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `account_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `branch` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KES',
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  CONSTRAINT `bank_account_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_account`
--

/*!40000 ALTER TABLE `bank_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_account` ENABLE KEYS */;

--
-- Table structure for table `bank_transaction`
--

DROP TABLE IF EXISTS `bank_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bank_account_id` int NOT NULL,
  `type` enum('Deposit','Withdrawal','Transfer') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `date` date NOT NULL,
  `reference_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `bank_account_id` (`bank_account_id`),
  CONSTRAINT `bank_transaction_ibfk_2` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_transaction`
--

/*!40000 ALTER TABLE `bank_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_transaction` ENABLE KEYS */;

--
-- Table structure for table `base_unit_of_measure`
--

DROP TABLE IF EXISTS `base_unit_of_measure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_unit_of_measure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `abbreviation` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category_id` int NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `symbol` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `si_unit` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `abbreviation` (`abbreviation`),
  KEY `idx_base_unit_category` (`category_id`),
  CONSTRAINT `fk_base_uom_category` FOREIGN KEY (`category_id`) REFERENCES `unit_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_unit_of_measure`
--

/*!40000 ALTER TABLE `base_unit_of_measure` DISABLE KEYS */;
INSERT INTO `base_unit_of_measure` VALUES (1,'Gram','g',1,NULL,'g',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(2,'Kilogram','kg',1,NULL,'kg',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(3,'Meter','m',2,NULL,'m',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(4,'Centimeter','cm',2,'','cm',1,1,'2025-04-20 12:35:46','2025-04-20 15:52:14'),(5,'Liter','L',3,NULL,'Γäô',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(6,'Milliliter','mL',3,NULL,'mL',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(7,'Each','EA',4,'','',0,1,'2025-04-20 12:35:46','2026-01-02 12:17:02'),(8,'Square Meter','m┬▓',5,NULL,'m┬▓',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(9,'Second','s',6,NULL,'s',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(10,'Hour','hr',6,NULL,'h',0,1,'2025-04-20 12:35:46','2025-04-20 12:35:46'),(11,'Joule','J',7,NULL,'J',1,1,'2025-04-20 12:35:46','2025-04-20 12:35:46');
/*!40000 ALTER TABLE `base_unit_of_measure` ENABLE KEYS */;

--
-- Table structure for table `benefit_type`
--

DROP TABLE IF EXISTS `benefit_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `benefit_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `benefit_type_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `benefit_type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT '0',
  `recurring_type` enum('Yearly','Monthly','Daily','Hourly','Per Minute') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `benefit_type_code` (`benefit_type_code`),
  KEY `school` (`school`),
  CONSTRAINT `benefit_type_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `benefit_type`
--

/*!40000 ALTER TABLE `benefit_type` DISABLE KEYS */;
INSERT INTO `benefit_type` VALUES (1,'12345678','qc8G0','Airtime Reimbassment',1,'Monthly',3,'2025-09-27 07:47:29','2025-09-27 07:48:30'),(2,'12345678','BuTir','X-Mass Shopping',1,'Yearly',5,'2025-09-27 07:51:41','2025-09-27 07:51:41'),(3,'12345678','YsJFM','Transport Fare',1,'Monthly',2,'2025-09-27 07:53:39','2025-09-27 07:53:39');
/*!40000 ALTER TABLE `benefit_type` ENABLE KEYS */;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendor_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `status` enum('Pending','Paid','Cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Pending',
  `payment_status` enum('Unpaid','Partially Paid','Paid','Overdue') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Unpaid',
  `reference_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `vendor_no` (`vendor_no`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`vendor_no`) REFERENCES `vendor` (`vendor_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;

--
-- Temporary view structure for view `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!50001 DROP VIEW IF EXISTS `branch`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `branch` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `branch_code`,
 1 AS `branch_name`,
 1 AS `description`,
 1 AS `manager`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `centre_manager`
--

DROP TABLE IF EXISTS `centre_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centre_manager` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `manager` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `manager` (`manager`),
  CONSTRAINT `centre_manager_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `centre_manager_ibfk_3` FOREIGN KEY (`manager`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `centre_manager`
--

/*!40000 ALTER TABLE `centre_manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `centre_manager` ENABLE KEYS */;

--
-- Table structure for table `charge`
--

DROP TABLE IF EXISTS `charge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charge` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `charge_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('Standing','Service','Item','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Standing',
  `is_recurring` tinyint(1) DEFAULT '0',
  `recurring_type` enum('Yearly','Quarterly','Monthly','Weekly','Daily','Hourly','Per Minute') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `income_gl_account` int NOT NULL,
  `expense_gl_account` int NOT NULL,
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `normal_charge` decimal(15,2) NOT NULL DEFAULT '0.00',
  `insurance_charge` decimal(15,2) DEFAULT '0.00',
  `special_charge` decimal(15,2) DEFAULT '0.00',
  `special_from` datetime DEFAULT NULL,
  `special_to` datetime DEFAULT NULL,
  `status` enum('Normal','On Offer') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Normal',
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `income_gl_account` (`income_gl_account`),
  KEY `expense_gl_account` (`expense_gl_account`),
  KEY `department` (`department`),
  CONSTRAINT `charge_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `charge_ibfk_2` FOREIGN KEY (`income_gl_account`) REFERENCES `chart_of_account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `charge_ibfk_3` FOREIGN KEY (`expense_gl_account`) REFERENCES `chart_of_account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `charge_ibfk_4` FOREIGN KEY (`department`) REFERENCES `dim_value` (`dv_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charge`
--

/*!40000 ALTER TABLE `charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `charge` ENABLE KEYS */;

--
-- Table structure for table `chart_of_account`
--

DROP TABLE IF EXISTS `chart_of_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chart_of_account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `no` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('Asset','Liability','Equity','Income','Revenue','Expense') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `parent` int DEFAULT NULL,
  `typical_balance` enum('Debit','Credit') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `opening_balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent` (`parent`),
  KEY `school` (`school`),
  CONSTRAINT `chart_of_account_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `chart_of_account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chart_of_account_ibfk_2` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart_of_account`
--

/*!40000 ALTER TABLE `chart_of_account` DISABLE KEYS */;
INSERT INTO `chart_of_account` VALUES (1,'12345678',1000,'Cash','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:38:53',NULL),(2,'12345678',1010,'Bank Accounts','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:38:53',NULL),(3,'12345678',1020,'Petty Cash','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:38:53',NULL),(4,'12345678',1100,'Accounts Receivable (Tuition Fees)','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(5,'12345678',1101,'Accounts Receivable (Other)','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(6,'12345678',1200,'Prepaid Expenses','Asset','Current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(7,'12345678',1300,'Inventory (Books, Uniforms)','Asset','Inventory',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(8,'12345678',1400,'Property, Plant & Equipment','Asset','Non-current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(9,'12345678',1410,'Buildings','Asset','Non-current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(10,'12345678',1420,'Furniture & Fixtures','Asset','Non-current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:39:29',NULL),(11,'12345678',1430,'Computers & ICT Equipment','Asset','Non-current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:13',NULL),(12,'12345678',1500,'Accumulated Depreciation','Asset','Contra Asset',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(13,'12345678',1600,'Investments','Asset','Non-current Asset',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(14,'12345678',1700,'Grants Receivable','Asset','Receivable',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(15,'12345678',2000,'Accounts Payable','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(16,'12345678',2100,'Salaries Payable','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(17,'12345678',2200,'Taxes Payable','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(18,'12345678',2300,'Deferred Revenue (Unearned Fees)','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(19,'12345678',2400,'Loans Payable','Liability','Long-term Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(20,'12345678',2500,'Accrued Expenses','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(21,'12345678',2600,'Tuition Refund Liability','Liability','Current Liability',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(22,'12345678',3000,'Fund Balance','Equity','Equity',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(23,'12345678',3100,'Capital Contributions','Equity','Equity',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(24,'12345678',3200,'Restricted Funds (Scholarships)','Equity','Restricted Fund',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(25,'12345678',3300,'Endowment Fund','Equity','Restricted Fund',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(26,'12345678',3400,'Surplus / Deficit','Equity','Net Result',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:41:14',NULL),(27,'12345678',4000,'Tuition Fees','Income','Education Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:21',NULL),(28,'12345678',4010,'Registration Fees','Income','Education Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:21',NULL),(29,'12345678',4020,'Exam Fees','Income','Education Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:21',NULL),(30,'12345678',4030,'Boarding Fees','Income','Education Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:21',NULL),(31,'12345678',4040,'Library Fees','Income','Service Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(32,'12345678',4050,'Transport Fees','Income','Service Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(33,'12345678',4060,'Uniform Sales','Income','Sales Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(34,'12345678',4070,'Bookstore Sales','Income','Sales Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(35,'12345678',4080,'Grants Received','Income','Grants',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(36,'12345678',4090,'Donations & Fundraising','Income','Other Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(37,'12345678',4100,'Rental Income','Income','Other Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(38,'12345678',4110,'Interest Income','Income','Other Income',NULL,'Credit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:02:22',NULL),(39,'12345678',5000,'Salaries & Wages','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(40,'12345678',5010,'Staff Benefits','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(41,'12345678',5020,'Payroll Taxes','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(42,'12345678',5030,'Office Supplies','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(43,'12345678',5040,'Utilities','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(44,'12345678',5050,'Rent / Lease','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(45,'12345678',5060,'Insurance','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:43:18',NULL),(46,'12345678',5070,'Communication','Expense','Admin Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(47,'12345678',5080,'Depreciation','Expense','Non-cash Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(48,'12345678',5100,'Teaching Materials','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(49,'12345678',5110,'Exam Materials','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(50,'12345678',5120,'Textbooks','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(51,'12345678',5130,'Lab Supplies','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(52,'12345678',5140,'Extracurricular Activities','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:24',NULL),(53,'12345678',5150,'Scholarships Awarded','Expense','Academic Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(54,'12345678',5200,'Maintenance & Repairs','Expense','Operational Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(55,'12345678',5210,'Transport & Fuel','Expense','Operational Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(56,'12345678',5220,'Security Services','Expense','Operational Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(57,'12345678',5230,'Cleaning Services','Expense','Operational Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(58,'12345678',5300,'Software Subscriptions','Expense','ICT Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(59,'12345678',5310,'IT Support','Expense','ICT Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL),(60,'12345678',5320,'Equipment Purchase','Expense','ICT Expense',NULL,'Debit',0.00,1,'2025-04-20 01:10:22','2025-09-22 07:44:25',NULL);
/*!40000 ALTER TABLE `chart_of_account` ENABLE KEYS */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `abbrev` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `level` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class_number` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_code` (`class_code`),
  KEY `idx_class_level` (`level`),
  CONSTRAINT `class_ibfk_1` FOREIGN KEY (`level`) REFERENCES `academic_level` (`level_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1,'PP1','Pre-Primary I','PP1','Pre-Primary',1),(2,'PP2','Pre-Primary II','PP2','Pre-Primary',2),(3,'G1','Grade 1','Grd 1','Lower Primary',3),(4,'G2','Grade 2','Grd 2','Lower Primary',4),(5,'G3','Grade 3','Grd 3','Lower Primary',5),(6,'G4','Grade 4','Grd 4','Upper Primary',6),(7,'G5','Grade 5','Grd 5','Upper Primary',7),(8,'G6','Grade 6','Grd 6','Upper Primary',8),(9,'G7','Grade 7','Grd 7','Junior Secondary',9),(10,'G8','Grade 8','Grd 8','Junior Secondary',10),(11,'G9','Grade 9','Grd 9','Junior Secondary',11),(12,'G10','Grade 10','Grd 10','Senior Secondary',12),(13,'G11','Grade 11','Grd 11','Senior Secondary',13),(14,'G12','Grade 12','Grd 12','Senior Secondary',14);
/*!40000 ALTER TABLE `class` ENABLE KEYS */;

--
-- Table structure for table `class_attendance`
--

DROP TABLE IF EXISTS `class_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `schedule` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `status` enum('Present','Absent','Late','Excused') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `recorded_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `adm_no` (`adm_no`),
  KEY `recorded_by` (`recorded_by`),
  KEY `schedule` (`schedule`),
  CONSTRAINT `class_attendance_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_attendance_ibfk_2` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_attendance_ibfk_3` FOREIGN KEY (`recorded_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_attendance_ibfk_4` FOREIGN KEY (`schedule`) REFERENCES `class_schedule` (`schedule`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_attendance`
--

/*!40000 ALTER TABLE `class_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_attendance` ENABLE KEYS */;

--
-- Table structure for table `class_enrollment`
--

DROP TABLE IF EXISTS `class_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_enrollment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `term` smallint NOT NULL,
  `year` year NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_enrollment` (`school`,`adm_no`,`class`,`term`),
  KEY `fk_adm_no` (`adm_no`),
  KEY `fk_class` (`class`),
  KEY `fk_stream` (`stream`),
  KEY `fk_term` (`term`),
  CONSTRAINT `class_enrollment_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON UPDATE CASCADE,
  CONSTRAINT `class_enrollment_ibfk_2` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON UPDATE CASCADE,
  CONSTRAINT `class_enrollment_ibfk_3` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON UPDATE CASCADE,
  CONSTRAINT `class_enrollment_ibfk_4` FOREIGN KEY (`stream`) REFERENCES `stream` (`stream_code`) ON UPDATE CASCADE,
  CONSTRAINT `class_enrollment_ibfk_5` FOREIGN KEY (`term`) REFERENCES `term` (`term_code`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_enrollment`
--

/*!40000 ALTER TABLE `class_enrollment` DISABLE KEYS */;
INSERT INTO `class_enrollment` VALUES (9,'12345678','11575','G10','tn0Km',1,2016,'2026-03-30 07:57:11','2026-03-30 07:57:11'),(10,'12345678','2652','G10','v6lgy',1,2026,'2026-03-30 08:47:13','2026-03-30 08:47:13'),(11,'12345678','2356','G10','v6lgy',1,2021,'2026-03-30 11:32:31','2026-03-30 11:32:31');
/*!40000 ALTER TABLE `class_enrollment` ENABLE KEYS */;

--
-- Table structure for table `class_register`
--

DROP TABLE IF EXISTS `class_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_register` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `register_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class_teacher` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `register_code` (`register_code`),
  KEY `school` (`school`),
  KEY `class` (`class`),
  KEY `stream` (`stream`),
  KEY `class_teacher` (`class_teacher`),
  CONSTRAINT `class_register_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_register_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_register_ibfk_3` FOREIGN KEY (`stream`) REFERENCES `stream` (`stream_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_register_ibfk_4` FOREIGN KEY (`class_teacher`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_register`
--

/*!40000 ALTER TABLE `class_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_register` ENABLE KEYS */;

--
-- Table structure for table `class_room`
--

DROP TABLE IF EXISTS `class_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `room_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `room_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `capacity` int NOT NULL DEFAULT '40',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stream_code` (`room_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_room`
--

/*!40000 ALTER TABLE `class_room` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_room` ENABLE KEYS */;

--
-- Table structure for table `class_schedule`
--

DROP TABLE IF EXISTS `class_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `schedule` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `teacher` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `room` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `period` int NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `schedule` (`schedule`),
  KEY `school` (`school`),
  KEY `class` (`class`),
  KEY `stream` (`stream`),
  KEY `subject` (`subject`),
  KEY `teacher` (`teacher`),
  KEY `class_schedule_ibfk_6` (`session`),
  KEY `class_schedule_ibfk_7` (`room`),
  CONSTRAINT `class_schedule_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_3` FOREIGN KEY (`stream`) REFERENCES `stream` (`stream_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_4` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_5` FOREIGN KEY (`teacher`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_6` FOREIGN KEY (`session`) REFERENCES `academic_session` (`session_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_schedule_ibfk_7` FOREIGN KEY (`room`) REFERENCES `class_room` (`room_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_schedule`
--

/*!40000 ALTER TABLE `class_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_schedule` ENABLE KEYS */;

--
-- Table structure for table `class_subject`
--

DROP TABLE IF EXISTS `class_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lessons_per_week` int NOT NULL DEFAULT '0',
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subject` (`subject`),
  KEY `class` (`class`),
  KEY `school` (`school`),
  KEY `department` (`department`),
  CONSTRAINT `class_subject_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_subject_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_subject_ibfk_3` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `class_subject_ibfk_4` FOREIGN KEY (`department`) REFERENCES `dim_value` (`dv_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_subject`
--

/*!40000 ALTER TABLE `class_subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_subject` ENABLE KEYS */;

--
-- Table structure for table `competency`
--

DROP TABLE IF EXISTS `competency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `competency_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `level` enum('Pre-Primary','Lower Primary','Upper Primary','Junior Secondary','Senior Secondary','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_comp_code` (`competency_code`),
  KEY `idx_comp_subject` (`subject`),
  KEY `comp_fk_school` (`school`),
  CONSTRAINT `comp_fk_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `comp_fk_subject` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competency`
--

/*!40000 ALTER TABLE `competency` DISABLE KEYS */;
/*!40000 ALTER TABLE `competency` ENABLE KEYS */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_type` enum('Student','Guardian','Staff','Regular') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Regular',
  `contact_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;

--
-- Temporary view structure for view `department`
--

DROP TABLE IF EXISTS `department`;
/*!50001 DROP VIEW IF EXISTS `department`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `department` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `dept_code`,
 1 AS `dept_name`,
 1 AS `description`,
 1 AS `dept_hod`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `depreciation_schedule`
--

DROP TABLE IF EXISTS `depreciation_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `depreciation_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `asset_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `depreciation_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `depreciation_schedule_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `fixed_asset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `depreciation_schedule`
--

/*!40000 ALTER TABLE `depreciation_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `depreciation_schedule` ENABLE KEYS */;

--
-- Table structure for table `dim_value`
--

DROP TABLE IF EXISTS `dim_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_value` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dim_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dv_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dv_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `inv_nos` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rct_nos` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `incharge` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `filter_name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dv_code` (`dv_code`),
  KEY `dim_id` (`dim_id`),
  KEY `school` (`school`),
  CONSTRAINT `dim_value_ibfk_1` FOREIGN KEY (`dim_id`) REFERENCES `dimension` (`dim_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dim_value_ibfk_2` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_value`
--

/*!40000 ALTER TABLE `dim_value` DISABLE KEYS */;
INSERT INTO `dim_value` VALUES (56,'12345678','YqeQx','GYev5','Pre-Primary','Pre-Primary','','','','School Level'),(57,'12345678','YqeQx','VYyLA','Lower Primary','Lower Primary','','','','School Level'),(58,'12345678','YqeQx','pWxIe','Upper Primary','Upper Primary','','','','School Level'),(59,'12345678','YqeQx','HphgJ','Junior Secondary','Junior Secondary','','','','School Level'),(60,'12345678','YqeQx','6tMdz','Senior Secondary','Senior Secondary','','','','School Level'),(61,'12345678','DFXZP','FPIuv','Library','Library Department','','','','Department'),(62,'12345678','DFXZP','fwZCp','Tuition','Tuition Area','','','','Department'),(63,'12345678','DFXZP','5sdo6','Transport','Transport','','','','Department'),(64,'12345678','DFXZP','c9bpa','Kitchen','Kitchen','','','','Department'),(65,'12345678','DFXZP','G8eQy','Accomodation','Accomodation','','','','Department'),(66,'12345678','DFXZP','bpeL7','Administration','Administration','','','','Department'),(67,'12345678','v7qQ0','7IJgH','Mathematics','Mathematics','','','','Subject Department'),(68,'12345678','v7qQ0','0kcmQ','Sciences','Sciences','','','','Subject Department'),(69,'12345678','v7qQ0','xn5A1','Technicals','Technicals','','','','Subject Department'),(70,'12345678','v7qQ0','fkYKD','Humanities','Humanities','','','','Subject Department'),(71,'12345678','v7qQ0','5ivru','Languages','Languages','','','','Subject Department'),(72,'12345678','a7fjk','wFXQf','Group I','Group I','','','','Subject Group'),(73,'12345678','a7fjk','pzVh6','Group II','Group II','','','','Subject Group'),(74,'12345678','a7fjk','K9V4X','Group III','Group III','','','','Subject Group'),(75,'12345678','a7fjk','rxm9Z','Group IV','Group IV','','','','Subject Group'),(76,'12345678','a7fjk','h3t5b','Group V','Group V','','','','Subject Group'),(77,'36626205','DFXZP','yZ46V','Tution','Tution','','','','Department');
/*!40000 ALTER TABLE `dim_value` ENABLE KEYS */;

--
-- Table structure for table `dimension`
--

DROP TABLE IF EXISTS `dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimension` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dim_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dim_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dim_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dim_id` (`dim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimension`
--

/*!40000 ALTER TABLE `dimension` DISABLE KEYS */;
INSERT INTO `dimension` VALUES (1,'cspdG','Branch','Describes the school dimension','2025-03-27 09:26:12','2025-09-07 09:46:49'),(2,'a7fjk','Subject Group','Define Subject groups such like Group I, Group II, Group III, Group IV and Group V','2025-03-27 09:26:12','2025-03-27 09:26:12'),(3,'v7qQ0','Subject Department','Define department for various subjects like Mathematics, Sciences, Technicals, Humanities, Languages etc','2025-03-27 09:26:12','2025-03-27 09:26:12'),(4,'FtR7N','Store Location','Definition of school locations including the main store, kitchen, hod exams','2025-03-27 09:26:12','2025-03-30 08:56:11'),(5,'dTAsp','Settlement Type','Ways or methods through which students, teachers, parents or defaulters use to settle payments','2025-03-27 09:26:12','2025-03-30 08:41:50'),(6,'rzWpf','Account Payable','Lists all accounts payable such as Salaries, Vendor Repayments among others','2025-03-27 09:26:12','2025-03-30 09:13:23'),(7,'VHXQq','Account Receivable','Define accounts that receive income to the school e.g., Capitation, Tuition Fees, Teacher&#039;s Welfare, PTA','2025-03-27 09:26:12','2025-03-30 09:12:12'),(8,'BejzK','Section','Define school sections like in academic department, Boarding, Entertainment','2025-03-27 09:37:02','2025-07-04 12:23:00'),(9,'DFXZP','Department','Departments around the school e.g Administration','2025-09-07 15:34:58','2025-09-07 16:07:38'),(10,'YqeQx','School Level','Define levels like Pre-Primary, Junior Primary, Senior Primary, Junior Secondary, Senior Secondary','2025-09-19 13:22:22','2025-09-19 13:22:22');
/*!40000 ALTER TABLE `dimension` ENABLE KEYS */;

--
-- Table structure for table `guardian`
--

DROP TABLE IF EXISTS `guardian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guardian` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guardian_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `occupation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guardian_code` (`guardian_code`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guardian`
--

/*!40000 ALTER TABLE `guardian` DISABLE KEYS */;
/*!40000 ALTER TABLE `guardian` ENABLE KEYS */;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `status` enum('Unpaid','Partially Paid','Paid','Overdue') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Unpaid',
  `reference_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KES',
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;

--
-- Table structure for table `item_category`
--

DROP TABLE IF EXISTS `item_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_category`
--

/*!40000 ALTER TABLE `item_category` DISABLE KEYS */;
INSERT INTO `item_category` VALUES (1,'ICT Equipment','Computers, printers, projectors, and related items','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(2,'Stationery','Office and school stationery supplies','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(3,'Teaching Aids','Smartboards, charts, educational boards','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(4,'Furniture','Desks, chairs, tables, and storage units','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(5,'Library','Books and literature resources','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(6,'Electrical Appliances','General school electrical appliances','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(7,'General Supplies','Cleaning, administrative, and utility items','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(8,'Science Lab Equipment','Laboratory equipment and consumables','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(9,'Security & Safety','Security items and safety gear','2025-04-20 20:30:34','2025-04-20 20:30:34',1),(10,'Sports & Recreation','Sports and physical education equipment','2025-04-20 20:30:34','2025-04-20 20:30:34',1);
/*!40000 ALTER TABLE `item_category` ENABLE KEYS */;

--
-- Table structure for table `job_applicant`
--

DROP TABLE IF EXISTS `job_applicant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_applicant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicant_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applicant_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact_phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicant_code` (`applicant_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_applicant`
--

/*!40000 ALTER TABLE `job_applicant` DISABLE KEYS */;
INSERT INTO `job_applicant` VALUES (1,'45454644','Test Applicant Name','0114085123','aimekhisa23@gmail.com','2025-10-03 14:25:37','2025-10-09 00:37:46'),(2,'80897768','Jackline Mwende','0756454321','jackym@gmail.com','2025-10-03 14:57:24','2025-10-03 14:57:24'),(3,'8980878778','Benson Chango Mang\'eni','0123432134','benchango@gmail.com','2025-10-03 15:01:02','2025-10-09 00:40:27'),(4,'567689097','Brian Sabiri','0734566778','brian@gmail.com','2025-10-04 12:23:09','2025-10-09 00:37:46'),(5,'68734368','Juliet Barasa','0769653478','julietbarasa@gmail.com','2025-10-08 08:33:38','2025-10-08 08:33:38');
/*!40000 ALTER TABLE `job_applicant` ENABLE KEYS */;

--
-- Table structure for table `job_application`
--

DROP TABLE IF EXISTS `job_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_application` (
  `id` int NOT NULL AUTO_INCREMENT,
  `applicant_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_posting_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `resume` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cover_letter` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `application_status` enum('Pending','Reviewed','Shortlisted','Rejected','Hired') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicant_code` (`applicant_code`),
  KEY `job_posting_code` (`job_posting_code`),
  CONSTRAINT `job_application_ibfk_2` FOREIGN KEY (`applicant_code`) REFERENCES `job_applicant` (`applicant_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_application_ibfk_3` FOREIGN KEY (`job_posting_code`) REFERENCES `job_posting` (`job_posting_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_application`
--

/*!40000 ALTER TABLE `job_application` DISABLE KEYS */;
INSERT INTO `job_application` VALUES (1,'45454644','2025/ACD/001','upload/pdf/68dfb5fa6d47b_1759491578.pdf','upload/pdf/68dfb5fa717ef_1759491578.pdf','Pending',NULL,'2025-10-03 14:39:38','2025-10-03 14:39:38'),(2,'80897768','2025/ACD/001','upload/pdf/68dfba24e4f2a_1759492644.pdf','upload/pdf/68dfba24e60d9_1759492644.pdf','Pending',NULL,'2025-10-03 14:57:24','2025-10-03 14:57:24'),(3,'8980878778','2025/ACD/002','upload/pdf/68dfbafeaffe7_1759492862.pdf','upload/pdf/68dfbb0009c9e_1759492864.pdf','Pending',NULL,'2025-10-03 15:01:04','2025-10-03 15:01:04'),(4,'567689097','2025/ACD/TC/001','upload/pdf/68e0e77dcf6e0_1759569789.pdf','upload/pdf/68e0e77dd0b75_1759569789.pdf','Pending',NULL,'2025-10-04 12:23:09','2025-10-04 12:23:09');
/*!40000 ALTER TABLE `job_application` ENABLE KEYS */;

--
-- Table structure for table `job_category`
--

DROP TABLE IF EXISTS `job_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_category`
--

/*!40000 ALTER TABLE `job_category` DISABLE KEYS */;
INSERT INTO `job_category` VALUES (1,'Administration and Management','Perfoming administrative tasks','2025-09-08 23:20:34','2025-09-08 23:20:34'),(2,'Academic','Perfoms academic work such as teaching and other academic related chores','2025-09-11 22:20:12','2025-09-11 22:20:12'),(3,'Kitchen','Perform kitchen tasks','2025-09-13 13:07:50','2025-09-22 07:14:08');
/*!40000 ALTER TABLE `job_category` ENABLE KEYS */;

--
-- Table structure for table `job_group`
--

DROP TABLE IF EXISTS `job_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `min_salary` decimal(10,2) NOT NULL,
  `max_salary` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_group`
--

/*!40000 ALTER TABLE `job_group` DISABLE KEYS */;
INSERT INTO `job_group` VALUES (1,'K','Job Group K',130000.00,150000.00,'2025-09-08 23:22:59','2025-09-08 23:22:59'),(2,'C','Job Group C',10000.00,15000.00,'2025-09-11 22:20:55','2025-09-11 22:20:55'),(3,'D','Job Group D',16000.00,25000.00,'2025-09-11 22:21:40','2025-09-11 22:21:40');
/*!40000 ALTER TABLE `job_group` ENABLE KEYS */;

--
-- Table structure for table `job_level`
--

DROP TABLE IF EXISTS `job_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_level`
--

/*!40000 ALTER TABLE `job_level` DISABLE KEYS */;
INSERT INTO `job_level` VALUES (1,'Entry Level','Fresh graduates','2025-09-08 23:26:46','2025-09-08 23:26:46');
/*!40000 ALTER TABLE `job_level` ENABLE KEYS */;

--
-- Table structure for table `job_posting`
--

DROP TABLE IF EXISTS `job_posting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_posting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_posting_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_title` int NOT NULL,
  `vacant_posts` int NOT NULL,
  `posting_date` date NOT NULL,
  `closing_date` date NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `employment_type` enum('Full-time','Part-time','Contract','Internship') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Full-time',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `salary_range` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('New','Open','Closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'New',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_posting_code` (`job_posting_code`),
  KEY `school` (`school`),
  KEY `department` (`department`),
  CONSTRAINT `job_posting_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_posting_ibfk_2` FOREIGN KEY (`department`) REFERENCES `dim_value` (`dv_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_posting`
--

/*!40000 ALTER TABLE `job_posting` DISABLE KEYS */;
INSERT INTO `job_posting` VALUES (2,'12345678','c9bpa','2025/KIT/001',3,2,'2025-10-03','2025-10-31','To take matron duties','Full-time','Busia','20,000 - 35,000','New','2025-10-03 10:16:27','2025-10-03 10:57:36'),(4,'12345678','fwZCp','2025/ACD/001',4,4,'2025-10-03','2025-10-31','Teach computer studies in form and 2','Contract','Withing Bungoma','20,000 - 25,000','New','2025-10-03 11:03:10','2025-10-03 11:03:10'),(5,'12345678','fwZCp','2025/ACD/002',5,6,'2025-10-03','2025-10-31','Assist subject teachers in revisions','Part-time','Within Busia County','12,000 - 15,000','New','2025-10-03 11:05:18','2025-10-03 11:05:18'),(6,'36626205','yZ46V','2025/ACD/TC/001',6,3,'2025-10-04','2025-10-20','Teach all classes','Full-time','Within Sirisia Sub-County','10000-15000','New','2025-10-04 12:19:38','2025-10-08 07:58:44');
/*!40000 ALTER TABLE `job_posting` ENABLE KEYS */;

--
-- Table structure for table `job_skill`
--

DROP TABLE IF EXISTS `job_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_skill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_title_id` int NOT NULL,
  `skill_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_job_skill_school` (`school`),
  CONSTRAINT `fk_job_skill_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_skill`
--

/*!40000 ALTER TABLE `job_skill` DISABLE KEYS */;
INSERT INTO `job_skill` VALUES (2,'12345678',3,1,'2025-09-22 07:23:41','2025-09-22 07:23:41');
/*!40000 ALTER TABLE `job_skill` ENABLE KEYS */;

--
-- Table structure for table `job_title`
--

DROP TABLE IF EXISTS `job_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_title` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category_id` int NOT NULL,
  `level_id` int NOT NULL,
  `group_id` int NOT NULL,
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title_2` (`title`),
  KEY `category_id` (`category_id`),
  KEY `level_id` (`level_id`),
  KEY `group_id` (`group_id`),
  KEY `department` (`department`),
  KEY `school` (`school`),
  KEY `title` (`title`),
  CONSTRAINT `fk_job_title_category` FOREIGN KEY (`category_id`) REFERENCES `job_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_job_title_group` FOREIGN KEY (`group_id`) REFERENCES `job_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_job_title_level` FOREIGN KEY (`level_id`) REFERENCES `job_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_title_ibfk_1` FOREIGN KEY (`department`) REFERENCES `dim_value` (`dv_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_title_ibfk_2` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_title`
--

/*!40000 ALTER TABLE `job_title` DISABLE KEYS */;
INSERT INTO `job_title` VALUES (3,'12345678','School Matron',2,1,2,'c9bpa','School Matron',1,'2025-09-22 07:16:28','2025-10-03 11:14:43'),(4,'12345678','Computer Studies and Mathematics Teacher',2,1,3,'fwZCp','Teaching a combination of Computer studies and Mathematics',1,'2025-10-03 10:49:53','2025-10-03 10:49:53'),(5,'12345678','Kiswahili Fasihi Teacher',2,1,3,'fwZCp','Kufundisha somo la kiswahili na fasihi katika madarasa yote atakayopewa na mwelekezi wa masomo',1,'2025-10-03 10:52:01','2025-10-03 10:52:01'),(6,'36626205','English Literature',2,1,3,'yZ46V','Teaching English and Literature in all classes',1,'2025-10-04 11:39:19','2025-10-04 11:39:19');
/*!40000 ALTER TABLE `job_title` ENABLE KEYS */;

--
-- Table structure for table `journal_entry`
--

DROP TABLE IF EXISTS `journal_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal_entry` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `journal_entry_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `journal_entry_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_entry`
--

/*!40000 ALTER TABLE `journal_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_entry` ENABLE KEYS */;

--
-- Table structure for table `journal_line`
--

DROP TABLE IF EXISTS `journal_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal_line` (
  `id` int NOT NULL AUTO_INCREMENT,
  `journal_entry` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `debit` decimal(15,2) DEFAULT '0.00',
  `credit` decimal(15,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `journal_entry` (`journal_entry`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `journal_line_ibfk_1` FOREIGN KEY (`journal_entry`) REFERENCES `journal_entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `journal_line_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `chart_of_account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_line`
--

/*!40000 ALTER TABLE `journal_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_line` ENABLE KEYS */;

--
-- Table structure for table `leave_balance`
--

DROP TABLE IF EXISTS `leave_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_balance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_balance_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `total_leave` int NOT NULL,
  `leave_used` int NOT NULL,
  `leave_remaining` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_balance_code` (`leave_balance_code`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  KEY `leave_type` (`leave_type`),
  CONSTRAINT `leave_balance_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_balance_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_balance_ibfk_3` FOREIGN KEY (`leave_type`) REFERENCES `leave_type` (`leave_type_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_balance`
--

/*!40000 ALTER TABLE `leave_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `leave_balance` ENABLE KEYS */;

--
-- Table structure for table `leave_request`
--

DROP TABLE IF EXISTS `leave_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `approval_status` enum('New','Pending','Approved','Rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'New',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `approved_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rejected_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_code` (`leave_code`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  KEY `approved_by` (`approved_by`),
  KEY `rejected_by` (`rejected_by`),
  KEY `leave_type` (`leave_type`),
  CONSTRAINT `leave_request_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_request_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_request_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_request_ibfk_4` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_request_ibfk_5` FOREIGN KEY (`leave_type`) REFERENCES `leave_type` (`leave_type_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_request`
--

/*!40000 ALTER TABLE `leave_request` DISABLE KEYS */;
INSERT INTO `leave_request` VALUES (1,'36626205','fIUvj','9dfSg','jzGVT','2025-11-01','2025-11-30','New',NULL,NULL,NULL,NULL,'2025-10-19 07:46:49','2025-10-19 07:46:49');
/*!40000 ALTER TABLE `leave_request` ENABLE KEYS */;

--
-- Table structure for table `leave_type`
--

DROP TABLE IF EXISTS `leave_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_type_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `leave_type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applies_to` enum('Male','Female','Both') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `no_of_days_off` int NOT NULL,
  `maximum_leaves` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_type_code` (`leave_type_code`),
  KEY `school` (`school`),
  CONSTRAINT `leave_type_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_type`
--

/*!40000 ALTER TABLE `leave_type` DISABLE KEYS */;
INSERT INTO `leave_type` VALUES (1,'12345678','GpmoA','Maternity','Female',90,3,'2025-09-27 06:46:19','2025-09-27 06:51:11'),(2,'12345678','Z1PNT','Paternity','Male',10,3,'2025-09-27 06:48:31','2025-09-27 06:51:24'),(3,'12345678','HrViv','Annual','Both',30,5,'2025-09-27 06:49:15','2025-09-27 06:51:28'),(4,'12345678','83kI7','Sick','Both',14,10,'2025-09-27 06:50:29','2025-09-27 06:50:29'),(5,'36626205','2zNDh','Maternity','Female',90,5,'2025-10-05 20:24:15','2025-10-05 20:26:07'),(6,'36626205','H6MPt','Paternity','Male',10,5,'2025-10-05 20:24:47','2025-10-05 20:26:10'),(7,'36626205','jzGVT','Annual Leave','Both',30,5,'2025-10-05 20:25:18','2025-10-05 20:26:00'),(8,'36626205','zElD0','Sick','Both',15,4,'2025-10-05 20:25:42','2025-10-05 20:26:15'),(9,'36626123','5CQYM','Maternity','Female',90,1,'2025-10-12 08:15:29','2025-10-12 08:15:29'),(10,'36626123','eUN7u','Paternity','Male',10,1,'2025-10-12 08:15:52','2025-10-12 08:15:52');
/*!40000 ALTER TABLE `leave_type` ENABLE KEYS */;

--
-- Temporary view structure for view `location`
--

DROP TABLE IF EXISTS `location`;
/*!50001 DROP VIEW IF EXISTS `location`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `location` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `location_code`,
 1 AS `location_name`,
 1 AS `description`,
 1 AS `manager`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `receiver` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sent_status` enum('Sent','Delivered') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `msg_status` enum('Read','Unread') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `delivered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sender` (`sender`),
  KEY `receiver` (`receiver`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`sender`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`receiver`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

/*!40000 ALTER TABLE `message` DISABLE KEYS */;
/*!40000 ALTER TABLE `message` ENABLE KEYS */;

--
-- Table structure for table `mpesa_payments`
--

DROP TABLE IF EXISTS `mpesa_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mpesa_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `merchant_request_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `checkout_request_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `result_code` int DEFAULT NULL,
  `result_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `mpesa_receipt_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transaction_date` bigint DEFAULT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mpesa_payments`
--

/*!40000 ALTER TABLE `mpesa_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `mpesa_payments` ENABLE KEYS */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('announcement','event','circular','press') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'announcement',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `published_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_news_school` (`school`),
  CONSTRAINT `fk_news_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;

--
-- Table structure for table `no_series`
--

DROP TABLE IF EXISTS `no_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `no_series` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ns_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ns_name` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `startno` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `endno` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastused` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `canskip` tinyint(1) NOT NULL DEFAULT '0',
  `category` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  CONSTRAINT `no_series_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `no_series`
--

/*!40000 ALTER TABLE `no_series` DISABLE KEYS */;
/*!40000 ALTER TABLE `no_series` ENABLE KEYS */;

--
-- Table structure for table `pathway`
--

DROP TABLE IF EXISTS `pathway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pathway` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pathway` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pathway` (`pathway`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pathway`
--

/*!40000 ALTER TABLE `pathway` DISABLE KEYS */;
INSERT INTO `pathway` VALUES (2,'Arts'),(3,'Commerce'),(1,'Science'),(4,'Technical');
/*!40000 ALTER TABLE `pathway` ENABLE KEYS */;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill` int NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `reference_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KES',
  PRIMARY KEY (`id`),
  KEY `bill` (`bill`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`bill`) REFERENCES `bill` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;

--
-- Table structure for table `payroll`
--

DROP TABLE IF EXISTS `payroll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `payroll_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pay_period` date NOT NULL,
  `gross_pay` decimal(10,2) NOT NULL,
  `tax_deductions` decimal(10,2) NOT NULL,
  `net_pay` decimal(10,2) NOT NULL,
  `approval_status` enum('New','Pending','Approved','Rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'New',
  `payment_status` enum('Pending','Paid') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `approved_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rejected_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payroll_code` (`payroll_code`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  KEY `approved_by` (`approved_by`),
  KEY `rejected_by` (`rejected_by`),
  CONSTRAINT `payroll_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payroll_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payroll_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payroll_ibfk_4` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll`
--

/*!40000 ALTER TABLE `payroll` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll` ENABLE KEYS */;

--
-- Temporary view structure for view `principal`
--

DROP TABLE IF EXISTS `principal`;
/*!50001 DROP VIEW IF EXISTS `principal`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `principal` AS SELECT 
 1 AS `school`,
 1 AS `teacher_code`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `gender`,
 1 AS `email`,
 1 AS `phone`,
 1 AS `id_no`,
 1 AS `hire_date`,
 1 AS `emp_term`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `po_no` bigint NOT NULL,
  `title` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `requested_date` date NOT NULL,
  `date_required` date NOT NULL,
  `requested_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `approved_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `authorized_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `vendor` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `po` (`company`,`po_no`),
  CONSTRAINT `purchase_order_ibfk_1` FOREIGN KEY (`company`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;

--
-- Table structure for table `purchase_order_item`
--

DROP TABLE IF EXISTS `purchase_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `po_no` bigint NOT NULL,
  `item_no` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `item_uom` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `po_item` (`company`,`po_no`,`item_no`),
  CONSTRAINT `purchase_order_item_ibfk_1` FOREIGN KEY (`company`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_item`
--

/*!40000 ALTER TABLE `purchase_order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_item` ENABLE KEYS */;

--
-- Table structure for table `purchase_requisition`
--

DROP TABLE IF EXISTS `purchase_requisition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pr_no` bigint NOT NULL,
  `title` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `requested_date` date NOT NULL,
  `date_required` date NOT NULL,
  `requested_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('open','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'open',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pr` (`company`,`pr_no`),
  CONSTRAINT `purchase_requisition_ibfk_1` FOREIGN KEY (`company`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisition`
--

/*!40000 ALTER TABLE `purchase_requisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition` ENABLE KEYS */;

--
-- Table structure for table `purchase_requisition_item`
--

DROP TABLE IF EXISTS `purchase_requisition_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisition_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pr_no` bigint NOT NULL,
  `item_no` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `item_uom` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pr_item` (`company`,`pr_no`,`item_no`),
  CONSTRAINT `purchase_requisition_item_ibfk_1` FOREIGN KEY (`company`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisition_item`
--

/*!40000 ALTER TABLE `purchase_requisition_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition_item` ENABLE KEYS */;

--
-- Table structure for table `receipt`
--

DROP TABLE IF EXISTS `receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `ref_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KES',
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `permissions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

/*!40000 ALTER TABLE `role` DISABLE KEYS */;
/*!40000 ALTER TABLE `role` ENABLE KEYS */;

--
-- Table structure for table `salary`
--

DROP TABLE IF EXISTS `salary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `salary_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `basic_salary` decimal(10,2) NOT NULL,
  `allowances` decimal(10,2) NOT NULL,
  `deductions` decimal(10,2) NOT NULL,
  `net_salary` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `salary_code` (`salary_code`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  CONSTRAINT `salary_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `salary_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary`
--

/*!40000 ALTER TABLE `salary` DISABLE KEYS */;
/*!40000 ALTER TABLE `salary` ENABLE KEYS */;

--
-- Table structure for table `school`
--

DROP TABLE IF EXISTS `school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `school_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `mail` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `logo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `motto` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mission` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `vision` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `core_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `days_per_week` int DEFAULT '5',
  `periods_per_day` int DEFAULT '8',
  `facebook` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `twitter` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `instagram` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `linkedin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `skype` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `website` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `established_year` year DEFAULT NULL,
  `status` enum('Active','Closed','Pending Approval') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `school_code` (`school_code`),
  UNIQUE KEY `mail` (`mail`),
  UNIQUE KEY `contact` (`contact`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school`
--

/*!40000 ALTER TABLE `school` DISABLE KEYS */;
INSERT INTO `school` VALUES (8,'12345678','PCC Secondary School','National',NULL,'pccws.limited@gmail.com','0741915943','upload/png/user-default-2-min.png',NULL,NULL,NULL,NULL,5,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','2025-09-19 19:46:43','2025-09-19 19:46:43'),(9,'36626126','Sibanga S.A Comprehensive School','National',NULL,'sasibangacs@go.ke','0700212354','upload/jpeg/68e0c9c2849db_1759562178.jpg',NULL,NULL,NULL,NULL,5,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','2025-10-04 17:16:18','2025-10-04 17:16:18'),(10,'36626205','AC. Bungonge High School','Extra-County',NULL,'acbutongehs@go.ke','0788665544','upload/jpeg/68e0d92e08b41_1759566126.jpg',NULL,NULL,NULL,NULL,5,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','2025-10-04 18:22:06','2025-10-04 18:22:06'),(11,'36626123','Namwela Friends Boys High School','Extra-County',NULL,'namwelafbhs@gmail.com','0723456789','upload/jpeg/68e257cca7e30_1759664076.jpg',NULL,NULL,NULL,NULL,5,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','2025-10-05 21:34:37','2025-10-09 09:28:10'),(13,'32564215','St. Ann\'s Comprehensive School','Extra-County',NULL,'stannscs@gmail.com','0752142635','upload/jpeg/696b614ad9442_1768644938.jpg',NULL,NULL,NULL,NULL,5,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','2026-01-17 10:15:39','2026-01-17 10:15:39');
/*!40000 ALTER TABLE `school` ENABLE KEYS */;

--
-- Table structure for table `school_class`
--

DROP TABLE IF EXISTS `school_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_offered` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_code` (`class`),
  KEY `school` (`school`),
  CONSTRAINT `school_class_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `school_class_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_class`
--

/*!40000 ALTER TABLE `school_class` DISABLE KEYS */;
INSERT INTO `school_class` VALUES (1,'12345678','PP1',1),(2,'12345678','PP2',1),(3,'12345678','G1',1),(4,'12345678','G2',1),(5,'12345678','G3',1),(6,'12345678','G4',1),(7,'12345678','G5',1),(8,'12345678','G6',1),(9,'12345678','G7',1),(10,'12345678','G8',1),(11,'12345678','G9',1),(12,'12345678','G10',1),(13,'12345678','G11',1),(14,'12345678','G12',1);
/*!40000 ALTER TABLE `school_class` ENABLE KEYS */;

--
-- Temporary view structure for view `settlement_type`
--

DROP TABLE IF EXISTS `settlement_type`;
/*!50001 DROP VIEW IF EXISTS `settlement_type`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `settlement_type` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `st_code`,
 1 AS `st_name`,
 1 AS `description`,
 1 AS `manager`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill`
--

/*!40000 ALTER TABLE `skill` DISABLE KEYS */;
INSERT INTO `skill` VALUES (1,'Data entry','Able to use computer to key in data for analysis and help in other useful decisions','2025-09-08 23:44:04','2025-09-08 23:44:04');
/*!40000 ALTER TABLE `skill` ENABLE KEYS */;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_title` int NOT NULL,
  `role` enum('Teacher','Admin','Support','Principal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `hire_date` date NOT NULL,
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('Active','Resigned','Retired','On Leave','Dismissed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `emp_term` enum('Permanent','B.O.M','Volunteer','Intern','Attachment','Teaching Practice') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'upload/png/user-default-2-min.png',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `staff_code` (`staff_code`),
  KEY `school` (`school`),
  KEY `job_title` (`job_title`),
  KEY `department` (`department`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`job_title`) REFERENCES `job_title` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_ibfk_3` FOREIGN KEY (`department`) REFERENCES `dim_value` (`dv_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (13,'12345678','RzElf','Nancy','Chemtai','Female','nancychem@gmail.com','0751423652','32352452',3,'Support','2025-01-01','c9bpa','Retired','Permanent','upload/png/user-default-2-min.png','2025-09-27 14:56:38','2025-10-08 14:13:39'),(14,'12345678','xfhbN','Kelvin','Obwoyo','Male','kobwoyo@gmail.com','0767856545','32456578',3,'Support','2025-05-07','c9bpa','Active','Permanent','upload/png/user-default-2-min.png','2025-09-27 16:45:32','2025-09-27 16:45:32'),(15,'36626205','9dfSg','Silas','Wanambisi','Male','wsilas@gmail.com','0124345365','15643256',6,'Teacher','2025-01-06','yZ46V','Active','Permanent','upload/png/user-default-2-min.png','2025-10-04 18:41:17','2025-10-24 03:36:18'),(16,'12345678','SI08R','Abigael','Bahati','Female','abigaelbahati@gmail.com','0756342314','12345678',4,'Teacher','2025-02-08','fwZCp','On Leave','Permanent','upload/jpeg/2e4d26d7e8f5e1b62f2a17d549ffe6c5.jpg','2025-10-06 17:22:21','2025-10-08 14:11:49'),(17,'12345678','96CN7','Kelvin','Opiyo','Male','kelvinopiyo@gmail.com','0745635243','34256545',5,'Teacher','2025-10-01','fwZCp','Resigned','B.O.M','upload/png/user-default-2-min.png','2025-10-06 17:38:01','2025-10-08 14:14:14'),(18,'12345678','P7Czm','Edmond','Chiveli','Male','chevelie@yahoo.com','0768987546','27645635',5,'Teacher','2025-10-01','fwZCp','Active','B.O.M','upload/jpeg/68e372ac688e7_1759736492.jpg','2025-10-06 17:41:32','2025-10-06 17:41:32');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;

--
-- Table structure for table `staff_attendance`
--

DROP TABLE IF EXISTS `staff_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `working_date` date NOT NULL,
  `check_in_time` time DEFAULT NULL,
  `check_out_time` time DEFAULT NULL,
  `status` enum('Present','Absent','Late') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  CONSTRAINT `staff_attendance_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_attendance_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_attendance`
--

/*!40000 ALTER TABLE `staff_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_attendance` ENABLE KEYS */;

--
-- Table structure for table `staff_benefit`
--

DROP TABLE IF EXISTS `staff_benefit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_benefit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `benefit_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `benefit_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `effective_date` date NOT NULL,
  `status` enum('Pending','Active','Closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `benefit_code` (`benefit_code`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  KEY `benefit_type` (`benefit_type`),
  CONSTRAINT `staff_benefit_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_benefit_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_benefit_ibfk_3` FOREIGN KEY (`benefit_type`) REFERENCES `benefit_type` (`benefit_type_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_benefit`
--

/*!40000 ALTER TABLE `staff_benefit` DISABLE KEYS */;
INSERT INTO `staff_benefit` VALUES (1,'12345678','bIv86','RzElf','qc8G0','For daily communication to the junior staffs','2025-02-01','Pending','2025-09-27 08:12:47','2025-09-27 08:12:47'),(2,'12345678','uqYh1','RzElf','YsJFM','To facilitate monthly HMIS training','2025-10-01','Pending','2025-09-27 08:22:19','2025-09-27 08:22:19'),(3,'12345678','v54VI','96CN7','BuTir','To be entitled from this year','2025-10-09','Pending','2025-10-11 19:47:22','2025-10-11 19:47:22');
/*!40000 ALTER TABLE `staff_benefit` ENABLE KEYS */;

--
-- Table structure for table `staff_file`
--

DROP TABLE IF EXISTS `staff_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_file` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `file_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `document_type` enum('Academic Qualifications','Cover Letter','ID Copy','Resume','Good Conduct','Contract','Testimonial') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `file_id` (`file_id`),
  KEY `school` (`school`),
  KEY `staff` (`staff`),
  CONSTRAINT `staff_file_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_file_ibfk_2` FOREIGN KEY (`staff`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_file`
--

/*!40000 ALTER TABLE `staff_file` DISABLE KEYS */;
INSERT INTO `staff_file` VALUES (6,'36626205','65RvQ','9dfSg','Testimonial','upload/pdf/68e25e4079536_1759665728.pdf','2025-10-05 15:02:08','2025-10-05 15:02:08'),(7,'36626205','xmULc','9dfSg','Academic Qualifications','upload/pdf/68e2a87d5b275_1759684733.pdf','2025-10-05 20:18:53','2025-10-05 20:18:53'),(8,'12345678','fv0kR','SI08R','Academic Qualifications','upload/pdf/68e5f8cc478fa_1759901900.pdf','2025-10-08 08:38:20','2025-10-08 08:38:20'),(9,'12345678','gHGL8','SI08R','Cover Letter','upload/pdf/68e6d691eb9f7_1759958673.pdf','2025-10-09 00:24:34','2025-10-09 00:24:34'),(10,'36626205','lXbS0','9dfSg','Cover Letter','upload/pdf/68ededa128c03_1760423329.pdf','2025-10-14 09:28:49','2025-10-14 09:28:49');
/*!40000 ALTER TABLE `staff_file` ENABLE KEYS */;

--
-- Table structure for table `staff_performance_review`
--

DROP TABLE IF EXISTS `staff_performance_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_performance_review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `review_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reviewee` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reviewer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `review_date` date NOT NULL,
  `performance_score` decimal(5,2) NOT NULL,
  `reviewer_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_code` (`review_code`),
  KEY `school` (`school`),
  KEY `reviewee` (`reviewee`),
  KEY `reviewer` (`reviewer`),
  CONSTRAINT `staff_performance_review_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_performance_review_ibfk_2` FOREIGN KEY (`reviewee`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_performance_review_ibfk_3` FOREIGN KEY (`reviewer`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_performance_review`
--

/*!40000 ALTER TABLE `staff_performance_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_performance_review` ENABLE KEYS */;

--
-- Table structure for table `staff_training`
--

DROP TABLE IF EXISTS `staff_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_training` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `staff_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `program_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `staff_code` (`staff_code`),
  KEY `program_code` (`program_code`),
  CONSTRAINT `staff_training_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_training_ibfk_2` FOREIGN KEY (`staff_code`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_training_ibfk_3` FOREIGN KEY (`program_code`) REFERENCES `training_program` (`program_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_training`
--

/*!40000 ALTER TABLE `staff_training` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_training` ENABLE KEYS */;

--
-- Table structure for table `staff_transfer_request`
--

DROP TABLE IF EXISTS `staff_transfer_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_transfer_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `transfer_from` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `transfer_to` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date_requested` date NOT NULL,
  `requested_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `on_behalf_of` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `effective_date` date NOT NULL,
  `approval_status` enum('New','Pending','Approved','Rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'New',
  `approved_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rejected_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfer_code` (`transfer_code`),
  KEY `transfer_from` (`transfer_from`),
  KEY `transfer_to` (`transfer_to`),
  KEY `approved_by` (`approved_by`),
  KEY `rejected_by` (`rejected_by`),
  KEY `requested_by` (`requested_by`),
  KEY `on_behalf_of` (`on_behalf_of`),
  CONSTRAINT `staff_transfer_request_ibfk_1` FOREIGN KEY (`transfer_from`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_transfer_request_ibfk_2` FOREIGN KEY (`transfer_to`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_transfer_request`
--

/*!40000 ALTER TABLE `staff_transfer_request` DISABLE KEYS */;
INSERT INTO `staff_transfer_request` VALUES (8,'es0KU','12345678','12345678','2025-09-02','hWbFL','RzElf','2025-09-01','New','','','','','2025-09-28 14:22:29','2025-09-28 14:22:29');
/*!40000 ALTER TABLE `staff_transfer_request` ENABLE KEYS */;

--
-- Table structure for table `std_disciplinary`
--

DROP TABLE IF EXISTS `std_disciplinary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `std_disciplinary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `incident_date` date NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action_taken` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reported_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `adm_no` (`adm_no`),
  KEY `reported_by` (`reported_by`),
  CONSTRAINT `std_disciplinary_ibfk_1` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `std_disciplinary_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `std_disciplinary`
--

/*!40000 ALTER TABLE `std_disciplinary` DISABLE KEYS */;
/*!40000 ALTER TABLE `std_disciplinary` ENABLE KEYS */;

--
-- Table structure for table `stock_item`
--

DROP TABLE IF EXISTS `stock_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `category_id` int DEFAULT NULL,
  `type` enum('inventory','non-inventory','service','fixed-asset') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `base_unit_of_measure_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `purchase_cost` decimal(10,2) DEFAULT NULL,
  `depreciation_rate` decimal(5,2) DEFAULT NULL,
  `is_depreciable` tinyint(1) DEFAULT '0',
  `quantity_in_stock` decimal(10,2) DEFAULT '0.00',
  `reorder_level` decimal(10,2) DEFAULT NULL,
  `asset_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `last_service_date` date DEFAULT NULL,
  `expected_service_lifetime` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `category_id` (`category_id`),
  KEY `base_unit_of_measure_id` (`base_unit_of_measure_id`),
  CONSTRAINT `stock_item_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stock_item_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `item_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stock_item_ibfk_3` FOREIGN KEY (`base_unit_of_measure_id`) REFERENCES `base_unit_of_measure` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_item`
--

/*!40000 ALTER TABLE `stock_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_item` ENABLE KEYS */;

--
-- Table structure for table `stock_item_transaction`
--

DROP TABLE IF EXISTS `stock_item_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_item_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stock_item_id` int DEFAULT NULL,
  `transaction_type` enum('purchase','sale','disposal','service','adjustment') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `stock_item_id` (`stock_item_id`),
  CONSTRAINT `stock_item_transaction_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stock_item_transaction_ibfk_2` FOREIGN KEY (`stock_item_id`) REFERENCES `stock_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_item_transaction`
--

/*!40000 ALTER TABLE `stock_item_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_item_transaction` ENABLE KEYS */;

--
-- Table structure for table `stream`
--

DROP TABLE IF EXISTS `stream`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stream` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stream_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `capacity` int NOT NULL DEFAULT '40',
  `class_teacher` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stream_code` (`stream_code`),
  KEY `class` (`class`),
  KEY `class_teacher` (`class_teacher`),
  KEY `school` (`school`),
  CONSTRAINT `stream_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stream_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stream_ibfk_3` FOREIGN KEY (`class_teacher`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stream`
--

/*!40000 ALTER TABLE `stream` DISABLE KEYS */;
INSERT INTO `stream` VALUES (36,'12345678','G10','tn0Km','East','The eagles',40,'96CN7','2026-03-29 06:32:29','2026-03-29 06:32:29'),(39,'12345678','G10','v6lgy','West','The Champions',40,'SI08R','2026-03-29 06:55:14','2026-03-29 06:55:14'),(40,'12345678','G11','El2gP','East','The vultures',40,'P7Czm','2026-03-29 06:58:04','2026-03-29 06:58:27');
/*!40000 ALTER TABLE `stream` ENABLE KEYS */;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `surname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('Male','Female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `doa` date DEFAULT NULL,
  `profile_picture` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'upload/png/user-default.png',
  `status` enum('Active','Transferred','Dropped','Graduated') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adm_no` (`adm_no`),
  KEY `school` (`school`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (10,'12345678','11575','Abiud','Musee','Makwa','Male',NULL,NULL,NULL,'2002-02-06','2016-01-12','upload/jpeg/69ca3b261e746_1774861094.jpg','Active','2026-03-30 04:57:11','2026-03-30 08:58:14'),(11,'12345678','2652','Phoebe','Adongo','Etyang','Female',NULL,NULL,NULL,'2002-06-21','2026-03-05','upload/jpeg/69ca3b406e1e6_1774861120.jpg','Active','2026-03-30 05:47:13','2026-03-30 08:58:40'),(12,'12345678','2356','Gianna','Eva','Makwa','Female',NULL,NULL,NULL,'2006-02-05','2021-01-15','upload/jpeg/69ca3b34623fd_1774861108.jpg','Active','2026-03-30 08:32:31','2026-03-30 08:58:28');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;

--
-- Table structure for table `student_guardian`
--

DROP TABLE IF EXISTS `student_guardian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_guardian` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `guardian` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `relationship` enum('Father','Mother','Guardian','Sponsor','Sibling','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `adm_no` (`adm_no`),
  KEY `guardian` (`guardian`),
  CONSTRAINT `student_guardian_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_guardian_ibfk_2` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_guardian_ibfk_3` FOREIGN KEY (`guardian`) REFERENCES `guardian` (`guardian_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_guardian`
--

/*!40000 ALTER TABLE `student_guardian` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_guardian` ENABLE KEYS */;

--
-- Table structure for table `student_pathway`
--

DROP TABLE IF EXISTS `student_pathway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_pathway` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pathway` enum('STEM','Arts & Sports','Social Sciences','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `year_selected` year NOT NULL,
  `selected_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sp_adm` (`adm_no`),
  KEY `idx_sp_school` (`school`),
  CONSTRAINT `sp_fk_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp_fk_student` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_pathway`
--

/*!40000 ALTER TABLE `student_pathway` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_pathway` ENABLE KEYS */;

--
-- Table structure for table `student_progression`
--

DROP TABLE IF EXISTS `student_progression`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_progression` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `from_class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `to_class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transition_type` enum('Promotion','Repeat','Transfer Out','Transfer In','Pathway Selection','Automatic') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `effective_term` smallint DEFAULT NULL,
  `effective_year` year DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `recorded_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `recorded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_spg_adm` (`adm_no`),
  KEY `spg_fk_school` (`school`),
  KEY `spg_fk_from_class` (`from_class`),
  KEY `spg_fk_to_class` (`to_class`),
  CONSTRAINT `spg_fk_from_class` FOREIGN KEY (`from_class`) REFERENCES `class` (`class_code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `spg_fk_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `spg_fk_student` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `spg_fk_to_class` FOREIGN KEY (`to_class`) REFERENCES `class` (`class_code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_progression`
--

/*!40000 ALTER TABLE `student_progression` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_progression` ENABLE KEYS */;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `level` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pathway` int DEFAULT NULL,
  `category` enum('Core','Compulsory','Optional') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subject_code` (`subject_code`),
  KEY `level` (`level`),
  KEY `pathway` (`pathway`),
  CONSTRAINT `subject_ibfk_1` FOREIGN KEY (`level`) REFERENCES `academic_level` (`level_name`) ON DELETE CASCADE,
  CONSTRAINT `subject_ibfk_2` FOREIGN KEY (`pathway`) REFERENCES `pathway` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
INSERT INTO `subject` VALUES (1,'LANG100','Language Activities','Pre-Primary',NULL,'Core'),(2,'MATH100','Mathematical Activities','Pre-Primary',NULL,'Core'),(3,'ENV100','Environmental Activities','Pre-Primary',NULL,'Core'),(4,'CRE100','Creative Activities','Pre-Primary',NULL,'Core'),(5,'REL100','Religious Education Activities','Pre-Primary',NULL,'Compulsory'),(6,'PE100','Psychomotor & Outdoor Play','Pre-Primary',NULL,'Compulsory'),(7,'LIFE101','Life Skills Activities','Pre-Primary',NULL,'Compulsory'),(8,'ENG101','English','Lower Primary',NULL,'Core'),(9,'KIS101','Kiswahili','Lower Primary',NULL,'Core'),(10,'MATH101','Mathematics','Lower Primary',NULL,'Core'),(11,'ENV101','Environmental Activities','Lower Primary',NULL,'Core'),(12,'CRE101','Creative Arts','Lower Primary',NULL,'Compulsory'),(13,'REL101','Religious Education','Lower Primary',NULL,'Compulsory'),(14,'PE101','Physical & Health Education','Lower Primary',NULL,'Compulsory'),(15,'LANG101','Indigenous Language / Sign Language','Lower Primary',NULL,'Optional'),(16,'ICT101','Intro to ICT','Lower Primary',NULL,'Optional'),(17,'ENG201','English','Upper Primary',NULL,'Core'),(18,'KIS201','Kiswahili','Upper Primary',NULL,'Core'),(19,'MATH201','Mathematics','Upper Primary',NULL,'Core'),(20,'SCI201','Science & Technology','Upper Primary',NULL,'Core'),(21,'SST201','Social Studies','Upper Primary',NULL,'Core'),(22,'REL201','Religious Education','Upper Primary',NULL,'Compulsory'),(23,'CRE201','Creative Arts','Upper Primary',NULL,'Compulsory'),(24,'PE201','Physical & Health Education','Upper Primary',NULL,'Compulsory'),(25,'AGR201','Agriculture','Upper Primary',NULL,'Optional'),(26,'ICT201','ICT','Upper Primary',NULL,'Optional'),(27,'LANG201','Foreign / Indigenous Language','Upper Primary',NULL,'Optional'),(28,'ENG301','English','Junior Secondary',NULL,'Core'),(29,'KIS301','Kiswahili','Junior Secondary',NULL,'Core'),(30,'MATH301','Mathematics','Junior Secondary',NULL,'Core'),(31,'SCI301','Integrated Science','Junior Secondary',NULL,'Core'),(32,'SST301','Social Studies','Junior Secondary',NULL,'Core'),(33,'REL301','Religious Education','Junior Secondary',NULL,'Compulsory'),(34,'PE301','Physical Education','Junior Secondary',NULL,'Compulsory'),(35,'LIFE301','Life Skills','Junior Secondary',NULL,'Compulsory'),(36,'CRE301','Creative Arts','Junior Secondary',NULL,'Optional'),(37,'AGR301','Agriculture','Junior Secondary',NULL,'Optional'),(38,'ICT301','Computer Studies','Junior Secondary',NULL,'Optional'),(39,'LANG301','Indigenous / Foreign Language','Junior Secondary',NULL,'Optional'),(40,'ENG401','English','Senior Secondary',1,'Core'),(41,'KIS401','Kiswahili','Senior Secondary',1,'Core'),(42,'MATH401','Mathematics','Senior Secondary',1,'Core'),(43,'FMT401','Further Mathematics','Senior Secondary',1,'Optional'),(44,'PHY401','Physics','Senior Secondary',1,'Compulsory'),(45,'CHE401','Chemistry','Senior Secondary',1,'Compulsory'),(46,'BIO401','Biology','Senior Secondary',1,'Compulsory'),(47,'CSC401','Computer Science','Senior Secondary',1,'Optional'),(48,'AGR401','Agriculture','Senior Secondary',1,'Optional'),(49,'ELE401','Electrical Technology','Senior Secondary',1,'Optional'),(50,'ICT401','Information & Communication Technology','Senior Secondary',1,'Optional'),(51,'GEO401','Geography','Senior Secondary',1,'Optional'),(52,'ECON401','Economics','Senior Secondary',1,'Optional'),(53,'ENG402','English','Senior Secondary',2,'Core'),(54,'KIS402','Kiswahili','Senior Secondary',2,'Core'),(55,'MATH402','Mathematics','Senior Secondary',2,'Core'),(56,'VIS402','Visual Arts','Senior Secondary',2,'Compulsory'),(57,'PER402','Performing Arts','Senior Secondary',2,'Compulsory'),(58,'MUS402','Music','Senior Secondary',2,'Optional'),(59,'DRA402','Drama','Senior Secondary',2,'Optional'),(60,'PE402','Physical Education & Sports Science','Senior Secondary',2,'Compulsory'),(61,'FILM402','Film & Media Studies','Senior Secondary',2,'Optional'),(62,'CRE402','Creative Writing & Literature','Senior Secondary',2,'Optional'),(63,'GEO402','Geography','Senior Secondary',2,'Optional'),(64,'ENG403','English','Senior Secondary',3,'Core'),(65,'KIS403','Kiswahili','Senior Secondary',3,'Core'),(66,'MATH403','Mathematics','Senior Secondary',3,'Core'),(67,'HIS403','History','Senior Secondary',3,'Compulsory'),(68,'GEO403','Geography','Senior Secondary',3,'Compulsory'),(69,'ECO403','Economics','Senior Secondary',3,'Compulsory'),(70,'SOC403','Sociology','Senior Secondary',3,'Optional'),(71,'PSY403','Psychology','Senior Secondary',3,'Optional'),(72,'REL403','Religious Education','Senior Secondary',3,'Optional'),(73,'PHIL403','Philosophy','Senior Secondary',3,'Optional'),(74,'LANG403','Foreign Language (French / German / Arabic / Mandarin)','Senior Secondary',3,'Optional'),(75,'ENG404','English','Senior Secondary',4,'Core'),(76,'KIS404','Kiswahili','Senior Secondary',4,'Core'),(77,'MATH404','Mathematics','Senior Secondary',4,'Core'),(78,'BUS404','Business Studies','Senior Secondary',4,'Compulsory'),(79,'ENT404','Entrepreneurship','Senior Secondary',4,'Compulsory'),(80,'ACC404','Accounting','Senior Secondary',4,'Optional'),(81,'AGR404','Agriculture','Senior Secondary',4,'Optional'),(82,'ELE404','Electrical Technology','Senior Secondary',4,'Optional'),(83,'AUTO404','Automotive Technology','Senior Secondary',4,'Optional'),(84,'HOSP404','Hospitality & Catering','Senior Secondary',4,'Optional'),(85,'ICT404','ICT / Computer Studies','Senior Secondary',4,'Optional'),(86,'FNB404','Food & Nutrition','Senior Secondary',4,'Optional'),(87,'TEC404','Technical Drawing / Industrial Design','Senior Secondary',4,'Optional');
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;

--
-- Temporary view structure for view `subject_department`
--

DROP TABLE IF EXISTS `subject_department`;
/*!50001 DROP VIEW IF EXISTS `subject_department`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `subject_department` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `dept_code`,
 1 AS `dept_name`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `subject_group`
--

DROP TABLE IF EXISTS `subject_group`;
/*!50001 DROP VIEW IF EXISTS `subject_group`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `subject_group` AS SELECT 
 1 AS `id`,
 1 AS `school_code`,
 1 AS `school_name`,
 1 AS `group_code`,
 1 AS `group_name`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `subject_preference`
--

DROP TABLE IF EXISTS `subject_preference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_preference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prefer_day` int DEFAULT NULL,
  `prefer_period` enum('morning','afternoon') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `allow_double` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `subject` (`subject`),
  CONSTRAINT `subject_preference_ibfk_1` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_preference`
--

/*!40000 ALTER TABLE `subject_preference` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject_preference` ENABLE KEYS */;

--
-- Table structure for table `subject_teacher`
--

DROP TABLE IF EXISTS `subject_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_teacher` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `teacher` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `subject` (`subject`),
  KEY `teacher` (`teacher`),
  CONSTRAINT `subject_teacher_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subject_teacher_ibfk_2` FOREIGN KEY (`subject`) REFERENCES `subject` (`subject_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subject_teacher_ibfk_3` FOREIGN KEY (`teacher`) REFERENCES `staff` (`staff_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_teacher`
--

/*!40000 ALTER TABLE `subject_teacher` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject_teacher` ENABLE KEYS */;

--
-- Temporary view structure for view `support_staff`
--

DROP TABLE IF EXISTS `support_staff`;
/*!50001 DROP VIEW IF EXISTS `support_staff`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `support_staff` AS SELECT 
 1 AS `id`,
 1 AS `school`,
 1 AS `staff_code`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `gender`,
 1 AS `email`,
 1 AS `phone`,
 1 AS `id_no`,
 1 AS `hire_date`,
 1 AS `emp_term`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tax`
--

DROP TABLE IF EXISTS `tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rate` decimal(5,2) DEFAULT NULL,
  `type` enum('VAT','WHT','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  CONSTRAINT `tax_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax`
--

/*!40000 ALTER TABLE `tax` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax` ENABLE KEYS */;

--
-- Temporary view structure for view `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!50001 DROP VIEW IF EXISTS `teacher`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `teacher` AS SELECT 
 1 AS `id`,
 1 AS `school`,
 1 AS `teacher_code`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `gender`,
 1 AS `email`,
 1 AS `phone`,
 1 AS `id_no`,
 1 AS `hire_date`,
 1 AS `emp_term`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `term`
--

DROP TABLE IF EXISTS `term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term` (
  `id` int NOT NULL AUTO_INCREMENT,
  `term_code` smallint NOT NULL,
  `term_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `opening_date` date DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `term_code` (`term_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `term`
--

/*!40000 ALTER TABLE `term` DISABLE KEYS */;
INSERT INTO `term` VALUES (1,1,'Term 1','2025-01-01','2025-04-30'),(2,2,'Term 2','2025-05-01','2025-08-08'),(3,3,'Term 3','2025-09-01','2025-12-31');
/*!40000 ALTER TABLE `term` ENABLE KEYS */;

--
-- Table structure for table `timetable_constraint`
--

DROP TABLE IF EXISTS `timetable_constraint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timetable_constraint` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('block') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `teacher` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stream` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `day` int DEFAULT NULL,
  `period` int DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  CONSTRAINT `timetable_constraint_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable_constraint`
--

/*!40000 ALTER TABLE `timetable_constraint` DISABLE KEYS */;
/*!40000 ALTER TABLE `timetable_constraint` ENABLE KEYS */;

--
-- Table structure for table `training_program`
--

DROP TABLE IF EXISTS `training_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_program` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `program_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `program_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `facilitator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('New','Ongoing','Cancelled','Adjourned','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_code` (`program_code`),
  KEY `school` (`school`),
  CONSTRAINT `training_program_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_program`
--

/*!40000 ALTER TABLE `training_program` DISABLE KEYS */;
INSERT INTO `training_program` VALUES (1,'12345678','4tTpv','MIS Training','Paramount Communication Centre','2025-10-15','2025-10-14','New','Will be done at workin stations','2025-10-15 20:03:29','2025-10-17 06:08:21');
/*!40000 ALTER TABLE `training_program` ENABLE KEYS */;

--
-- Table structure for table `unit_category`
--

DROP TABLE IF EXISTS `unit_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_category`
--

/*!40000 ALTER TABLE `unit_category` DISABLE KEYS */;
INSERT INTO `unit_category` VALUES (1,'Weight','Units related to mass and weight (grams, kilograms, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(2,'Length','Units related to linear distance (meters, centimeters, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(3,'Volume','Units related to liquid or space (liters, milliliters, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(4,'Count','Discrete countable items (each, dozen, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(5,'Area','Surface area units (square meters, hectares, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(6,'Time','Time measurement units (seconds, hours, days, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(7,'Energy','Energy or power units (joules, kilowatt-hours, etc.)',1,'2025-04-20 12:35:41','2025-04-20 12:35:41'),(8,'Compound','Compound units like boxes, cartons, etc.',1,'2025-04-20 12:35:41','2025-04-20 12:35:41');
/*!40000 ALTER TABLE `unit_category` ENABLE KEYS */;

--
-- Table structure for table `unit_of_measure`
--

DROP TABLE IF EXISTS `unit_of_measure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_of_measure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `abbreviation` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `base_unit_id` int NOT NULL,
  `conversion_factor` decimal(15,6) NOT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `is_compound` tinyint(1) DEFAULT '0',
  `compound_structure` json DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_uom_base_unit` (`base_unit_id`),
  CONSTRAINT `fk_uom_base_unit` FOREIGN KEY (`base_unit_id`) REFERENCES `base_unit_of_measure` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_of_measure`
--

/*!40000 ALTER TABLE `unit_of_measure` DISABLE KEYS */;
INSERT INTO `unit_of_measure` VALUES (1,'Gram','g',1,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(2,'Kilogram','kg',1,1000.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(3,'Meter','m',3,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(4,'Centimeter','cm',3,0.010000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(5,'Liter','L',5,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(6,'Milliliter','mL',5,0.001000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(7,'Each','EA',7,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(8,'Dozen','DZ',7,12.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(9,'Pair','PR',7,2.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(10,'Gross','GR',7,144.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(11,'Square Meter','m┬▓',8,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(12,'Hectare','ha',8,10000.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(13,'Second','s',9,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(14,'Minute','min',9,60.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(15,'Hour','hr',9,3600.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(16,'Joule','J',11,1.000000,1,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(17,'Kilojoule','kJ',11,1000.000000,0,0,NULL,NULL,1,'2025-04-20 12:35:52','2025-04-20 12:35:52'),(18,'Box of 12 Each','BOX12',7,12.000000,0,1,'{\"unit\": \"Each\", \"contains\": 12}','1 Box contains 12 items',1,'2025-04-20 12:40:52','2025-04-20 12:40:52'),(19,'Pack of 6 Each','PK6',7,6.000000,0,1,'{\"unit\": \"Each\", \"contains\": 6}','1 Pack contains 6 items',1,'2025-04-20 12:40:52','2025-04-20 12:40:52'),(20,'Carton of 24 Bottles','CTN24',7,24.000000,0,1,'{\"unit\": \"Bottle\", \"contains\": 24}','1 Carton contains 24 Bottles',1,'2025-04-20 12:40:52','2025-04-20 12:40:52'),(21,'Tray of 30 Eggs','TRY30',7,30.000000,0,1,'{\"unit\": \"Egg\", \"contains\": 30}','1 Tray contains 30 eggs',1,'2025-04-20 12:40:52','2025-04-20 12:40:52'),(22,'Pallet of 50 Boxes (12 Each)','PLT50B12',7,600.000000,0,1,'{\"structure\": [{\"unit\": \"Box\", \"contains\": 50}, {\"unit\": \"Each\", \"box_contains\": 12}]}','1 Pallet contains 50 boxes of 12 each (total 600 items)',1,'2025-04-20 12:40:52','2025-04-20 12:40:52');
/*!40000 ALTER TABLE `unit_of_measure` ENABLE KEYS */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `userid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `displayname` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `photo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `regdate` date NOT NULL,
  `lastlogindate` date DEFAULT NULL,
  `lastlogintime` time DEFAULT NULL,
  `lastlogoutdate` date DEFAULT NULL,
  `lastlogouttime` time DEFAULT NULL,
  `attempts` int NOT NULL DEFAULT '4',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userid` (`userid`),
  UNIQUE KEY `email` (`email`),
  KEY `school` (`school`),
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (34,'12345678','hWbFL','pcc','$2y$12$TJzElX3ahnYnsWLKmMqEXenZEz7N/w0EpGB8oAz4cjLrL0MOyKyTi','Musee Abiud','sa','school','museeabiud@outlook.com','0741915943','upload/png/user-default-2-min.png','2025-09-19','2026-03-31','09:35:29','2026-03-29','06:13:16',4,1,'f35c38e177dbe74b046615b257d34865','2025-09-19 18:55:28','2026-03-31 21:35:29',NULL),(36,'12345678','Bd8aS','12345678','$2y$12$OXpzfJvEDMrgopZrDfR1eOdHQLngV.cJhkrB27lZ.4VjgL1t2i06y','PCC Secondary School','school','school','pccws.limited@gmail.com','0741915943','upload/png/user-default-2-min.png','2025-09-19','2025-10-19','12:15:09','2025-10-19','12:25:22',4,1,NULL,'2025-09-19 18:55:28','2025-10-19 00:25:22',NULL),(37,'12345678','gfgdg','87654321','$2y$12$OXpzfJvEDMrgopZrDfR1eOdHQLngV.cJhkrB27lZ.4VjgL1t2i06y','PCC Secondary School','school','hrm','87654321@gmail.com','0741915943','upload/png/user-default-2-min.png','2025-09-19','2025-10-06','10:06:04',NULL,NULL,4,1,'cf41678d2a5c6b011a12e179dc194789','2025-09-21 18:05:33','2025-10-06 10:06:04',NULL),(38,'12345678','32456578','kobwoyo','$2y$12$bVU05pt2Ui1Ie32tX4nlZ.PeDDPNQuvMnqMZpGv2sxhAzBbnOvLLe','Kelvin Obwoyo','support','support','kobwoyo@gmail.com','0767856545','upload/png/user-default-2-min.png','2025-09-27','2025-09-27','09:49:55','2025-09-27','09:59:04',4,1,NULL,'2025-09-27 09:49:27','2025-10-03 08:11:18',NULL),(39,'12345678','32352452','nancy','$2y$12$szlcVnQWJtH85xsj5GsUWeB5wWu0sebeB1dnwxo/EDuwGMR7yZiRe','Nancy Chemtai','support','support','nancychem@gmail.com','0751423652','upload/png/user-default-2-min.png','2025-09-27','2025-09-27','10:05:59','2025-09-27','10:13:55',4,1,NULL,'2025-09-27 10:05:29','2025-10-03 08:11:18',NULL),(40,'36626126','KtsBm','36626126','$2y$12$9/UCKFOQNRVB556vX7Mqc.WdlBc53zGc7fnoiCvpcrfIKLBW3F.Rq','Sibanga S.A Comprehensive School','school','school','sasibangacs@go.ke','0700212354','upload/jpeg/68e0c9c2849db_1759562178.jpg','2025-10-04','2025-10-04','10:22:24','2025-10-04','10:28:47',4,1,NULL,'2025-10-04 10:22:07','2025-10-04 10:28:47',NULL),(41,'36626205','dcOJC','36626205','$2y$12$cQD5rhGTUyawq9.8mAGgjuCInC.XTzyEg./6gxHtZyiyk52AWbuwW','AC. Bungonge High School','school','school','acbutongehs@go.ke','0788665544','upload/jpeg/68e0d92e08b41_1759566126.jpg','2025-10-04','2025-10-04','11:25:42',NULL,NULL,4,1,'3f67af1d38ad76996480364d534aea53','2025-10-04 11:25:28','2025-10-04 13:17:41',NULL),(42,'12345678','15643256','silas','$2y$12$ild7S.hYLXzLgwzGJa9ccu.FTJm6jnoDKpjEje2zpVYZ3lEz1vL96','Silas Wanambisi','sa','finance','wsilas@gmail.com','0124345365','upload/png/user-default-2-min.png','2025-10-04','2025-10-04','12:16:36','2025-10-04','12:15:03',4,1,'3e57fa1f57a109b498a849f128792aa7','2025-10-04 11:47:04','2025-10-04 13:57:10',NULL),(43,'36626123','cVfoi','36626123','$2y$12$CfTAMDFzUAzzY5IxT33gJuVG2f4eB0M6aQO7lSJl.m640tFLGGdyi','Namwela Friends Boys High School','school','hrm','namwelafbhs@gmail.com','0723456789','upload/jpeg/68e257cca7e30_1759664076.jpg','2025-10-05','2025-10-12','07:55:01','2025-10-12','08:20:52',4,1,NULL,'2025-10-05 16:23:23','2025-10-12 08:20:52',NULL),(45,'12345678','12345678','bahati','$2y$12$d2Hszxqn7UF3uoSHzvai4.UwMwlSwgukhjICimt85oCC85sAUNUJy','Abigael Bahati','teacher','teacher','abigaelbahati@gmail.com','0756342314','upload/jpeg/2e4d26d7e8f5e1b62f2a17d549ffe6c5.jpg','2025-10-06','2025-10-12','08:21:37','2025-10-09','03:17:02',4,1,'5834666e818d5d2de1fe070b481ad548','2025-10-06 11:05:58','2025-10-12 08:21:37',NULL),(46,'32564215','VUw6a','32564215','$2y$12$W/pfxfovS4ed.yeQk.7vS.MxEzMRXLFDVcvSWt0hO5XVoXPmQ2XWO','St. Ann\'s Comprehensive School','school','school','stannscs@gmail.com','0752142635','upload/jpeg/696b614ad9442_1768644938.jpg','2026-01-18',NULL,NULL,NULL,NULL,4,1,NULL,'2026-01-18 13:15:14','2026-01-18 13:15:14',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

--
-- Table structure for table `vendor`
--

DROP TABLE IF EXISTS `vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `vendor_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `vendor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact_phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `physical_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vendor_no` (`vendor_no`),
  KEY `school` (`school`),
  CONSTRAINT `vendor_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendor`
--

/*!40000 ALTER TABLE `vendor` DISABLE KEYS */;
/*!40000 ALTER TABLE `vendor` ENABLE KEYS */;

--
-- Dumping routines for database 'educore360'
--
/*!50003 DROP PROCEDURE IF EXISTS `generate_balance_sheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_balance_sheet`()
BEGIN
    SELECT 
        type,
        SUM(jl.debit - jl.credit) AS balance
    FROM chart_of_account coa
    JOIN journal_line jl ON jl.account_id = coa.id
    WHERE coa.type IN ('Asset', 'Liability', 'Equity')
    GROUP BY type;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generate_trial_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_trial_balance`()
BEGIN
    SELECT 
        coa.account_code,
        coa.name,
        SUM(CASE WHEN jl.debit > 0 THEN jl.debit ELSE 0 END) AS total_debit,
        SUM(CASE WHEN jl.credit > 0 THEN jl.credit ELSE 0 END) AS total_credit
    FROM chart_of_account coa
    LEFT JOIN journal_line jl ON coa.id = jl.account_id
    GROUP BY coa.id, coa.account_code, coa.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_bill_paid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_bill_paid`(IN billId INT)
BEGIN
    UPDATE bill
    SET status = 'Paid', payment_status = 'Paid'
    WHERE id = billId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_invoice_paid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_invoice_paid`(IN invoiceId INT)
BEGIN
    UPDATE invoice
    SET status = 'Paid', payment_status = 'Paid'
    WHERE id = invoiceId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pivot_assessment_result` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pivot_assessment_result`(
    IN p_school VARCHAR(8),
    IN p_class VARCHAR(10),
    IN p_stream VARCHAR(10),
    IN p_adm_no VARCHAR(10),
    IN p_subject_id INT,
    IN p_assessment_id INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE col_list TEXT DEFAULT '';
    DECLARE comp_name VARCHAR(100);
    DECLARE comp_id INT;
    DECLARE cur1 CURSOR FOR
        SELECT c.id, c.name
        FROM competency c
        JOIN assessment_result ar ON ar.competency_id = c.id
        JOIN assessment a ON a.id = ar.assessment_id
        WHERE (p_subject_id IS NULL OR c.subject_id = p_subject_id)
          AND (p_assessment_id IS NULL OR a.id = p_assessment_id)
        GROUP BY c.id, c.name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Step 1: Build dynamic column list
    OPEN cur1;

    read_loop: LOOP
        FETCH cur1 INTO comp_id, comp_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Column alias formatted like `comp_Literacy`
        SET col_list = CONCAT_WS(', ', col_list,
            CONCAT(
                'MAX(CASE WHEN ar.competency_id = ', comp_id,
                ' THEN ar.score ELSE NULL END) AS `comp_', REPLACE(comp_name, '`', ''), '`'
            )
        );
    END LOOP;

    CLOSE cur1;

    -- Step 2: Build dynamic SQL
    SET @sql_query = CONCAT(
        'SELECT ar.adm_no, s.name AS student_name, ', col_list,
        ' FROM assessment_result ar',
        ' JOIN student s ON ar.adm_no = s.adm_no',
        ' JOIN assessment a ON ar.assessment_id = a.id',
        ' JOIN competency c ON ar.competency_id = c.id',
        ' WHERE 1=1',
        IF(p_school IS NOT NULL, CONCAT(' AND ar.school = "', p_school, '"'), ''),
        IF(p_class IS NOT NULL, CONCAT(' AND s.class = "', p_class, '"'), ''),
        IF(p_stream IS NOT NULL, CONCAT(' AND s.stream = "', p_stream, '"'), ''),
        IF(p_adm_no IS NOT NULL, CONCAT(' AND ar.adm_no = "', p_adm_no, '"'), ''),
        IF(p_subject_id IS NOT NULL, CONCAT(' AND c.subject_id = ', p_subject_id), ''),
        IF(p_assessment_id IS NOT NULL, CONCAT(' AND ar.assessment_id = ', p_assessment_id), ''),
        ' GROUP BY ar.adm_no, s.name'
    );

    -- Step 3: Execute the SQL
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `branch`
--

/*!50001 DROP VIEW IF EXISTS `branch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `branch` AS select distinct `dv_branch`.`id` AS `id`,`dv_branch`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_branch`.`dv_code` AS `branch_code`,`dv_branch`.`dv_name` AS `branch_name`,`dv_branch`.`description` AS `description`,`dv_branch`.`incharge` AS `manager` from (((`dim_value` `dv_branch` join `dimension` `d` on((`dv_branch`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_branch`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_branch`.`incharge` = `t`.`staff_code`))) where (`dv_branch`.`filter_name` = 'Branch') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `department`
--

/*!50001 DROP VIEW IF EXISTS `department`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `department` AS select distinct `dv_department`.`id` AS `id`,`dv_department`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_department`.`dv_code` AS `dept_code`,`dv_department`.`dv_name` AS `dept_name`,`dv_department`.`description` AS `description`,`dv_department`.`incharge` AS `dept_hod` from (((`dim_value` `dv_department` join `dimension` `d` on((`dv_department`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_department`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_department`.`incharge` = `t`.`staff_code`))) where (`dv_department`.`filter_name` = 'Department') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `location`
--

/*!50001 DROP VIEW IF EXISTS `location`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `location` AS select distinct `dv_location`.`id` AS `id`,`dv_location`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_location`.`dv_code` AS `location_code`,`dv_location`.`dv_name` AS `location_name`,`dv_location`.`description` AS `description`,`dv_location`.`incharge` AS `manager` from (((`dim_value` `dv_location` join `dimension` `d` on((`dv_location`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_location`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_location`.`incharge` = `t`.`staff_code`))) where (`dv_location`.`filter_name` = 'Store Location') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `principal`
--

/*!50001 DROP VIEW IF EXISTS `principal`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `principal` AS select `staff`.`school` AS `school`,`staff`.`staff_code` AS `teacher_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Principal') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `settlement_type`
--

/*!50001 DROP VIEW IF EXISTS `settlement_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `settlement_type` AS select distinct `dv_stype`.`id` AS `id`,`dv_stype`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_stype`.`dv_code` AS `st_code`,`dv_stype`.`dv_name` AS `st_name`,`dv_stype`.`description` AS `description`,`dv_stype`.`incharge` AS `manager` from (((`dim_value` `dv_stype` join `dimension` `d` on((`dv_stype`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_stype`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_stype`.`incharge` = `t`.`staff_code`))) where (`dv_stype`.`filter_name` = 'Settlement Type') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `subject_department`
--

/*!50001 DROP VIEW IF EXISTS `subject_department`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `subject_department` AS select distinct `dv_subject_dept`.`id` AS `id`,`dv_subject_dept`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_subject_dept`.`dv_code` AS `dept_code`,`dv_subject_dept`.`dv_name` AS `dept_name`,`dv_subject_dept`.`description` AS `description` from ((`dim_value` `dv_subject_dept` join `dimension` `d` on((`dv_subject_dept`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_subject_dept`.`school` = `sch`.`school_code`))) where (`dv_subject_dept`.`filter_name` = 'Subject Department') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `subject_group`
--

/*!50001 DROP VIEW IF EXISTS `subject_group`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `subject_group` AS select distinct `dv_group`.`id` AS `id`,`dv_group`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_group`.`dv_code` AS `group_code`,`dv_group`.`dv_name` AS `group_name`,`dv_group`.`description` AS `description` from ((`dim_value` `dv_group` join `dimension` `d` on((`dv_group`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_group`.`school` = `sch`.`school_code`))) where (`dv_group`.`filter_name` = 'Subject Group') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `support_staff`
--

/*!50001 DROP VIEW IF EXISTS `support_staff`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `support_staff` AS select `staff`.`id` AS `id`,`staff`.`school` AS `school`,`staff`.`staff_code` AS `staff_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Support') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `teacher`
--

/*!50001 DROP VIEW IF EXISTS `teacher`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `teacher` AS select `staff`.`id` AS `id`,`staff`.`school` AS `school`,`staff`.`staff_code` AS `teacher_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Teacher') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-31 23:03:50
