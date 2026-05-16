-- Database Backup: educore360
-- Generated on: 2026-05-11 04:21:26

SET FOREIGN_KEY_CHECKS=0;

-- Structure for table `academic_level`
CREATE TABLE `academic_level` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `level_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `stage_order` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `level_name` (`level_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `academic_level`
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('1', 'Pre-Primary', '1');
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('2', 'Lower Primary', '2');
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('3', 'Upper Primary', '3');
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('4', 'Junior Secondary', '4');
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('5', 'Senior Secondary', '5');
INSERT INTO `academic_level` (`id`, `level_name`, `stage_order`) VALUES ('6', 'Tertiary Education', '6');

-- Structure for table `academic_session`
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

-- Structure for table `admission_request`
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

-- Structure for table `assessment`
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

-- Structure for table `assessment_result`
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

-- Structure for table `audit_log`
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

-- Data for table `audit_log`
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('1', NULL, 'UPDATE', 'chart_of_account', '1', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('2', NULL, 'UPDATE', 'chart_of_account', '2', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('3', NULL, 'UPDATE', 'chart_of_account', '3', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('4', NULL, 'UPDATE', 'chart_of_account', '4', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('5', NULL, 'UPDATE', 'chart_of_account', '5', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('6', NULL, 'UPDATE', 'chart_of_account', '6', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('7', NULL, 'UPDATE', 'chart_of_account', '7', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('8', NULL, 'UPDATE', 'chart_of_account', '8', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('9', NULL, 'UPDATE', 'chart_of_account', '9', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('10', NULL, 'UPDATE', 'chart_of_account', '10', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('11', NULL, 'UPDATE', 'chart_of_account', '11', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('12', NULL, 'UPDATE', 'chart_of_account', '12', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('13', NULL, 'UPDATE', 'chart_of_account', '13', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('14', NULL, 'UPDATE', 'chart_of_account', '14', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('15', NULL, 'UPDATE', 'chart_of_account', '15', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('16', NULL, 'UPDATE', 'chart_of_account', '16', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('17', NULL, 'UPDATE', 'chart_of_account', '17', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('18', NULL, 'UPDATE', 'chart_of_account', '18', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('19', NULL, 'UPDATE', 'chart_of_account', '19', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('20', NULL, 'UPDATE', 'chart_of_account', '20', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('21', NULL, 'UPDATE', 'chart_of_account', '21', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('22', NULL, 'UPDATE', 'chart_of_account', '22', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('23', NULL, 'UPDATE', 'chart_of_account', '23', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('24', NULL, 'UPDATE', 'chart_of_account', '24', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('25', NULL, 'UPDATE', 'chart_of_account', '25', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('26', NULL, 'UPDATE', 'chart_of_account', '26', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('27', NULL, 'UPDATE', 'chart_of_account', '27', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('28', NULL, 'UPDATE', 'chart_of_account', '28', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('29', NULL, 'UPDATE', 'chart_of_account', '29', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('30', NULL, 'UPDATE', 'chart_of_account', '30', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('31', NULL, 'UPDATE', 'chart_of_account', '31', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('32', NULL, 'UPDATE', 'chart_of_account', '32', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('33', NULL, 'UPDATE', 'chart_of_account', '33', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('34', NULL, 'UPDATE', 'chart_of_account', '34', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('35', NULL, 'UPDATE', 'chart_of_account', '35', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('36', NULL, 'UPDATE', 'chart_of_account', '36', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('37', NULL, 'UPDATE', 'chart_of_account', '37', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('38', NULL, 'UPDATE', 'chart_of_account', '38', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('39', NULL, 'UPDATE', 'chart_of_account', '39', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('40', NULL, 'UPDATE', 'chart_of_account', '40', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('41', NULL, 'UPDATE', 'chart_of_account', '41', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('42', NULL, 'UPDATE', 'chart_of_account', '42', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('43', NULL, 'UPDATE', 'chart_of_account', '43', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('44', NULL, 'UPDATE', 'chart_of_account', '44', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('45', NULL, 'UPDATE', 'chart_of_account', '45', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('46', NULL, 'UPDATE', 'chart_of_account', '46', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('47', NULL, 'UPDATE', 'chart_of_account', '47', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('48', NULL, 'UPDATE', 'chart_of_account', '48', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('49', NULL, 'UPDATE', 'chart_of_account', '49', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('50', NULL, 'UPDATE', 'chart_of_account', '50', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('51', NULL, 'UPDATE', 'chart_of_account', '51', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('52', NULL, 'UPDATE', 'chart_of_account', '52', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('53', NULL, 'UPDATE', 'chart_of_account', '53', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('54', NULL, 'UPDATE', 'chart_of_account', '54', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('55', NULL, 'UPDATE', 'chart_of_account', '55', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('56', NULL, 'UPDATE', 'chart_of_account', '56', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('57', NULL, 'UPDATE', 'chart_of_account', '57', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('58', NULL, 'UPDATE', 'chart_of_account', '58', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('59', NULL, 'UPDATE', 'chart_of_account', '59', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('60', NULL, 'UPDATE', 'chart_of_account', '60', '', '', '2025-09-22 10:00:49', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('61', NULL, 'UPDATE', 'chart_of_account', '1', '', '', '2025-09-22 10:38:53', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('62', NULL, 'UPDATE', 'chart_of_account', '2', '', '', '2025-09-22 10:38:53', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('63', NULL, 'UPDATE', 'chart_of_account', '3', '', '', '2025-09-22 10:38:53', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('64', NULL, 'UPDATE', 'chart_of_account', '4', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('65', NULL, 'UPDATE', 'chart_of_account', '5', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('66', NULL, 'UPDATE', 'chart_of_account', '6', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('67', NULL, 'UPDATE', 'chart_of_account', '7', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('68', NULL, 'UPDATE', 'chart_of_account', '8', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('69', NULL, 'UPDATE', 'chart_of_account', '9', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('70', NULL, 'UPDATE', 'chart_of_account', '10', '', '', '2025-09-22 10:39:29', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('71', NULL, 'UPDATE', 'chart_of_account', '11', '', '', '2025-09-22 10:41:13', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('72', NULL, 'UPDATE', 'chart_of_account', '12', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('73', NULL, 'UPDATE', 'chart_of_account', '13', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('74', NULL, 'UPDATE', 'chart_of_account', '14', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('75', NULL, 'UPDATE', 'chart_of_account', '15', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('76', NULL, 'UPDATE', 'chart_of_account', '16', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('77', NULL, 'UPDATE', 'chart_of_account', '17', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('78', NULL, 'UPDATE', 'chart_of_account', '18', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('79', NULL, 'UPDATE', 'chart_of_account', '19', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('80', NULL, 'UPDATE', 'chart_of_account', '20', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('81', NULL, 'UPDATE', 'chart_of_account', '21', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('82', NULL, 'UPDATE', 'chart_of_account', '22', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('83', NULL, 'UPDATE', 'chart_of_account', '23', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('84', NULL, 'UPDATE', 'chart_of_account', '24', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('85', NULL, 'UPDATE', 'chart_of_account', '25', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('86', NULL, 'UPDATE', 'chart_of_account', '26', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('87', NULL, 'UPDATE', 'chart_of_account', '27', '', '', '2025-09-22 10:41:14', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('88', NULL, 'UPDATE', 'chart_of_account', '28', '', '', '2025-09-22 10:43:17', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('89', NULL, 'UPDATE', 'chart_of_account', '29', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('90', NULL, 'UPDATE', 'chart_of_account', '30', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('91', NULL, 'UPDATE', 'chart_of_account', '31', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('92', NULL, 'UPDATE', 'chart_of_account', '32', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('93', NULL, 'UPDATE', 'chart_of_account', '33', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('94', NULL, 'UPDATE', 'chart_of_account', '34', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('95', NULL, 'UPDATE', 'chart_of_account', '35', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('96', NULL, 'UPDATE', 'chart_of_account', '36', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('97', NULL, 'UPDATE', 'chart_of_account', '37', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('98', NULL, 'UPDATE', 'chart_of_account', '38', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('99', NULL, 'UPDATE', 'chart_of_account', '39', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('100', NULL, 'UPDATE', 'chart_of_account', '40', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('101', NULL, 'UPDATE', 'chart_of_account', '41', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('102', NULL, 'UPDATE', 'chart_of_account', '42', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('103', NULL, 'UPDATE', 'chart_of_account', '43', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('104', NULL, 'UPDATE', 'chart_of_account', '44', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('105', NULL, 'UPDATE', 'chart_of_account', '45', '', '', '2025-09-22 10:43:18', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('106', NULL, 'UPDATE', 'chart_of_account', '46', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('107', NULL, 'UPDATE', 'chart_of_account', '47', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('108', NULL, 'UPDATE', 'chart_of_account', '48', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('109', NULL, 'UPDATE', 'chart_of_account', '49', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('110', NULL, 'UPDATE', 'chart_of_account', '50', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('111', NULL, 'UPDATE', 'chart_of_account', '51', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('112', NULL, 'UPDATE', 'chart_of_account', '52', '', '', '2025-09-22 10:44:24', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('113', NULL, 'UPDATE', 'chart_of_account', '53', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('114', NULL, 'UPDATE', 'chart_of_account', '54', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('115', NULL, 'UPDATE', 'chart_of_account', '55', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('116', NULL, 'UPDATE', 'chart_of_account', '56', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('117', NULL, 'UPDATE', 'chart_of_account', '57', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('118', NULL, 'UPDATE', 'chart_of_account', '58', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('119', NULL, 'UPDATE', 'chart_of_account', '59', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('120', NULL, 'UPDATE', 'chart_of_account', '60', '', '', '2025-09-22 10:44:25', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('121', NULL, 'UPDATE', 'chart_of_account', '27', '', '', '2025-09-22 10:02:21', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('122', NULL, 'UPDATE', 'chart_of_account', '28', '', '', '2025-09-22 10:02:21', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('123', NULL, 'UPDATE', 'chart_of_account', '29', '', '', '2025-09-22 10:02:21', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('124', NULL, 'UPDATE', 'chart_of_account', '30', '', '', '2025-09-22 10:02:21', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('125', NULL, 'UPDATE', 'chart_of_account', '31', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('126', NULL, 'UPDATE', 'chart_of_account', '32', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('127', NULL, 'UPDATE', 'chart_of_account', '33', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('128', NULL, 'UPDATE', 'chart_of_account', '34', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('129', NULL, 'UPDATE', 'chart_of_account', '35', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('130', NULL, 'UPDATE', 'chart_of_account', '36', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('131', NULL, 'UPDATE', 'chart_of_account', '37', '', '', '2025-09-22 10:02:22', NULL);
INSERT INTO `audit_log` (`id`, `user`, `action`, `table_name`, `record_id`, `ip_address`, `user_agent`, `timestamp`, `updated_by`) VALUES ('132', NULL, 'UPDATE', 'chart_of_account', '38', '', '', '2025-09-22 10:02:22', NULL);

-- Structure for table `bank_account`
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

-- Structure for table `bank_transaction`
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

-- Structure for table `base_unit_of_measure`
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

-- Data for table `base_unit_of_measure`
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('1', 'Gram', 'g', '1', NULL, 'g', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('2', 'Kilogram', 'kg', '1', NULL, 'kg', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('3', 'Meter', 'm', '2', NULL, 'm', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('4', 'Centimeter', 'cm', '2', '', 'cm', '1', '1', '2025-04-20 12:35:46', '2025-04-20 15:52:14');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('5', 'Liter', 'L', '3', NULL, 'Î“Ã¤Ã´', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('6', 'Milliliter', 'mL', '3', NULL, 'mL', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('7', 'Each', 'EA', '4', '', '', '0', '1', '2025-04-20 12:35:46', '2026-01-02 12:17:02');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('8', 'Square Meter', 'mâ”¬â–“', '5', NULL, 'mâ”¬â–“', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('9', 'Second', 's', '6', NULL, 's', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('10', 'Hour', 'hr', '6', NULL, 'h', '0', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');
INSERT INTO `base_unit_of_measure` (`id`, `name`, `abbreviation`, `category_id`, `description`, `symbol`, `si_unit`, `is_active`, `created_at`, `updated_at`) VALUES ('11', 'Joule', 'J', '7', NULL, 'J', '1', '1', '2025-04-20 12:35:46', '2025-04-20 12:35:46');

-- Structure for table `benefit_type`
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `benefit_type`
INSERT INTO `benefit_type` (`id`, `school`, `benefit_type_code`, `benefit_type_name`, `is_recurring`, `recurring_type`, `quantity`, `created_at`, `updated_at`) VALUES ('1', '12345678', 'qc8G0', 'Airtime Reimbassment', '1', 'Monthly', '3', '2025-09-27 07:47:29', '2025-09-27 07:48:30');
INSERT INTO `benefit_type` (`id`, `school`, `benefit_type_code`, `benefit_type_name`, `is_recurring`, `recurring_type`, `quantity`, `created_at`, `updated_at`) VALUES ('2', '12345678', 'BuTir', 'X-Mass Shopping', '1', 'Yearly', '5', '2025-09-27 07:51:41', '2025-09-27 07:51:41');
INSERT INTO `benefit_type` (`id`, `school`, `benefit_type_code`, `benefit_type_name`, `is_recurring`, `recurring_type`, `quantity`, `created_at`, `updated_at`) VALUES ('3', '12345678', 'YsJFM', 'Transport Fare', '1', 'Monthly', '2', '2025-09-27 07:53:39', '2025-09-27 07:53:39');
INSERT INTO `benefit_type` (`id`, `school`, `benefit_type_code`, `benefit_type_name`, `is_recurring`, `recurring_type`, `quantity`, `created_at`, `updated_at`) VALUES ('4', '43544646', 'ZvJd4', 'Health Insurance Cover', '1', 'Monthly', '12', '2026-05-11 00:10:27', '2026-05-11 00:10:27');

-- Structure for table `bill`
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

-- Structure for table `centre_manager`
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

-- Structure for table `charge`
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

-- Structure for table `chart_of_account`
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

-- Data for table `chart_of_account`
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('1', '12345678', '1000', 'Cash', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:38:53', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('2', '12345678', '1010', 'Bank Accounts', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:38:53', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('3', '12345678', '1020', 'Petty Cash', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:38:53', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('4', '12345678', '1100', 'Accounts Receivable (Tuition Fees)', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('5', '12345678', '1101', 'Accounts Receivable (Other)', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('6', '12345678', '1200', 'Prepaid Expenses', 'Asset', 'Current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('7', '12345678', '1300', 'Inventory (Books, Uniforms)', 'Asset', 'Inventory', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('8', '12345678', '1400', 'Property, Plant & Equipment', 'Asset', 'Non-current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('9', '12345678', '1410', 'Buildings', 'Asset', 'Non-current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('10', '12345678', '1420', 'Furniture & Fixtures', 'Asset', 'Non-current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:39:29', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('11', '12345678', '1430', 'Computers & ICT Equipment', 'Asset', 'Non-current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:13', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('12', '12345678', '1500', 'Accumulated Depreciation', 'Asset', 'Contra Asset', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('13', '12345678', '1600', 'Investments', 'Asset', 'Non-current Asset', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('14', '12345678', '1700', 'Grants Receivable', 'Asset', 'Receivable', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('15', '12345678', '2000', 'Accounts Payable', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('16', '12345678', '2100', 'Salaries Payable', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('17', '12345678', '2200', 'Taxes Payable', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('18', '12345678', '2300', 'Deferred Revenue (Unearned Fees)', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('19', '12345678', '2400', 'Loans Payable', 'Liability', 'Long-term Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('20', '12345678', '2500', 'Accrued Expenses', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('21', '12345678', '2600', 'Tuition Refund Liability', 'Liability', 'Current Liability', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('22', '12345678', '3000', 'Fund Balance', 'Equity', 'Equity', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('23', '12345678', '3100', 'Capital Contributions', 'Equity', 'Equity', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('24', '12345678', '3200', 'Restricted Funds (Scholarships)', 'Equity', 'Restricted Fund', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('25', '12345678', '3300', 'Endowment Fund', 'Equity', 'Restricted Fund', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('26', '12345678', '3400', 'Surplus / Deficit', 'Equity', 'Net Result', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:41:14', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('27', '12345678', '4000', 'Tuition Fees', 'Income', 'Education Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:21', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('28', '12345678', '4010', 'Registration Fees', 'Income', 'Education Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:21', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('29', '12345678', '4020', 'Exam Fees', 'Income', 'Education Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:21', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('30', '12345678', '4030', 'Boarding Fees', 'Income', 'Education Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:21', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('31', '12345678', '4040', 'Library Fees', 'Income', 'Service Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('32', '12345678', '4050', 'Transport Fees', 'Income', 'Service Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('33', '12345678', '4060', 'Uniform Sales', 'Income', 'Sales Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('34', '12345678', '4070', 'Bookstore Sales', 'Income', 'Sales Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('35', '12345678', '4080', 'Grants Received', 'Income', 'Grants', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('36', '12345678', '4090', 'Donations & Fundraising', 'Income', 'Other Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('37', '12345678', '4100', 'Rental Income', 'Income', 'Other Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('38', '12345678', '4110', 'Interest Income', 'Income', 'Other Income', NULL, 'Credit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:02:22', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('39', '12345678', '5000', 'Salaries & Wages', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('40', '12345678', '5010', 'Staff Benefits', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('41', '12345678', '5020', 'Payroll Taxes', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('42', '12345678', '5030', 'Office Supplies', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('43', '12345678', '5040', 'Utilities', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('44', '12345678', '5050', 'Rent / Lease', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('45', '12345678', '5060', 'Insurance', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:43:18', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('46', '12345678', '5070', 'Communication', 'Expense', 'Admin Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('47', '12345678', '5080', 'Depreciation', 'Expense', 'Non-cash Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('48', '12345678', '5100', 'Teaching Materials', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('49', '12345678', '5110', 'Exam Materials', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('50', '12345678', '5120', 'Textbooks', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('51', '12345678', '5130', 'Lab Supplies', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('52', '12345678', '5140', 'Extracurricular Activities', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:24', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('53', '12345678', '5150', 'Scholarships Awarded', 'Expense', 'Academic Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('54', '12345678', '5200', 'Maintenance & Repairs', 'Expense', 'Operational Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('55', '12345678', '5210', 'Transport & Fuel', 'Expense', 'Operational Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('56', '12345678', '5220', 'Security Services', 'Expense', 'Operational Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('57', '12345678', '5230', 'Cleaning Services', 'Expense', 'Operational Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('58', '12345678', '5300', 'Software Subscriptions', 'Expense', 'ICT Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('59', '12345678', '5310', 'IT Support', 'Expense', 'ICT Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);
INSERT INTO `chart_of_account` (`id`, `school`, `no`, `name`, `type`, `category`, `parent`, `typical_balance`, `opening_balance`, `is_active`, `created_at`, `updated_at`, `updated_by`) VALUES ('60', '12345678', '5320', 'Equipment Purchase', 'Expense', 'ICT Expense', NULL, 'Debit', '0.00', '1', '2025-04-20 04:10:22', '2025-09-22 10:44:25', NULL);

-- Structure for table `class`
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

-- Data for table `class`
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('1', 'PP1', 'Pre-Primary I', 'PP1', 'Pre-Primary', '1');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('2', 'PP2', 'Pre-Primary II', 'PP2', 'Pre-Primary', '2');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('3', 'G1', 'Grade 1', 'Grd 1', 'Lower Primary', '3');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('4', 'G2', 'Grade 2', 'Grd 2', 'Lower Primary', '4');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('5', 'G3', 'Grade 3', 'Grd 3', 'Lower Primary', '5');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('6', 'G4', 'Grade 4', 'Grd 4', 'Upper Primary', '6');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('7', 'G5', 'Grade 5', 'Grd 5', 'Upper Primary', '7');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('8', 'G6', 'Grade 6', 'Grd 6', 'Upper Primary', '8');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('9', 'G7', 'Grade 7', 'Grd 7', 'Junior Secondary', '9');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('10', 'G8', 'Grade 8', 'Grd 8', 'Junior Secondary', '10');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('11', 'G9', 'Grade 9', 'Grd 9', 'Junior Secondary', '11');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('12', 'G10', 'Grade 10', 'Grd 10', 'Senior Secondary', '12');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('13', 'G11', 'Grade 11', 'Grd 11', 'Senior Secondary', '13');
INSERT INTO `class` (`id`, `class_code`, `class_name`, `abbrev`, `level`, `class_number`) VALUES ('14', 'G12', 'Grade 12', 'Grd 12', 'Senior Secondary', '14');

-- Structure for table `class_attendance`
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

-- Structure for table `class_enrollment`
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
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `class_enrollment`
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('9', '12345678', '11575', 'G10', 'tn0Km', '1', '2016', '2026-03-30 07:57:11', '2026-03-30 07:57:11');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('10', '12345678', '2652', 'G10', 'v6lgy', '1', '2026', '2026-03-30 08:47:13', '2026-03-30 08:47:13');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('11', '12345678', '2356', 'G10', 'v6lgy', '1', '2021', '2026-03-30 11:32:31', '2026-03-30 11:32:31');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('12', '43544646', '1719', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('13', '43544646', '1722', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('14', '43544646', '1726', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('15', '43544646', '1728', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('16', '43544646', '1730', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('17', '43544646', '1732', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('18', '43544646', '1737', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('19', '43544646', '1739', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('20', '43544646', '1741', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('21', '43544646', '1750', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('22', '43544646', '1754', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('23', '43544646', '1760', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('24', '43544646', '1761', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('25', '43544646', '1763', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('26', '43544646', '1765', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('27', '43544646', '1767', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('28', '43544646', '1772', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('29', '43544646', '1775', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('30', '43544646', '1778', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('31', '43544646', '1780', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('32', '43544646', '1782', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('33', '43544646', '1784', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('34', '43544646', '1786', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('35', '43544646', '1788', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('36', '43544646', '1790', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('37', '43544646', '1791', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('38', '43544646', '1793', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('39', '43544646', '1802', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('40', '43544646', '1807', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('41', '43544646', '1811', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('42', '43544646', '1813', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('43', '43544646', '1815', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('44', '43544646', '1822', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('45', '43544646', '1824', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('46', '43544646', '1832', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('47', '43544646', '1834', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('48', '43544646', '1837', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('49', '43544646', '1839', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('50', '43544646', '1847', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('51', '43544646', '1850', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('52', '43544646', '1851', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('53', '43544646', '1857', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('54', '43544646', '1859', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('55', '43544646', '1865', 'G10', 'JjrT0', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('56', '43544646', '1718', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('57', '43544646', '1721', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('58', '43544646', '1723', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('59', '43544646', '1724', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('60', '43544646', '1725', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('61', '43544646', '1727', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('62', '43544646', '1729', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('63', '43544646', '1731', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('64', '43544646', '1733', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('65', '43544646', '1738', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('66', '43544646', '1740', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('67', '43544646', '1743', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('68', '43544646', '1748', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('69', '43544646', '1749', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('70', '43544646', '1751', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('71', '43544646', '1753', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('72', '43544646', '1755', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('73', '43544646', '1762', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('74', '43544646', '1764', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('75', '43544646', '1766', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('76', '43544646', '1769', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('77', '43544646', '1773', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('78', '43544646', '1777', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('79', '43544646', '1779', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('80', '43544646', '1781', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('81', '43544646', '1783', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('82', '43544646', '1785', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('83', '43544646', '1787', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('84', '43544646', '1789', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('85', '43544646', '1792', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('86', '43544646', '1795', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('87', '43544646', '1796', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('88', '43544646', '1800', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('89', '43544646', '1808', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('90', '43544646', '1812', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('91', '43544646', '1814', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('92', '43544646', '1823', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('93', '43544646', '1831', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('94', '43544646', '1833', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('95', '43544646', '1843', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('96', '43544646', '1844', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');
INSERT INTO `class_enrollment` (`id`, `school`, `adm_no`, `class`, `stream`, `term`, `year`, `created_at`, `updated_at`) VALUES ('97', '43544646', '1853', 'G10', 'qOzpa', '1', '2026', '2026-05-11 05:58:08', '2026-05-11 05:58:08');

-- Structure for table `class_register`
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

-- Structure for table `class_room`
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

-- Structure for table `class_schedule`
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

-- Structure for table `class_subject`
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

-- Structure for table `competency`
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

-- Structure for table `county`
CREATE TABLE `county` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `region` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_county_region` (`region`),
  CONSTRAINT `county_ibfk_1` FOREIGN KEY (`region`) REFERENCES `region` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `county`
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('1', 'CEN', 'NYA', 'Nyandarua', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('2', 'CEN', 'NYE', 'Nyeri', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('3', 'CEN', 'KIR', 'Kirinyaga', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('4', 'CEN', 'MRU', 'Murang\'a', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('5', 'CEN', 'KIA', 'Kiambu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('6', 'COS', 'MBS', 'Mombasa', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('7', 'COS', 'KWL', 'Kwale', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('8', 'COS', 'KLF', 'Kilifi', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('9', 'COS', 'TRV', 'Tana River', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('10', 'COS', 'LAM', 'Lamu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('11', 'COS', 'TTV', 'Taita Taveta', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('12', 'EAS', 'MRU2', 'Meru', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('13', 'EAS', 'THN', 'Tharaka Nithi', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('14', 'EAS', 'EMB', 'Embu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('15', 'EAS', 'KIT', 'Kitui', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('16', 'EAS', 'MAC', 'Machakos', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('17', 'EAS', 'MKU', 'Makueni', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('18', 'NRB', 'NRB', 'Nairobi', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('19', 'NE', 'GAR', 'Garissa', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('20', 'NE', 'WAJ', 'Wajir', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('21', 'NE', 'MAN', 'Mandera', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('22', 'NYA', 'SIA', 'Siaya', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('23', 'NYA', 'KSM', 'Kisumu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('24', 'NYA', 'HMB', 'Homa Bay', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('25', 'NYA', 'MIG', 'Migori', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('26', 'NYA', 'KSI', 'Kisii', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('27', 'NYA', 'NYM', 'Nyamira', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('28', 'RV', 'TRK', 'Turkana', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('29', 'RV', 'WPK', 'West Pokot', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('30', 'RV', 'SAM', 'Samburu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('31', 'RV', 'TNT', 'Trans Nzoia', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('32', 'RV', 'UGI', 'Uasin Gishu', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('33', 'RV', 'EMK', 'Elgeyo Marakwet', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('34', 'RV', 'NAN', 'Nandi', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('35', 'RV', 'BAR', 'Baringo', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('36', 'RV', 'LAI', 'Laikipia', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('37', 'RV', 'NAK', 'Nakuru', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('38', 'RV', 'NAR', 'Narok', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('39', 'RV', 'KAJ', 'Kajiado', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('40', 'RV', 'KER', 'Kericho', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('41', 'RV', 'BOM', 'Bomet', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('42', 'WES', 'KAK', 'Kakamega', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('43', 'WES', 'VIG', 'Vihiga', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('44', 'WES', 'BUN', 'Bungoma', '2026-04-05 13:58:12', '2026-04-05 13:58:12');
INSERT INTO `county` (`id`, `region`, `code`, `description`, `created_at`, `updated_at`) VALUES ('45', 'WES', 'BUS', 'Busia', '2026-04-05 13:58:12', '2026-04-05 13:58:12');

-- Structure for table `customer`
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

-- Structure for table `depreciation_schedule`
CREATE TABLE `depreciation_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `asset_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `depreciation_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `depreciation_schedule_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `fixed_asset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Structure for table `dim_value`
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
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `dim_value`
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('56', '12345678', 'YqeQx', 'GYev5', 'Pre-Primary', 'Pre-Primary', '', '', '', 'School Level');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('57', '12345678', 'YqeQx', 'VYyLA', 'Lower Primary', 'Lower Primary', '', '', '', 'School Level');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('58', '12345678', 'YqeQx', 'pWxIe', 'Upper Primary', 'Upper Primary', '', '', '', 'School Level');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('59', '12345678', 'YqeQx', 'HphgJ', 'Junior Secondary', 'Junior Secondary', '', '', '', 'School Level');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('60', '12345678', 'YqeQx', '6tMdz', 'Senior Secondary', 'Senior Secondary', '', '', '', 'School Level');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('61', '12345678', 'DFXZP', 'FPIuv', 'Library', 'Library Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('62', '12345678', 'DFXZP', 'fwZCp', 'Tuition', 'Tuition Area', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('63', '12345678', 'DFXZP', '5sdo6', 'Transport', 'Transport', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('64', '12345678', 'DFXZP', 'c9bpa', 'Kitchen', 'Kitchen', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('65', '12345678', 'DFXZP', 'G8eQy', 'Accomodation', 'Accomodation', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('66', '12345678', 'DFXZP', 'bpeL7', 'Administration', 'Administration', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('67', '12345678', 'v7qQ0', '7IJgH', 'Mathematics', 'Mathematics', '', '', '', 'Subject Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('68', '12345678', 'v7qQ0', '0kcmQ', 'Sciences', 'Sciences', '', '', '', 'Subject Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('69', '12345678', 'v7qQ0', 'xn5A1', 'Technicals', 'Technicals', '', '', '', 'Subject Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('70', '12345678', 'v7qQ0', 'fkYKD', 'Humanities', 'Humanities', '', '', '', 'Subject Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('71', '12345678', 'v7qQ0', '5ivru', 'Languages', 'Languages', '', '', '', 'Subject Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('72', '12345678', 'a7fjk', 'wFXQf', 'Group I', 'Group I', '', '', '', 'Subject Group');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('73', '12345678', 'a7fjk', 'pzVh6', 'Group II', 'Group II', '', '', '', 'Subject Group');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('74', '12345678', 'a7fjk', 'K9V4X', 'Group III', 'Group III', '', '', '', 'Subject Group');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('75', '12345678', 'a7fjk', 'rxm9Z', 'Group IV', 'Group IV', '', '', '', 'Subject Group');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('76', '12345678', 'a7fjk', 'h3t5b', 'Group V', 'Group V', '', '', '', 'Subject Group');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('77', '36626205', 'DFXZP', 'yZ46V', 'Tution', 'Tution', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('78', '43544646', 'DFXZP', 'ADM01', 'Administration', 'Administration Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('79', '43544646', 'DFXZP', 'TUI01', 'Tuition', 'Tuition Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('80', '43544646', 'DFXZP', 'FIN01', 'Finance', 'Finance Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('81', '43544646', 'DFXZP', 'ICT01', 'ICT', 'ICT Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('82', '43544646', 'DFXZP', 'LIB01', 'Library', 'Library Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('83', '43544646', 'DFXZP', 'WEL01', 'Student Welfare', 'Student Welfare Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('84', '43544646', 'DFXZP', 'SEC01', 'Security', 'Security Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('85', '43544646', 'DFXZP', 'KIT01', 'Kitchen', 'Kitchen Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('86', '43544646', 'DFXZP', 'MNT01', 'Maintenance', 'Maintenance Department', '', '', '', 'Department');
INSERT INTO `dim_value` (`id`, `school`, `dim_id`, `dv_code`, `dv_name`, `description`, `inv_nos`, `rct_nos`, `incharge`, `filter_name`) VALUES ('87', '43544646', 'DFXZP', 'TRN01', 'Transport', 'Transport Department', '', '', '', 'Department');

-- Structure for table `dimension`
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

-- Data for table `dimension`
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('1', 'cspdG', 'Branch', 'Describes the school dimension', '2025-03-27 09:26:12', '2025-09-07 09:46:49');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('2', 'a7fjk', 'Subject Group', 'Define Subject groups such like Group I, Group II, Group III, Group IV and Group V', '2025-03-27 09:26:12', '2025-03-27 09:26:12');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('3', 'v7qQ0', 'Subject Department', 'Define department for various subjects like Mathematics, Sciences, Technicals, Humanities, Languages etc', '2025-03-27 09:26:12', '2025-03-27 09:26:12');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('4', 'FtR7N', 'Store Location', 'Definition of school locations including the main store, kitchen, hod exams', '2025-03-27 09:26:12', '2025-03-30 08:56:11');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('5', 'dTAsp', 'Settlement Type', 'Ways or methods through which students, teachers, parents or defaulters use to settle payments', '2025-03-27 09:26:12', '2025-03-30 08:41:50');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('6', 'rzWpf', 'Account Payable', 'Lists all accounts payable such as Salaries, Vendor Repayments among others', '2025-03-27 09:26:12', '2025-03-30 09:13:23');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('7', 'VHXQq', 'Account Receivable', 'Define accounts that receive income to the school e.g., Capitation, Tuition Fees, Teacher&#039;s Welfare, PTA', '2025-03-27 09:26:12', '2025-03-30 09:12:12');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('8', 'BejzK', 'Section', 'Define school sections like in academic department, Boarding, Entertainment', '2025-03-27 09:37:02', '2025-07-04 12:23:00');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('9', 'DFXZP', 'Department', 'Departments around the school e.g Administration', '2025-09-07 15:34:58', '2025-09-07 16:07:38');
INSERT INTO `dimension` (`id`, `dim_id`, `dim_name`, `dim_description`, `created_at`, `updated_at`) VALUES ('10', 'YqeQx', 'School Level', 'Define levels like Pre-Primary, Junior Primary, Senior Primary, Junior Secondary, Senior Secondary', '2025-09-19 13:22:22', '2025-09-19 13:22:22');

-- Structure for table `guardian`
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

-- Structure for table `invoice`
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

-- Structure for table `item_category`
CREATE TABLE `item_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `item_category`
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('1', 'ICT Equipment', 'Computers, printers, projectors, and related items', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('2', 'Stationery', 'Office and school stationery supplies', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('3', 'Teaching Aids', 'Smartboards, charts, educational boards', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('4', 'Furniture', 'Desks, chairs, tables, and storage units', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('5', 'Library', 'Books and literature resources', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('6', 'Electrical Appliances', 'General school electrical appliances', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('7', 'General Supplies', 'Cleaning, administrative, and utility items', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('8', 'Science Lab Equipment', 'Laboratory equipment and consumables', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('9', 'Security & Safety', 'Security items and safety gear', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');
INSERT INTO `item_category` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES ('10', 'Sports & Recreation', 'Sports and physical education equipment', '2025-04-20 23:30:34', '2025-04-20 23:30:34', '1');

-- Structure for table `job_applicant`
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

-- Data for table `job_applicant`
INSERT INTO `job_applicant` (`id`, `applicant_code`, `applicant_name`, `contact_phone`, `contact_email`, `created_at`, `updated_at`) VALUES ('1', '45454644', 'Test Applicant Name', '0114085123', 'aimekhisa23@gmail.com', '2025-10-03 14:25:37', '2025-10-09 00:37:46');
INSERT INTO `job_applicant` (`id`, `applicant_code`, `applicant_name`, `contact_phone`, `contact_email`, `created_at`, `updated_at`) VALUES ('2', '80897768', 'Jackline Mwende', '0756454321', 'jackym@gmail.com', '2025-10-03 14:57:24', '2025-10-03 14:57:24');
INSERT INTO `job_applicant` (`id`, `applicant_code`, `applicant_name`, `contact_phone`, `contact_email`, `created_at`, `updated_at`) VALUES ('3', '8980878778', 'Benson Chango Mang\'eni', '0123432134', 'benchango@gmail.com', '2025-10-03 15:01:02', '2025-10-09 00:40:27');
INSERT INTO `job_applicant` (`id`, `applicant_code`, `applicant_name`, `contact_phone`, `contact_email`, `created_at`, `updated_at`) VALUES ('4', '567689097', 'Brian Sabiri', '0734566778', 'brian@gmail.com', '2025-10-04 12:23:09', '2025-10-09 00:37:46');
INSERT INTO `job_applicant` (`id`, `applicant_code`, `applicant_name`, `contact_phone`, `contact_email`, `created_at`, `updated_at`) VALUES ('5', '68734368', 'Juliet Barasa', '0769653478', 'julietbarasa@gmail.com', '2025-10-08 08:33:38', '2025-10-08 08:33:38');

-- Structure for table `job_application`
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

-- Data for table `job_application`
INSERT INTO `job_application` (`id`, `applicant_code`, `job_posting_code`, `resume`, `cover_letter`, `application_status`, `comment`, `created_at`, `updated_at`) VALUES ('1', '45454644', '2025/ACD/001', 'upload/pdf/68dfb5fa6d47b_1759491578.pdf', 'upload/pdf/68dfb5fa717ef_1759491578.pdf', 'Pending', NULL, '2025-10-03 14:39:38', '2025-10-03 14:39:38');
INSERT INTO `job_application` (`id`, `applicant_code`, `job_posting_code`, `resume`, `cover_letter`, `application_status`, `comment`, `created_at`, `updated_at`) VALUES ('2', '80897768', '2025/ACD/001', 'upload/pdf/68dfba24e4f2a_1759492644.pdf', 'upload/pdf/68dfba24e60d9_1759492644.pdf', 'Pending', NULL, '2025-10-03 14:57:24', '2025-10-03 14:57:24');
INSERT INTO `job_application` (`id`, `applicant_code`, `job_posting_code`, `resume`, `cover_letter`, `application_status`, `comment`, `created_at`, `updated_at`) VALUES ('3', '8980878778', '2025/ACD/002', 'upload/pdf/68dfbafeaffe7_1759492862.pdf', 'upload/pdf/68dfbb0009c9e_1759492864.pdf', 'Pending', NULL, '2025-10-03 15:01:04', '2025-10-03 15:01:04');
INSERT INTO `job_application` (`id`, `applicant_code`, `job_posting_code`, `resume`, `cover_letter`, `application_status`, `comment`, `created_at`, `updated_at`) VALUES ('4', '567689097', '2025/ACD/TC/001', 'upload/pdf/68e0e77dcf6e0_1759569789.pdf', 'upload/pdf/68e0e77dd0b75_1759569789.pdf', 'Pending', NULL, '2025-10-04 12:23:09', '2025-10-04 12:23:09');

-- Structure for table `job_category`
CREATE TABLE `job_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `job_category`
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('1', 'Administration and Management', 'Leadership, administration, planning, governance', '2025-09-08 23:20:34', '2026-05-10 18:23:05');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('2', 'Academic', 'Teaching, curriculum delivery, learner assessment', '2025-09-11 22:20:12', '2026-05-10 18:23:41');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('3', 'Finance and Accounts', 'Budgeting, fee management, accounting', '2025-09-13 13:07:50', '2026-05-10 18:25:03');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('4', 'ICT & Systems Support', 'System administration, user support, infrastructure', '2026-05-10 18:27:22', '2026-05-10 18:27:22');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('5', 'Library Services', 'Library operations and learner support', '2026-05-10 18:28:08', '2026-05-10 18:28:08');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('6', 'Student Welfare', 'Guidance, counselling, welfare services', '2026-05-10 18:30:18', '2026-05-10 18:30:18');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('7', 'Security & Safety', 'School security, access control, safety enforcement', '2026-05-10 18:31:24', '2026-05-10 18:31:24');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('8', 'Catering & Kitchen', 'Food preparation and kitchen operations', '2026-05-10 18:32:15', '2026-05-10 18:32:15');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('9', 'Maintenance & Utilities', 'Repairs, grounds, electricity, water systems', '2026-05-10 18:32:48', '2026-05-10 18:32:48');
INSERT INTO `job_category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('10', 'Transport Services', 'Driver and transport coordination', '2026-05-10 18:33:23', '2026-05-10 18:33:23');

-- Structure for table `job_group`
CREATE TABLE `job_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `min_salary` decimal(10,2) NOT NULL,
  `max_salary` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `job_group`
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('1', 'C', 'Clerical / Junior Administrative Staff', '25000.00', '45000.00', '2025-09-08 23:22:59', '2026-05-10 18:44:33');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('2', 'A', 'Support Staff Grade I (cleaners, grounds staff, messengers)', '15000.00', '25000.00', '2025-09-11 22:20:55', '2026-05-10 18:43:08');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('3', 'B', 'Support Staff Grade II (drivers, cooks, guards, maintenance assistants)', '20000.00', '35000.00', '2025-09-11 22:21:40', '2026-05-10 18:43:29');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('4', 'D', 'Technical Support Staff (ICT assistants, lab assistants, library assistants)', '30000.00', '55000.00', '2026-05-10 18:45:05', '2026-05-10 18:45:18');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('5', 'E', 'Entry-Level Teaching Staff / Junior Officers', '35000.00', '65000.00', '2026-05-10 18:47:07', '2026-05-10 18:47:07');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('6', 'F', 'Experienced Teachers / Senior Technical Officers', '45000.00', '80000.00', '2026-05-10 18:47:43', '2026-05-10 18:47:43');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('7', 'G', 'Heads of Section / Senior Teachers / Accountants', '60000.00', '100000.00', '2026-05-10 18:48:28', '2026-05-10 18:48:28');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('8', 'H', 'Heads of Department (HODs), Senior Administrators', '75000.00', '130000.00', '2026-05-10 18:49:59', '2026-05-10 18:49:59');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('9', 'I', 'Deputy Principal / Deputy Headteacher / Senior Management', '95000.00', '160000.00', '2026-05-10 18:50:47', '2026-05-10 18:50:47');
INSERT INTO `job_group` (`id`, `name`, `description`, `min_salary`, `max_salary`, `created_at`, `updated_at`) VALUES ('10', 'J', 'Principal / Chief Administrator / Institutional Head', '120000.00', '220000.00', '2026-05-10 18:51:41', '2026-05-10 18:51:41');

-- Structure for table `job_level`
CREATE TABLE `job_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `job_level`
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('1', 'Entry Level', 'Fresh graduates, newly recruited staff, interns', '2025-09-08 23:26:46', '2026-05-10 18:58:35');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('2', 'Graduate Trainee', 'Probationary graduates undergoing orientation', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('3', 'Assistant Level', 'Junior assistants supporting senior staff', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('4', 'Junior Officer', 'Early-career staff with limited independent responsibility', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('5', 'Officer Level I', 'Staff handling standard operational duties', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('6', 'Officer Level II', 'Staff with practical experience and routine independent tasks', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('7', 'Officer Level III', 'Experienced officers with wider institutional responsibility', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('8', 'Senior Officer I', 'Senior professionals with departmental responsibility', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('9', 'Senior Officer II', 'Advanced professional staff with strategic input', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('10', 'Principal Officer', 'Highly experienced professionals leading specialized functions', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('11', 'Assistant Supervisor', 'First-line supervision of junior staff', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('12', 'Supervisor', 'Responsible for coordinating a small team', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('13', 'Senior Supervisor', 'Oversees multiple units or larger operational teams', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('14', 'Assistant Head of Section', 'Supports section leadership', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('15', 'Head of Section', 'Leads a defined functional unit', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('16', 'Assistant Head of Department', 'Supports departmental planning and supervision', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('17', 'Head of Department (HOD)', 'Leads a full academic or administrative department', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('18', 'Senior Head of Department', 'Oversees multiple departments or large departments', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('19', 'Deputy Registrar', 'Supports registrar or administrative head', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('20', 'Registrar', 'Heads academic records, admissions, or examinations administration', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('21', 'Senior Registrar', 'Oversees institutional administration functions', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('22', 'Deputy Principal', 'Second-in-command of the institution', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('23', 'Principal', 'Head of institution', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('24', 'Senior Principal', 'Leads large institutions or multi-campus schools', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('25', 'Chief Principal', 'Highest institutional leadership for major institutions', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('26', 'Technical Assistant', 'Junior technical support staff (labs, ICT, workshops)', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('27', 'Technical Officer', 'Skilled technical staff with operational independence', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('28', 'Senior Technical Officer', 'Leads technical operations and technical staff', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('29', 'Administrative Assistant', 'Junior office and clerical support', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('30', 'Administrative Officer', 'Handles office operations and institutional coordination', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('31', 'Senior Administrative Officer', 'Oversees major administrative functions', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('32', 'Support Staff Level I', 'Basic operational support staff', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('33', 'Support Staff Level II', 'Experienced support staff', '2026-05-10 18:58:23', '2026-05-10 18:58:23');
INSERT INTO `job_level` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('34', 'Support Staff Level III', 'Senior support staff supervising support teams', '2026-05-10 18:58:23', '2026-05-10 18:58:23');

-- Structure for table `job_posting`
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

-- Data for table `job_posting`
INSERT INTO `job_posting` (`id`, `school`, `department`, `job_posting_code`, `job_title`, `vacant_posts`, `posting_date`, `closing_date`, `description`, `employment_type`, `location`, `salary_range`, `status`, `created_at`, `updated_at`) VALUES ('2', '12345678', 'c9bpa', '2025/KIT/001', '3', '2', '2025-10-03', '2025-10-31', 'To take matron duties', 'Full-time', 'Busia', '20,000 - 35,000', 'New', '2025-10-03 10:16:27', '2025-10-03 10:57:36');
INSERT INTO `job_posting` (`id`, `school`, `department`, `job_posting_code`, `job_title`, `vacant_posts`, `posting_date`, `closing_date`, `description`, `employment_type`, `location`, `salary_range`, `status`, `created_at`, `updated_at`) VALUES ('4', '12345678', 'fwZCp', '2025/ACD/001', '4', '4', '2025-10-03', '2025-10-31', 'Teach computer studies in form and 2', 'Contract', 'Withing Bungoma', '20,000 - 25,000', 'New', '2025-10-03 11:03:10', '2025-10-03 11:03:10');
INSERT INTO `job_posting` (`id`, `school`, `department`, `job_posting_code`, `job_title`, `vacant_posts`, `posting_date`, `closing_date`, `description`, `employment_type`, `location`, `salary_range`, `status`, `created_at`, `updated_at`) VALUES ('5', '12345678', 'fwZCp', '2025/ACD/002', '5', '6', '2025-10-03', '2025-10-31', 'Assist subject teachers in revisions', 'Part-time', 'Within Busia County', '12,000 - 15,000', 'New', '2025-10-03 11:05:18', '2025-10-03 11:05:18');
INSERT INTO `job_posting` (`id`, `school`, `department`, `job_posting_code`, `job_title`, `vacant_posts`, `posting_date`, `closing_date`, `description`, `employment_type`, `location`, `salary_range`, `status`, `created_at`, `updated_at`) VALUES ('6', '36626205', 'yZ46V', '2025/ACD/TC/001', '6', '3', '2025-10-04', '2025-10-20', 'Teach all classes', 'Full-time', 'Within Sirisia Sub-County', '10000-15000', 'New', '2025-10-04 12:19:38', '2025-10-08 07:58:44');

-- Structure for table `job_skill`
CREATE TABLE `job_skill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `job_title_id` int NOT NULL,
  `skill_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_job_skill_school` (`school`),
  KEY `skill_id` (`skill_id`),
  KEY `job_title_id` (`job_title_id`),
  CONSTRAINT `fk_job_skill_school` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_skill_ibfk_1` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_skill_ibfk_2` FOREIGN KEY (`job_title_id`) REFERENCES `job_title` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `job_skill`
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('2', '12345678', '3', '1', '2025-09-22 07:23:41', '2025-09-22 07:23:41');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('3', '43544646', '7', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('4', '43544646', '7', '22', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('5', '43544646', '7', '23', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('6', '43544646', '7', '24', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('7', '43544646', '7', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('8', '43544646', '7', '32', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('9', '43544646', '8', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('10', '43544646', '8', '22', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('11', '43544646', '8', '23', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('12', '43544646', '8', '24', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('13', '43544646', '8', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('14', '43544646', '9', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('15', '43544646', '9', '30', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('16', '43544646', '9', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('17', '43544646', '9', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('18', '43544646', '10', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('19', '43544646', '10', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('20', '43544646', '10', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('21', '43544646', '11', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('22', '43544646', '11', '30', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('23', '43544646', '11', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('24', '43544646', '12', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('25', '43544646', '12', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('26', '43544646', '13', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('27', '43544646', '13', '32', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('28', '43544646', '13', '24', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('29', '43544646', '13', '8', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('30', '43544646', '14', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('31', '43544646', '14', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('32', '43544646', '14', '8', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('33', '43544646', '15', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('34', '43544646', '15', '7', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('35', '43544646', '16', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('36', '43544646', '16', '8', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('37', '43544646', '16', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('38', '43544646', '17', '1', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('39', '43544646', '17', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('40', '43544646', '18', '34', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('41', '43544646', '18', '32', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('42', '43544646', '18', '33', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('43', '43544646', '18', '35', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('44', '43544646', '19', '35', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('45', '43544646', '19', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('46', '43544646', '20', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('47', '43544646', '20', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('48', '43544646', '20', '30', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('49', '43544646', '21', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('50', '43544646', '21', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('51', '43544646', '21', '6', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('52', '43544646', '22', '28', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('53', '43544646', '22', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('54', '43544646', '22', '30', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('55', '43544646', '22', '23', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('56', '43544646', '23', '28', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('57', '43544646', '23', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('58', '43544646', '23', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('59', '43544646', '24', '28', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('60', '43544646', '24', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('61', '43544646', '24', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('62', '43544646', '25', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('63', '43544646', '25', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('64', '43544646', '25', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('65', '43544646', '26', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('66', '43544646', '26', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('67', '43544646', '26', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('68', '43544646', '27', '28', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('69', '43544646', '27', '29', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('70', '43544646', '27', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('71', '43544646', '28', '5', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('72', '43544646', '28', '10', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('73', '43544646', '28', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('74', '43544646', '29', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('75', '43544646', '29', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('76', '43544646', '30', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('77', '43544646', '30', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('78', '43544646', '31', '5', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('79', '43544646', '31', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('80', '43544646', '32', '5', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('81', '43544646', '32', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('82', '43544646', '33', '5', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('83', '43544646', '33', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('84', '43544646', '34', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('85', '43544646', '34', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('86', '43544646', '35', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('87', '43544646', '35', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('88', '43544646', '36', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('89', '43544646', '36', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('90', '43544646', '37', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('91', '43544646', '37', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('92', '43544646', '38', '20', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('93', '43544646', '38', '12', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('94', '43544646', '39', '4', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('95', '43544646', '39', '17', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('96', '43544646', '40', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('97', '43544646', '40', '41', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('98', '43544646', '41', '13', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('99', '43544646', '41', '3', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('100', '43544646', '42', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('101', '43544646', '42', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('102', '43544646', '43', '3', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('103', '43544646', '43', '8', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('104', '43544646', '44', '3', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('105', '43544646', '44', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('106', '43544646', '45', '3', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('107', '43544646', '45', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('108', '43544646', '46', '4', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('109', '43544646', '46', '5', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('110', '43544646', '46', '37', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('111', '43544646', '47', '4', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('112', '43544646', '47', '37', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('113', '43544646', '48', '32', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('114', '43544646', '48', '33', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('115', '43544646', '48', '11', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('116', '43544646', '49', '33', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('117', '43544646', '49', '12', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('118', '43544646', '50', '1', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('119', '43544646', '50', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('120', '43544646', '51', '7', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('121', '43544646', '51', '33', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('122', '43544646', '52', '32', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('123', '43544646', '52', '33', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('124', '43544646', '53', '16', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('125', '43544646', '53', '36', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('126', '43544646', '53', '39', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('127', '43544646', '53', '38', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('128', '43544646', '54', '37', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('129', '43544646', '54', '36', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('130', '43544646', '55', '37', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('131', '43544646', '55', '4', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('132', '43544646', '56', '1', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('133', '43544646', '56', '4', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('134', '43544646', '57', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('135', '43544646', '57', '15', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('136', '43544646', '58', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('137', '43544646', '59', '27', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('138', '43544646', '59', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('139', '43544646', '60', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('140', '43544646', '60', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('141', '43544646', '60', '24', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('142', '43544646', '61', '40', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('143', '43544646', '61', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('144', '43544646', '62', '42', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('145', '43544646', '62', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('146', '43544646', '63', '19', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('147', '43544646', '63', '41', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('148', '43544646', '64', '31', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('149', '43544646', '64', '41', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('150', '43544646', '65', '3', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('151', '43544646', '65', '9', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('152', '43544646', '66', '43', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('153', '43544646', '66', '44', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('154', '43544646', '66', '26', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('155', '43544646', '67', '43', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('156', '43544646', '67', '44', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('157', '43544646', '68', '44', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('158', '43544646', '69', '44', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('159', '43544646', '70', '44', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('160', '43544646', '70', '43', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('161', '43544646', '71', '47', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('162', '43544646', '71', '45', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('163', '43544646', '72', '46', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('164', '43544646', '73', '45', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('165', '43544646', '74', '45', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('166', '43544646', '75', '45', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('167', '43544646', '76', '35', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('168', '43544646', '77', '52', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('169', '43544646', '77', '6', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('170', '43544646', '78', '48', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('171', '43544646', '79', '49', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('172', '43544646', '80', '52', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('173', '43544646', '81', '2', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('174', '43544646', '82', '52', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('175', '43544646', '83', '52', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('176', '43544646', '84', '52', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('177', '43544646', '85', '51', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('178', '43544646', '85', '50', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('179', '43544646', '86', '50', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('180', '43544646', '87', '50', '2026-05-10 19:49:51', '2026-05-10 19:49:51');
INSERT INTO `job_skill` (`id`, `school`, `job_title_id`, `skill_id`, `created_at`, `updated_at`) VALUES ('181', '43544646', '88', '50', '2026-05-10 19:49:51', '2026-05-10 19:49:51');

-- Structure for table `job_title`
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
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `job_title`
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('3', '12345678', 'School Matron', '2', '1', '2', 'c9bpa', 'School Matron', '1', '2025-09-22 07:16:28', '2025-10-03 11:14:43');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('4', '12345678', 'Computer Studies and Mathematics Teacher', '2', '1', '3', 'fwZCp', 'Teaching a combination of Computer studies and Mathematics', '1', '2025-10-03 10:49:53', '2025-10-03 10:49:53');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('5', '12345678', 'Kiswahili Fasihi Teacher', '2', '1', '3', 'fwZCp', 'Kufundisha somo la kiswahili na fasihi katika madarasa yote atakayopewa na mwelekezi wa masomo', '1', '2025-10-03 10:52:01', '2025-10-03 10:52:01');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('6', '36626205', 'English Literature', '2', '1', '3', 'yZ46V', 'Teaching English and Literature in all classes', '1', '2025-10-04 11:39:19', '2025-10-04 11:39:19');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('7', '43544646', 'Principal', '1', '23', '10', 'ADM01', 'Head of institution responsible for strategic leadership and governance.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('8', '43544646', 'Deputy Principal', '1', '22', '9', 'ADM01', 'Supports the principal in academic and administrative leadership.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('9', '43544646', 'Senior Master', '1', '17', '8', 'ADM01', 'Coordinates discipline, timetabling and academic supervision.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('10', '43544646', 'Senior Mistress', '1', '17', '8', 'ADM01', 'Coordinates student welfare and institutional routines.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('11', '43544646', 'Registrar', '1', '20', '8', 'ADM01', 'Responsible for admissions, student records and examination documentation.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('12', '43544646', 'Deputy Registrar', '1', '19', '7', 'ADM01', 'Supports records management and institutional documentation.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('13', '43544646', 'Administrative Officer', '1', '30', '7', 'ADM01', 'Coordinates day-to-day administrative operations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('14', '43544646', 'Administrative Assistant', '1', '29', '4', 'ADM01', 'Provides office support, filing and correspondence.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('15', '43544646', 'Receptionist', '1', '3', '1', 'ADM01', 'Handles front office reception and visitors.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('16', '43544646', 'Secretary', '1', '29', '4', 'ADM01', 'Manages office communication and scheduling.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('17', '43544646', 'Office Clerk', '1', '4', '1', 'ADM01', 'Handles clerical duties and records.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('18', '43544646', 'Procurement Officer', '1', '8', '7', 'ADM01', 'Coordinates purchasing and supplier relations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('19', '43544646', 'Stores Officer', '1', '5', '5', 'ADM01', 'Responsible for stores inventory and stock records.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('20', '43544646', 'Examinations Officer', '1', '8', '7', 'ADM01', 'Coordinates internal and external examinations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('21', '43544646', 'Admissions Officer', '1', '6', '6', 'ADM01', 'Handles learner admissions and transfer records.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('22', '43544646', 'Director of Studies', '2', '18', '8', 'TUI01', 'Leads curriculum implementation and academic monitoring.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('23', '43544646', 'Head of Department - Sciences', '2', '17', '8', 'TUI01', 'Leads science department planning and supervision.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('24', '43544646', 'Head of Department - Mathematics', '2', '17', '8', 'TUI01', 'Leads mathematics department.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('25', '43544646', 'Head of Department - Languages', '2', '17', '8', 'TUI01', 'Leads languages department.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('26', '43544646', 'Head of Department - Humanities', '2', '17', '8', 'TUI01', 'Leads humanities department.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('27', '43544646', 'Head of Department - Technicals', '2', '17', '8', 'TUI01', 'Leads technical subjects department.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('28', '43544646', 'Teacher - Mathematics', '2', '5', '5', 'TUI01', 'Teaches Mathematics.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('29', '43544646', 'Teacher - English', '2', '5', '5', 'TUI01', 'Teaches English.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('30', '43544646', 'Teacher - Kiswahili', '2', '5', '5', 'TUI01', 'Teaches Kiswahili.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('31', '43544646', 'Teacher - Biology', '2', '6', '6', 'TUI01', 'Teaches Biology.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('32', '43544646', 'Teacher - Chemistry', '2', '6', '6', 'TUI01', 'Teaches Chemistry.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('33', '43544646', 'Teacher - Physics', '2', '6', '6', 'TUI01', 'Teaches Physics.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('34', '43544646', 'Teacher - Agriculture', '2', '5', '5', 'TUI01', 'Teaches Agriculture.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('35', '43544646', 'Teacher - Geography', '2', '5', '5', 'TUI01', 'Teaches Geography.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('36', '43544646', 'Teacher - History', '2', '5', '5', 'TUI01', 'Teaches History and Government.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('37', '43544646', 'Teacher - CRE', '2', '5', '5', 'TUI01', 'Teaches Christian Religious Education.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('38', '43544646', 'Teacher - Business Studies', '2', '5', '5', 'TUI01', 'Teaches Business Studies.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('39', '43544646', 'Teacher - Computer Studies', '2', '6', '6', 'TUI01', 'Teaches Computer Studies.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('40', '43544646', 'Teacher - Home Science', '2', '5', '5', 'TUI01', 'Teaches Home Science.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('41', '43544646', 'Teacher - Art and Design', '2', '5', '5', 'TUI01', 'Teaches Art and Design.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('42', '43544646', 'Teacher - Music', '2', '5', '5', 'TUI01', 'Teaches Music.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('43', '43544646', 'Teacher - Physical Education', '2', '5', '5', 'TUI01', 'Teaches Physical Education.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('44', '43544646', 'Games Teacher', '2', '6', '6', 'TUI01', 'Coordinates sports and games activities.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('45', '43544646', 'Class Teacher', '2', '5', '5', 'TUI01', 'Responsible for class academic and welfare coordination.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('46', '43544646', 'Laboratory Technician', '2', '27', '6', 'TUI01', 'Supports science practical lessons.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('47', '43544646', 'Laboratory Assistant', '2', '26', '4', 'TUI01', 'Assists laboratory operations and equipment handling.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('48', '43544646', 'Bursar', '3', '10', '8', 'FIN01', 'Heads finance operations and budgeting.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('49', '43544646', 'Accountant', '3', '8', '7', 'FIN01', 'Responsible for accounting and financial reporting.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('50', '43544646', 'Accounts Clerk', '3', '4', '1', 'FIN01', 'Handles receipting, filing and finance support.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('51', '43544646', 'Cashier', '3', '5', '5', 'FIN01', 'Receives payments and issues receipts.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('52', '43544646', 'Payroll Officer', '3', '8', '7', 'FIN01', 'Handles payroll preparation and salary processing.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('53', '43544646', 'ICT Manager', '4', '28', '7', 'ICT01', 'Leads school ICT systems and infrastructure.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('54', '43544646', 'ICT Officer', '4', '27', '6', 'ICT01', 'Maintains systems, network and user support.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('55', '43544646', 'ICT Assistant', '4', '26', '4', 'ICT01', 'Provides first-line technical support.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('56', '43544646', 'Data Clerk', '4', '4', '1', 'ICT01', 'Handles digital data entry and records.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('57', '43544646', 'Librarian', '5', '8', '7', 'LIB01', 'Manages library resources and learner access.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('58', '43544646', 'Assistant Librarian', '5', '6', '6', 'LIB01', 'Supports library operations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('59', '43544646', 'Library Assistant', '5', '3', '4', 'LIB01', 'Handles shelving, circulation and records.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('60', '43544646', 'Dean of Students', '6', '17', '8', 'WEL01', 'Coordinates learner discipline and welfare.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('61', '43544646', 'Guidance and Counselling Officer', '6', '8', '7', 'WEL01', 'Provides counselling and psychosocial support.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('62', '43544646', 'School Chaplain', '6', '8', '7', 'WEL01', 'Provides spiritual guidance and mentorship.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('63', '43544646', 'School Nurse', '6', '8', '7', 'WEL01', 'Provides first aid and learner health support.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('64', '43544646', 'Matron', '6', '12', '4', 'WEL01', 'Supervises boarding welfare and dormitory order.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('65', '43544646', 'Patron', '6', '11', '4', 'WEL01', 'Supervises learner clubs and co-curricular activities.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('66', '43544646', 'Chief Security Officer', '7', '13', '3', 'SEC01', 'Leads school security operations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('67', '43544646', 'Security Supervisor', '7', '12', '3', 'SEC01', 'Supervises guards and access control.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('68', '43544646', 'Security Guard', '7', '32', '2', 'SEC01', 'Provides security and safety monitoring.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('69', '43544646', 'Night Guard', '7', '32', '2', 'SEC01', 'Provides overnight security coverage.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('70', '43544646', 'Gate Keeper', '7', '32', '2', 'SEC01', 'Controls entry and exit points.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('71', '43544646', 'Catering Manager', '8', '13', '4', 'KIT01', 'Oversees catering and food service operations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('72', '43544646', 'Head Cook', '8', '12', '3', 'KIT01', 'Supervises kitchen preparation and hygiene.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('73', '43544646', 'Cook', '8', '32', '3', 'KIT01', 'Prepares meals for learners and staff.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('74', '43544646', 'Assistant Cook', '8', '32', '2', 'KIT01', 'Supports food preparation and serving.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('75', '43544646', 'Kitchen Steward', '8', '32', '2', 'KIT01', 'Responsible for kitchen cleanliness and utensils.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('76', '43544646', 'Storekeeper - Kitchen', '8', '5', '5', 'KIT01', 'Manages kitchen stores and food inventory.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('77', '43544646', 'Maintenance Officer', '9', '27', '6', 'MNT01', 'Coordinates facilities repair and maintenance.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('78', '43544646', 'Electrician', '9', '27', '6', 'MNT01', 'Handles electrical installations and repairs.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('79', '43544646', 'Plumber', '9', '27', '6', 'MNT01', 'Maintains plumbing and water systems.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('80', '43544646', 'Carpenter', '9', '27', '6', 'MNT01', 'Repairs furniture and woodwork.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('81', '43544646', 'Painter', '9', '26', '4', 'MNT01', 'Handles painting and finishing works.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('82', '43544646', 'Groundsman', '9', '32', '2', 'MNT01', 'Maintains lawns and compound cleanliness.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('83', '43544646', 'Cleaner', '9', '32', '2', 'MNT01', 'Cleans classrooms, offices and facilities.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('84', '43544646', 'Janitor', '9', '32', '2', 'MNT01', 'Supports general maintenance and sanitation.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('85', '43544646', 'Transport Officer', '10', '12', '4', 'TRN01', 'Coordinates transport schedules and fleet operations.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('86', '43544646', 'Driver', '10', '32', '3', 'TRN01', 'Operates school vehicles safely.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('87', '43544646', 'Bus Driver', '10', '32', '3', 'TRN01', 'Drives school bus for learner transport.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');
INSERT INTO `job_title` (`id`, `school`, `title`, `category_id`, `level_id`, `group_id`, `department`, `description`, `status`, `created_at`, `updated_at`) VALUES ('88', '43544646', 'Mechanic', '10', '27', '6', 'TRN01', 'Maintains school vehicles.', '1', '2026-05-10 19:18:58', '2026-05-10 19:18:58');

-- Structure for table `journal_entry`
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

-- Structure for table `journal_line`
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

-- Structure for table `leave_balance`
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

-- Structure for table `leave_request`
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

-- Data for table `leave_request`
INSERT INTO `leave_request` (`id`, `school`, `leave_code`, `staff_code`, `leave_type`, `start_date`, `end_date`, `approval_status`, `comment`, `reason`, `approved_by`, `rejected_by`, `created_at`, `updated_at`) VALUES ('1', '36626205', 'fIUvj', '9dfSg', 'jzGVT', '2025-11-01', '2025-11-30', 'New', NULL, NULL, NULL, NULL, '2025-10-19 07:46:49', '2025-10-19 07:46:49');

-- Structure for table `leave_type`
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `leave_type`
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('1', '12345678', 'GpmoA', 'Maternity', 'Female', '90', '3', '2025-09-27 06:46:19', '2025-09-27 06:51:11');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('2', '12345678', 'Z1PNT', 'Paternity', 'Male', '10', '3', '2025-09-27 06:48:31', '2025-09-27 06:51:24');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('3', '12345678', 'HrViv', 'Annual', 'Both', '30', '5', '2025-09-27 06:49:15', '2025-09-27 06:51:28');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('4', '12345678', '83kI7', 'Sick', 'Both', '14', '10', '2025-09-27 06:50:29', '2025-09-27 06:50:29');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('5', '36626205', '2zNDh', 'Maternity', 'Female', '90', '5', '2025-10-05 20:24:15', '2025-10-05 20:26:07');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('6', '36626205', 'H6MPt', 'Paternity', 'Male', '10', '5', '2025-10-05 20:24:47', '2025-10-05 20:26:10');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('7', '36626205', 'jzGVT', 'Annual Leave', 'Both', '30', '5', '2025-10-05 20:25:18', '2025-10-05 20:26:00');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('8', '36626205', 'zElD0', 'Sick', 'Both', '15', '4', '2025-10-05 20:25:42', '2025-10-05 20:26:15');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('9', '36626123', '5CQYM', 'Maternity', 'Female', '90', '1', '2025-10-12 08:15:29', '2025-10-12 08:15:29');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('10', '36626123', 'eUN7u', 'Paternity', 'Male', '10', '1', '2025-10-12 08:15:52', '2025-10-12 08:15:52');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('11', '43544646', 'Um1ut', 'Maternity', 'Female', '90', '1', '2026-05-11 00:26:05', '2026-05-11 00:26:05');
INSERT INTO `leave_type` (`id`, `school`, `leave_type_code`, `leave_type_name`, `applies_to`, `no_of_days_off`, `maximum_leaves`, `created_at`, `updated_at`) VALUES ('12', '43544646', 'bqCE7', 'Paternity', 'Male', '10', '1', '2026-05-11 00:26:26', '2026-05-11 00:26:26');

-- Structure for table `message`
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

-- Structure for table `mpesa_payments`
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

-- Structure for table `news`
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

-- Structure for table `no_series`
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `no_series`
INSERT INTO `no_series` (`id`, `school`, `ns_code`, `ns_name`, `description`, `startno`, `endno`, `lastused`, `canskip`, `category`) VALUES ('7', '43544646', 'uWKxD', 'STD', 'Student Admission Number Series', '00001', '99999', '00000', '0', 'Student');
INSERT INTO `no_series` (`id`, `school`, `ns_code`, `ns_name`, `description`, `startno`, `endno`, `lastused`, `canskip`, `category`) VALUES ('8', '43544646', 'nYzLP', 'RCT', 'Payment Receipts', '00001', '99999', '00000', '0', 'receipt');
INSERT INTO `no_series` (`id`, `school`, `ns_code`, `ns_name`, `description`, `startno`, `endno`, `lastused`, `canskip`, `category`) VALUES ('9', '43544646', '90gpq', 'INV', 'Invoice Number Series', '00001', '99999', '00000', '0', 'invoice');

-- Structure for table `pathway`
CREATE TABLE `pathway` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pathway` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pathway` (`pathway`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `pathway`
INSERT INTO `pathway` (`id`, `pathway`) VALUES ('2', 'Arts');
INSERT INTO `pathway` (`id`, `pathway`) VALUES ('3', 'Commerce');
INSERT INTO `pathway` (`id`, `pathway`) VALUES ('1', 'Science');
INSERT INTO `pathway` (`id`, `pathway`) VALUES ('4', 'Technical');

-- Structure for table `payment`
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

-- Structure for table `payroll`
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

-- Structure for table `purchase_order`
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

-- Structure for table `purchase_order_item`
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

-- Structure for table `purchase_requisition`
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

-- Structure for table `purchase_requisition_item`
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

-- Structure for table `receipt`
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

-- Structure for table `region`
CREATE TABLE `region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `region`
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('1', 'CEN', 'Central', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('2', 'COS', 'Coast', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('3', 'EAS', 'Eastern', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('4', 'NRB', 'Nairobi', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('5', 'NE', 'North Eastern', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('6', 'NYA', 'Nyanza', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('7', 'RV', 'Rift Valley', '2026-04-05 13:54:40', '2026-04-05 13:54:40');
INSERT INTO `region` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES ('8', 'WES', 'Western', '2026-04-05 13:54:40', '2026-04-05 13:54:40');

-- Structure for table `role`
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `permissions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Structure for table `salary`
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

-- Structure for table `school`
CREATE TABLE `school` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `school_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `kra_pin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reg_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `curriculum` enum('CBC','IGCSE','844') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `level` enum('Primary','Secondary','Mixed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` enum('public','private','international') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `school`
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('8', '12345678', 'PCC Comprehensive School', 'National', NULL, NULL, NULL, NULL, NULL, 'P.O Box 77, Sirisia', 'pccws.limited@gmail.com', '0741915943', 'upload/jpeg/69d2d0b8cf046_1775423672.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-09-19 22:46:43', '2026-04-06 00:14:32');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('9', '36626126', 'Sibanga S.A Comprehensive School', 'National', NULL, NULL, NULL, NULL, NULL, NULL, 'sasibangacs@go.ke', '0700212354', 'upload/jpeg/68e0c9c2849db_1759562178.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-10-04 20:16:18', '2025-10-04 20:16:18');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('10', '36626205', 'AC. Bungonge High School', 'Extra-County', NULL, NULL, NULL, NULL, NULL, NULL, 'acbutongehs@go.ke', '0788665544', 'upload/jpeg/68e0d92e08b41_1759566126.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-10-04 21:22:06', '2025-10-04 21:22:06');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('11', '36626123', 'Namwela Friends Boys High School', 'Extra-County', NULL, NULL, NULL, NULL, NULL, NULL, 'namwelafbhs@gmail.com', '0723456789', 'upload/jpeg/68e257cca7e30_1759664076.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2025-10-06 00:34:37', '2025-10-09 12:28:10');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('13', '32564215', 'St. Ann\'s Comprehensive School', 'Extra-County', NULL, NULL, NULL, NULL, NULL, NULL, 'stannscs@gmail.com', '0752142635', 'upload/jpeg/696b614ad9442_1768644938.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2026-01-17 13:15:39', '2026-01-17 13:15:39');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('14', '43544646', 'Friends Senior School Kimugui Girls', 'County', NULL, NULL, NULL, NULL, NULL, 'P.o Box 1851, Bungoma', 'gkimugui@gmail.com', '0745635243', 'upload/png/kimugui_logo.png', 'Strive to Excel', NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2026-05-03 11:00:59', '2026-05-11 07:18:37');
INSERT INTO `school` (`id`, `school_code`, `school_name`, `category`, `kra_pin`, `reg_no`, `curriculum`, `level`, `type`, `address`, `mail`, `contact`, `logo`, `motto`, `mission`, `vision`, `core_values`, `days_per_week`, `periods_per_day`, `facebook`, `twitter`, `instagram`, `linkedin`, `skype`, `website`, `established_year`, `status`, `created_at`, `updated_at`) VALUES ('15', '36508767', 'Petra Education Centre', 'County', NULL, NULL, NULL, NULL, NULL, NULL, 'petra@gmail.com', '0720686453', 'upload/jpeg/6a012e0d5cf1e_1778462221.jpg', NULL, NULL, NULL, NULL, '5', '8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '2026-05-11 04:17:01', '2026-05-11 04:17:01');

-- Structure for table `school_class`
CREATE TABLE `school_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_offered` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `class` (`class`),
  CONSTRAINT `school_class_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `school_class_ibfk_2` FOREIGN KEY (`class`) REFERENCES `class` (`class_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `school_class`
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('1', '12345678', 'PP1', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('2', '12345678', 'PP2', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('3', '12345678', 'G1', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('4', '12345678', 'G2', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('5', '12345678', 'G3', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('6', '12345678', 'G4', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('7', '12345678', 'G5', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('8', '12345678', 'G6', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('9', '12345678', 'G7', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('10', '12345678', 'G8', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('11', '12345678', 'G9', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('12', '12345678', 'G10', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('13', '12345678', 'G11', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('14', '12345678', 'G12', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('18', '43544646', 'G12', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('19', '43544646', 'G11', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('20', '43544646', 'G10', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('21', '36508767', 'G9', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('22', '36508767', 'G8', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('23', '36508767', 'G7', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('24', '36508767', 'G6', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('25', '36508767', 'G5', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('26', '36508767', 'G4', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('27', '36508767', 'G3', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('28', '36508767', 'G2', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('29', '36508767', 'G1', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('30', '36508767', 'PP2', '1');
INSERT INTO `school_class` (`id`, `school`, `class`, `is_offered`) VALUES ('31', '36508767', 'PP1', '1');

-- Structure for table `skill`
CREATE TABLE `skill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `skill`
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('1', 'Data entry', 'Able to use computer to key in data for analysis and help in other useful decisions', '2025-09-08 23:44:04', '2025-09-08 23:44:04');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('2', 'Communication Skills', 'Ability to clearly express ideas verbally and in writing', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('3', 'Teamwork', 'Ability to work effectively in groups', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('4', 'Computer Literacy', 'Basic computer and software usage skills', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('5', 'Data Analysis', 'Ability to interpret and analyze data', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('6', 'Problem Solving', 'Ability to identify and resolve issues', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('7', 'Customer Service', 'Handling clients professionally', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('8', 'Time Management', 'Managing tasks efficiently within deadlines', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('9', 'Leadership', 'Ability to guide and manage teams', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('10', 'Critical Thinking', 'Logical reasoning and decision making', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('11', 'Project Management', 'Planning and executing projects effectively', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('12', 'Accounting Basics', 'Understanding financial records and bookkeeping', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('13', 'Teaching Skills', 'Ability to educate and train learners', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('14', 'Networking', 'Building professional relationships', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('15', 'Research Skills', 'Ability to gather and analyze information', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('16', 'Software Development', 'Programming and system development skills', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('17', 'Database Management', 'Handling and designing databases', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('18', 'Networking IT', 'Computer network setup and maintenance', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('19', 'Healthcare Skills', 'Basic medical and patient care knowledge', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('20', 'Sales & Marketing', 'Promoting and selling products/services', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('21', 'Report Writing', 'Documenting structured professional reports', '2026-05-10 19:31:50', '2026-05-10 19:31:50');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('22', 'Strategic Planning', 'Ability to develop long-term institutional plans', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('23', 'Policy Implementation', 'Ability to enforce institutional policies', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('24', 'Decision Making', 'Ability to make informed administrative decisions', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('25', 'Conflict Resolution', 'Managing disputes effectively', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('26', 'Supervisory Skills', 'Ability to oversee staff and operations', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('27', 'Records Management', 'Proper handling of institutional records', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('28', 'Curriculum Development', 'Designing and improving learning programs', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('29', 'Academic Assessment', 'Evaluating learner performance effectively', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('30', 'Timetabling', 'Scheduling academic activities efficiently', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('31', 'Discipline Management', 'Managing student behavior and discipline', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('32', 'Budgeting', 'Planning and controlling financial resources', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('33', 'Financial Reporting', 'Preparing financial statements', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('34', 'Procurement Procedures', 'Understanding procurement laws and processes', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('35', 'Inventory Control', 'Managing stock and supplies', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('36', 'System Administration', 'Managing servers and IT infrastructure', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('37', 'Technical Support', 'Providing hardware/software troubleshooting', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('38', 'Cybersecurity Awareness', 'Basic protection of systems and data', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('39', 'Network Administration', 'Managing LAN/WAN systems', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('40', 'Counselling Skills', 'Providing emotional and psychological support', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('41', 'Child Protection', 'Safeguarding learners from harm', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('42', 'Pastoral Care', 'Supporting spiritual and emotional wellbeing', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('43', 'Access Control Management', 'Managing entry and exit security systems', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('44', 'Emergency Response', 'Handling security emergencies', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('45', 'Food Safety & Hygiene', 'Ensuring safe food preparation standards', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('46', 'Menu Planning', 'Planning balanced meals', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('47', 'Catering Management', 'Managing food service operations', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('48', 'Electrical Maintenance', 'Repairing electrical systems', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('49', 'Plumbing Maintenance', 'Water and drainage system repair', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('50', 'Vehicle Maintenance', 'Basic automotive servicing', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('51', 'Fleet Management', 'Managing institutional transport fleet', '2026-05-10 19:41:38', '2026-05-10 19:41:38');
INSERT INTO `skill` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES ('52', 'Facility Maintenance', 'Upkeep of buildings and infrastructure', '2026-05-10 19:41:38', '2026-05-10 19:41:38');

-- Structure for table `staff`
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `staff`
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('13', '12345678', 'RzElf', 'Nancy', 'Chemtai', 'Female', 'nancychem@gmail.com', '0751423652', '32352452', '3', 'Support', '2025-01-01', 'c9bpa', 'Retired', 'Permanent', 'upload/png/user-default-2-min.png', '2025-09-27 17:56:38', '2025-10-08 17:13:39');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('14', '12345678', 'xfhbN', 'Kelvin', 'Obwoyo', 'Male', 'kobwoyo@gmail.com', '0767856545', '32456578', '3', 'Support', '2025-05-07', 'c9bpa', 'Active', 'Permanent', 'upload/png/user-default-2-min.png', '2025-09-27 19:45:32', '2025-09-27 19:45:32');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('15', '36626205', '9dfSg', 'Silas', 'Wanambisi', 'Male', 'wsilas@gmail.com', '0124345365', '15643256', '6', 'Teacher', '2025-01-06', 'yZ46V', 'Active', 'Permanent', 'upload/png/user-default-2-min.png', '2025-10-04 21:41:17', '2025-10-24 06:36:18');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('16', '12345678', 'SI08R', 'Abigael', 'Bahati', 'Female', 'abigaelbahati@gmail.com', '0756342314', '12345678', '4', 'Teacher', '2025-02-08', 'fwZCp', 'On Leave', 'Permanent', 'upload/jpeg/2e4d26d7e8f5e1b62f2a17d549ffe6c5.jpg', '2025-10-06 20:22:21', '2025-10-08 17:11:49');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('17', '12345678', '96CN7', 'Kelvin', 'Opiyo', 'Male', 'kelvinopiyo@gmail.com', '0745635243', '34256545', '5', 'Teacher', '2025-10-01', 'fwZCp', 'Resigned', 'B.O.M', 'upload/png/user-default-2-min.png', '2025-10-06 20:38:01', '2025-10-08 17:14:14');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('18', '12345678', 'P7Czm', 'Edmond', 'Chiveli', 'Male', 'chevelie@yahoo.com', '0768987546', '27645635', '5', 'Teacher', '2025-10-01', 'fwZCp', 'Active', 'B.O.M', 'upload/jpeg/68e372ac688e7_1759736492.jpg', '2025-10-06 20:41:32', '2025-10-06 20:41:32');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('19', '43544646', '50prS', 'Paul', 'Khisa', 'Male', 'khisap@gmail.com', '0756345245', '67544347', '39', 'Teacher', '2024-01-01', 'TUI01', 'Active', 'B.O.M', 'upload/jpeg/6a00bdc905c7b_1778433481.jpg', '2026-05-10 20:18:01', '2026-05-10 20:18:01');
INSERT INTO `staff` (`id`, `school`, `staff_code`, `first_name`, `last_name`, `gender`, `email`, `phone`, `id_no`, `job_title`, `role`, `hire_date`, `department`, `status`, `emp_term`, `profile_picture`, `created_at`, `updated_at`) VALUES ('20', '43544646', 'V8Nzs', 'Stephen', 'Mang\'oli', 'Male', 'msteve@gmail.com', '0189676547', '32876789', '30', 'Teacher', '2024-01-01', 'TUI01', 'Active', 'B.O.M', 'upload/jpeg/6a00bee52c921_1778433765.jpg', '2026-05-10 20:22:45', '2026-05-10 20:22:45');

-- Structure for table `staff_attendance`
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

-- Structure for table `staff_benefit`
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

-- Data for table `staff_benefit`
INSERT INTO `staff_benefit` (`id`, `school`, `benefit_code`, `staff_code`, `benefit_type`, `description`, `effective_date`, `status`, `created_at`, `updated_at`) VALUES ('1', '12345678', 'bIv86', 'RzElf', 'qc8G0', 'For daily communication to the junior staffs', '2025-02-01', 'Pending', '2025-09-27 08:12:47', '2025-09-27 08:12:47');
INSERT INTO `staff_benefit` (`id`, `school`, `benefit_code`, `staff_code`, `benefit_type`, `description`, `effective_date`, `status`, `created_at`, `updated_at`) VALUES ('2', '12345678', 'uqYh1', 'RzElf', 'YsJFM', 'To facilitate monthly HMIS training', '2025-10-01', 'Pending', '2025-09-27 08:22:19', '2025-09-27 08:22:19');
INSERT INTO `staff_benefit` (`id`, `school`, `benefit_code`, `staff_code`, `benefit_type`, `description`, `effective_date`, `status`, `created_at`, `updated_at`) VALUES ('3', '12345678', 'v54VI', '96CN7', 'BuTir', 'To be entitled from this year', '2025-10-09', 'Pending', '2025-10-11 19:47:22', '2025-10-11 19:47:22');

-- Structure for table `staff_file`
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

-- Data for table `staff_file`
INSERT INTO `staff_file` (`id`, `school`, `file_id`, `staff`, `document_type`, `file_path`, `uploaded_at`, `updated_at`) VALUES ('6', '36626205', '65RvQ', '9dfSg', 'Testimonial', 'upload/pdf/68e25e4079536_1759665728.pdf', '2025-10-05 15:02:08', '2025-10-05 15:02:08');
INSERT INTO `staff_file` (`id`, `school`, `file_id`, `staff`, `document_type`, `file_path`, `uploaded_at`, `updated_at`) VALUES ('7', '36626205', 'xmULc', '9dfSg', 'Academic Qualifications', 'upload/pdf/68e2a87d5b275_1759684733.pdf', '2025-10-05 20:18:53', '2025-10-05 20:18:53');
INSERT INTO `staff_file` (`id`, `school`, `file_id`, `staff`, `document_type`, `file_path`, `uploaded_at`, `updated_at`) VALUES ('8', '12345678', 'fv0kR', 'SI08R', 'Academic Qualifications', 'upload/pdf/68e5f8cc478fa_1759901900.pdf', '2025-10-08 08:38:20', '2025-10-08 08:38:20');
INSERT INTO `staff_file` (`id`, `school`, `file_id`, `staff`, `document_type`, `file_path`, `uploaded_at`, `updated_at`) VALUES ('9', '12345678', 'gHGL8', 'SI08R', 'Cover Letter', 'upload/pdf/68e6d691eb9f7_1759958673.pdf', '2025-10-09 00:24:34', '2025-10-09 00:24:34');
INSERT INTO `staff_file` (`id`, `school`, `file_id`, `staff`, `document_type`, `file_path`, `uploaded_at`, `updated_at`) VALUES ('10', '36626205', 'lXbS0', '9dfSg', 'Cover Letter', 'upload/pdf/68ededa128c03_1760423329.pdf', '2025-10-14 09:28:49', '2025-10-14 09:28:49');

-- Structure for table `staff_performance_review`
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

-- Structure for table `staff_training`
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

-- Structure for table `staff_transfer_request`
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

-- Data for table `staff_transfer_request`
INSERT INTO `staff_transfer_request` (`id`, `transfer_code`, `transfer_from`, `transfer_to`, `date_requested`, `requested_by`, `on_behalf_of`, `effective_date`, `approval_status`, `approved_by`, `rejected_by`, `comment`, `reason`, `created_at`, `updated_at`) VALUES ('8', 'es0KU', '12345678', '12345678', '2025-09-02', 'hWbFL', 'RzElf', '2025-09-01', 'New', '', '', '', '', '2025-09-28 14:22:29', '2025-09-28 14:22:29');

-- Structure for table `std_disciplinary`
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

-- Structure for table `stock_item`
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

-- Structure for table `stock_item_transaction`
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

-- Structure for table `stream`
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `stream`
INSERT INTO `stream` (`id`, `school`, `class`, `stream_code`, `stream_name`, `description`, `capacity`, `class_teacher`, `created_at`, `updated_at`) VALUES ('36', '12345678', 'G10', 'tn0Km', 'East', 'The eagles', '40', '96CN7', '2026-03-29 09:32:29', '2026-03-29 09:32:29');
INSERT INTO `stream` (`id`, `school`, `class`, `stream_code`, `stream_name`, `description`, `capacity`, `class_teacher`, `created_at`, `updated_at`) VALUES ('39', '12345678', 'G10', 'v6lgy', 'West', 'The Champions', '40', 'SI08R', '2026-03-29 09:55:14', '2026-03-29 09:55:14');
INSERT INTO `stream` (`id`, `school`, `class`, `stream_code`, `stream_name`, `description`, `capacity`, `class_teacher`, `created_at`, `updated_at`) VALUES ('40', '12345678', 'G11', 'El2gP', 'East', 'The vultures', '40', 'P7Czm', '2026-03-29 09:58:04', '2026-03-29 09:58:27');
INSERT INTO `stream` (`id`, `school`, `class`, `stream_code`, `stream_name`, `description`, `capacity`, `class_teacher`, `created_at`, `updated_at`) VALUES ('41', '43544646', 'G10', 'JjrT0', 'East', '', '40', '50prS', '2026-05-10 20:26:24', '2026-05-10 20:26:24');
INSERT INTO `stream` (`id`, `school`, `class`, `stream_code`, `stream_name`, `description`, `capacity`, `class_teacher`, `created_at`, `updated_at`) VALUES ('42', '43544646', 'G10', 'qOzpa', 'West', '', '40', 'V8Nzs', '2026-05-10 20:26:55', '2026-05-10 20:26:55');

-- Structure for table `student`
CREATE TABLE `student` (
  `id` int NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `assessment_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nemis_upi` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `first_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `surname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('Male','Female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dob` date DEFAULT NULL,
  `doa` date DEFAULT NULL,
  `exit_date` date DEFAULT NULL,
  `birth_cert_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nationality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `religion` enum('Christian','Muslim','Hindu','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Other',
  `profile_picture` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'upload/png/user-default.png',
  `status` enum('Active','Inactive','Transferred','Dropped','Graduated') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adm_no` (`adm_no`),
  KEY `school` (`school`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `student`
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('10', '12345678', '11575', NULL, NULL, 'Abiud', 'Musee', 'Makwa', 'Male', '2002-02-06', '2016-01-12', NULL, NULL, NULL, 'Other', 'upload/png/69de4ed75c95a_1776176855.png', 'Active', '2026-03-30 07:57:11', '2026-04-14 17:27:36');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('11', '12345678', '2652', NULL, NULL, 'Phoebe', 'Adongo', 'Etyang', 'Female', '2002-06-21', '2026-03-05', NULL, NULL, NULL, 'Other', 'upload/jpeg/69d3dbf5078d7_1775492085.jpg', 'Active', '2026-03-30 08:47:13', '2026-04-06 19:14:45');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('12', '12345678', '2356', NULL, NULL, 'Gianna', 'Eva', 'Makwa', 'Female', '2006-02-05', '2021-01-15', NULL, NULL, NULL, 'Other', 'upload/png/69d3dbcf7766a_1775492047.png', 'Active', '2026-03-30 11:32:31', '2026-04-06 19:14:07');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('13', '43544646', '1719', NULL, NULL, 'Ann', 'Barasa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('14', '43544646', '1722', NULL, NULL, 'Angeline', 'Wawire', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('15', '43544646', '1726', NULL, NULL, 'Angela', 'Nasenya', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('16', '43544646', '1728', NULL, NULL, 'Tieli', 'Diana', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('17', '43544646', '1730', NULL, NULL, 'Charity', 'Nasimiyu', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014fd6abbf1_1778470870.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:41:10');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('18', '43544646', '1732', NULL, NULL, 'Agatha', 'Mitchel', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('19', '43544646', '1737', NULL, NULL, 'Lilian', 'Akinyi', 'Oduor', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('20', '43544646', '1739', NULL, NULL, 'Cherily', 'Maloba', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('21', '43544646', '1741', NULL, NULL, 'Caren', 'Wanjala', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('22', '43544646', '1750', NULL, NULL, 'Sharon', 'Nekesa', 'Barasa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('23', '43544646', '1754', NULL, NULL, 'Ashlyne', 'Faith', 'Awor', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014fa6cbf7f_1778470822.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:40:23');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('24', '43544646', '1760', NULL, NULL, 'Emmaculate', 'Juma', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('25', '43544646', '1761', NULL, NULL, 'Qulen', 'Nanjala', 'Kuloba', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('26', '43544646', '1763', NULL, NULL, 'Abigael', 'Nabwire', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01500651ad5_1778470918.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:41:58');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('27', '43544646', '1765', NULL, NULL, 'Nelima', 'Pricillah', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('28', '43544646', '1767', NULL, NULL, 'Norah', 'Nasambo', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('29', '43544646', '1772', NULL, NULL, 'Wakoli', 'Nafula', 'Beraka', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('30', '43544646', '1775', NULL, NULL, 'Veronica', 'Maracha', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01509895721_1778471064.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:44:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('31', '43544646', '1778', NULL, NULL, 'Cicas', 'Nafula', 'Juma', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0150a2d0a67_1778471074.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:44:35');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('32', '43544646', '1780', NULL, NULL, 'Jael', 'Chelangat', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0150bee85e9_1778471102.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:45:03');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('33', '43544646', '1782', NULL, NULL, 'Makokha', 'Shakillah', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('34', '43544646', '1784', NULL, NULL, 'Wafula', 'Ruth', 'Naliaka', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('35', '43544646', '1786', NULL, NULL, 'Kutola', 'Lucy', 'Misanya', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('36', '43544646', '1788', NULL, NULL, 'Valentay', 'Khisa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('37', '43544646', '1790', NULL, NULL, 'Everlyne', 'Bebela', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('38', '43544646', '1791', NULL, NULL, 'Laiza', 'Nafula', 'Khisa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('39', '43544646', '1793', NULL, NULL, 'Quinter', 'Scovia', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('40', '43544646', '1802', NULL, NULL, 'Wabwile', 'Nanyama', 'Teresa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('41', '43544646', '1807', NULL, NULL, 'Vivian', 'Ofwamba', 'Wangila', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('42', '43544646', '1811', NULL, NULL, 'Mukonambi', 'Annah', 'Nekesa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('43', '43544646', '1813', NULL, NULL, 'Fridah', 'Cherop', 'Masibo', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('44', '43544646', '1815', NULL, NULL, 'Eddah', 'Chelimo', 'Cheptia', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('45', '43544646', '1822', NULL, NULL, 'Wanyonyi', 'Nafuna', 'Nelvin', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('46', '43544646', '1824', NULL, NULL, 'Sandra', 'Nafula', 'Kitui', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0151352c1ff_1778471221.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:47:01');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('47', '43544646', '1832', NULL, NULL, 'Naomi', 'Makhanu', 'Mangoli', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('48', '43544646', '1834', NULL, NULL, 'Wabwile', 'Tanze', 'Patriciah', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('49', '43544646', '1837', NULL, NULL, 'Kundu', 'Nangekhe', 'Metrine', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('50', '43544646', '1839', NULL, NULL, 'Linet', 'Nangila', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('51', '43544646', '1847', NULL, NULL, 'Braxides', 'Nanjala', 'Wakoli', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('52', '43544646', '1850', NULL, NULL, 'Sharon', 'Nasina', 'Wafula', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('53', '43544646', '1851', NULL, NULL, 'Blessing', 'Nafula', 'Indasi', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0151b0061f5_1778471344.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:49:04');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('54', '43544646', '1857', NULL, NULL, 'Nyongesa', 'Mitchel', 'Nasimiyu', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('55', '43544646', '1859', NULL, NULL, 'Wakhungu', 'Nasimiyu', 'Patience', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0151da68eab_1778471386.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:49:46');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('56', '43544646', '1865', NULL, NULL, 'Purity', 'Navangala', 'Ukheri', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('57', '43544646', '1718', NULL, NULL, 'Faith', 'Kulecho', 'Osore', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('58', '43544646', '1721', NULL, NULL, 'Wanjala', 'Marion', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('59', '43544646', '1723', NULL, NULL, 'Trinity', 'Nelima', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014cc39d303_1778470083.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:28:03');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('60', '43544646', '1724', NULL, NULL, 'Sylvia', 'Nakhumicha', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('61', '43544646', '1725', NULL, NULL, 'Dobista', 'N', 'Wafula', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('62', '43544646', '1727', NULL, NULL, 'Pamela', 'Nafula', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014f14a0a64_1778470676.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:37:56');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('63', '43544646', '1729', NULL, NULL, 'Loice', 'Mukhwana', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('64', '43544646', '1731', NULL, NULL, 'Kongani', 'Beatrice', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('65', '43544646', '1733', NULL, NULL, 'Joy', 'Nekesa', 'Wekesa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('66', '43544646', '1738', NULL, NULL, 'Grace', 'Wechecho', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014cec505f9_1778470124.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:28:44');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('67', '43544646', '1740', NULL, NULL, 'Mitchel', 'Perita', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('68', '43544646', '1743', NULL, NULL, 'Nasimiyu', 'Frince', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a014f368438c_1778470710.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:38:30');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('69', '43544646', '1748', NULL, NULL, 'Wanjala', 'Nekesa', 'Trissa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('70', '43544646', '1749', NULL, NULL, 'Mary', 'Nafula', 'Barasa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('71', '43544646', '1751', NULL, NULL, 'Kanyanya', 'Sussy', 'Namusonge', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('72', '43544646', '1753', NULL, NULL, 'Kangala', 'Mukanda', 'Margaret', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('73', '43544646', '1755', NULL, NULL, 'Dolphine', 'Natembeya', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('74', '43544646', '1762', NULL, NULL, 'Maina', 'Debora', 'Nafula', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('75', '43544646', '1764', NULL, NULL, 'Ann', 'Nato', 'Nakhanu', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01504b7abcf_1778470987.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:43:07');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('76', '43544646', '1766', NULL, NULL, 'Wanyonyi', 'Charity', 'Nafuna', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0150581203b_1778471000.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:43:20');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('77', '43544646', '1769', NULL, NULL, 'Nekesa', 'Rael', 'Wangila', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('78', '43544646', '1773', NULL, NULL, 'Wafula', 'Cynthia', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('79', '43544646', '1777', NULL, NULL, 'Nabwile', 'Biketi', 'Gredence', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('80', '43544646', '1779', NULL, NULL, 'Sifuna', 'Phostine', 'Nabangala', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('81', '43544646', '1781', NULL, NULL, 'Wakhungu', 'Brenda', 'Nasimiyu', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0150d635dd2_1778471126.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:45:26');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('82', '43544646', '1783', NULL, NULL, 'Charity', 'Nashali', 'Nafula', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('83', '43544646', '1785', NULL, NULL, 'Shalyne', 'Nanyama', 'Wakoli', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('84', '43544646', '1787', NULL, NULL, 'Centrine', 'Nanjala', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('85', '43544646', '1789', NULL, NULL, 'Victoria', 'Nekesa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('86', '43544646', '1792', NULL, NULL, 'Rabecca', 'Nasimiyu', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('87', '43544646', '1795', NULL, NULL, 'Vivian', 'Nekesa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('88', '43544646', '1796', NULL, NULL, 'Nancy', 'Nelima', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('89', '43544646', '1800', NULL, NULL, 'Gloria', 'Ationa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0150fdeaed0_1778471165.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:46:06');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('90', '43544646', '1808', NULL, NULL, 'Sifuna', 'Melvine', 'Nanjala', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01510c4cc8a_1778471180.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:46:20');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('91', '43544646', '1812', NULL, NULL, 'Wanjala', 'Mishian', 'Nabwile', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('92', '43544646', '1814', NULL, NULL, 'Millicent', 'Nyongesa', '', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('93', '43544646', '1823', NULL, NULL, 'Ngaira', 'Nabwile', 'Christabel', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01511f68562_1778471199.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:46:39');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('94', '43544646', '1831', NULL, NULL, 'Mangara', 'Charity', 'Nanjala', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('95', '43544646', '1833', NULL, NULL, 'Waswa', 'Khisa', 'Charity', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('96', '43544646', '1843', NULL, NULL, 'Ruth', 'Chebet', 'Kirui', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a01519a43bd1_1778471322.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:48:42');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('97', '43544646', '1844', NULL, NULL, 'Sikuku', 'Brinice', 'Nekesa', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/png/user-default.png', 'Active', '2026-05-11 05:56:24', '2026-05-11 05:56:24');
INSERT INTO `student` (`id`, `school`, `adm_no`, `assessment_no`, `nemis_upi`, `first_name`, `surname`, `last_name`, `gender`, `dob`, `doa`, `exit_date`, `birth_cert_no`, `nationality`, `religion`, `profile_picture`, `status`, `created_at`, `updated_at`) VALUES ('98', '43544646', '1853', NULL, NULL, 'Chepkwech', 'Neema', 'Rotich', 'Female', '2010-01-01', '2026-01-12', NULL, NULL, NULL, 'Other', 'upload/jpeg/6a0151c61b13c_1778471366.jpg', 'Active', '2026-05-11 05:56:24', '2026-05-11 06:49:26');

-- Structure for table `student_address`
CREATE TABLE `student_address` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `region` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `county` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sub_county` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ward` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `village` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `postal_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `adm_no` (`adm_no`),
  KEY `region` (`region`),
  KEY `county` (`county`),
  KEY `sub_county` (`sub_county`),
  KEY `ward` (`ward`),
  KEY `village` (`village`),
  CONSTRAINT `student_address_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_2` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_3` FOREIGN KEY (`region`) REFERENCES `region` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_4` FOREIGN KEY (`county`) REFERENCES `county` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_5` FOREIGN KEY (`sub_county`) REFERENCES `sub_county` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_6` FOREIGN KEY (`ward`) REFERENCES `ward` (`code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_address_ibfk_7` FOREIGN KEY (`village`) REFERENCES `village` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Structure for table `student_contact`
CREATE TABLE `student_contact` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `school` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adm_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `guardian_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `relationship` enum('Father','Mother','Guardian') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `occupation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `school` (`school`),
  KEY `adm_no` (`adm_no`),
  CONSTRAINT `student_contact_ibfk_1` FOREIGN KEY (`school`) REFERENCES `school` (`school_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_contact_ibfk_2` FOREIGN KEY (`adm_no`) REFERENCES `student` (`adm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Structure for table `student_guardian`
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

-- Structure for table `student_pathway`
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

-- Structure for table `student_progression`
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

-- Structure for table `sub_county`
CREATE TABLE `sub_county` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `county` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sub_county_county` (`county`),
  CONSTRAINT `sub_county_ibfk_1` FOREIGN KEY (`county`) REFERENCES `county` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `sub_county`
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('1', 'BUN', 'BUN01', 'Bumula', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('2', 'BUN', 'BUN02', 'Kabuchai', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('3', 'BUN', 'BUN03', 'Kanduyi', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('4', 'BUN', 'BUN04', 'Kimilili', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('5', 'BUN', 'BUN05', 'Mt Elgon', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('6', 'BUN', 'BUN06', 'Sirisia', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('7', 'BUN', 'BUN07', 'Tongaren', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('8', 'BUN', 'BUN08', 'Webuye East', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('9', 'BUN', 'BUN09', 'Webuye West', '2026-04-05 14:02:32', '2026-04-05 14:16:22');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('10', 'BUS', 'BUS01', 'Bunyala', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('11', 'BUS', 'BUS02', 'Busia', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('12', 'BUS', 'BUS03', 'Nambale', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('13', 'BUS', 'BUS04', 'Teso North', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('14', 'BUS', 'BUS05', 'Teso South', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('15', 'BUS', 'BUS06', 'Matayos', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('16', 'BUS', 'BUS07', 'Butula', '2026-04-05 14:14:26', '2026-04-05 14:14:26');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('17', 'KAK', 'KAK01', 'Lugari', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('18', 'KAK', 'KAK02', 'Likuyani', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('19', 'KAK', 'KAK03', 'Malava', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('20', 'KAK', 'KAK04', 'Lurambi', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('21', 'KAK', 'KAK05', 'Navakholo', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('22', 'KAK', 'KAK06', 'Mumias East', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('23', 'KAK', 'KAK07', 'Mumias West', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('24', 'KAK', 'KAK08', 'Matungu', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('25', 'KAK', 'KAK09', 'Butere', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('26', 'KAK', 'KAK10', 'Khwisero', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('27', 'VIG', 'VIG01', 'Sabatia', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('28', 'VIG', 'VIG02', 'Vihiga', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('29', 'VIG', 'VIG03', 'Hamisi', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('30', 'VIG', 'VIG04', 'Emuhaya', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('31', 'VIG', 'VIG05', 'Luanda', '2026-04-05 14:14:50', '2026-04-05 14:14:50');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('32', 'NYA', 'NYA01', 'Kinangop', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('33', 'NYA', 'NYA02', 'Kipipiri', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('34', 'NYA', 'NYA03', 'Ndaragwa', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('35', 'NYA', 'NYA04', 'Ol Kalou', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('36', 'NYA', 'NYA05', 'Ol Jorok', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('37', 'NYE', 'NYE01', 'Kieni', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('38', 'NYE', 'NYE02', 'Mathira', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('39', 'NYE', 'NYE03', 'Mukurweini', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('40', 'NYE', 'NYE04', 'Nyeri Town', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('41', 'NYE', 'NYE05', 'Othaya', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('42', 'NYE', 'NYE06', 'Tetu', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('43', 'KIR', 'KIR01', 'Gichugu', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('44', 'KIR', 'KIR02', 'Kirinyaga Central', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('45', 'KIR', 'KIR03', 'Mwea', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('46', 'KIR', 'KIR04', 'Ndia', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('47', 'MRU', 'MRU01', 'Gatanga', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('48', 'MRU', 'MRU02', 'Kangema', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('49', 'MRU', 'MRU03', 'Kandara', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('50', 'MRU', 'MRU04', 'Kiharu', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('51', 'MRU', 'MRU05', 'Mathioya', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('52', 'MRU', 'MRU06', 'Maragua', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('53', 'MRU', 'MRU07', 'Kigumo', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('54', 'KIA', 'KIA01', 'Gatundu North', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('55', 'KIA', 'KIA02', 'Gatundu South', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('56', 'KIA', 'KIA03', 'Juja', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('57', 'KIA', 'KIA04', 'Kiambaa', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('58', 'KIA', 'KIA05', 'Kiambu', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('59', 'KIA', 'KIA06', 'Kikuyu', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('60', 'KIA', 'KIA07', 'Lari', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('61', 'KIA', 'KIA08', 'Limuru', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('62', 'KIA', 'KIA09', 'Ruiru', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('63', 'KIA', 'KIA10', 'Thika Town', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('64', 'KIA', 'KIA11', 'Kabete', '2026-04-05 14:17:57', '2026-04-05 14:17:57');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('65', 'MBS', 'MBS01', 'Changamwe', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('66', 'MBS', 'MBS02', 'Jomvu', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('67', 'MBS', 'MBS03', 'Kisauni', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('68', 'MBS', 'MBS04', 'Likoni', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('69', 'MBS', 'MBS05', 'Mvita', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('70', 'MBS', 'MBS06', 'Nyali', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('71', 'KWL', 'KWL01', 'Matuga', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('72', 'KWL', 'KWL02', 'Msambweni', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('73', 'KWL', 'KWL03', 'Lunga Lunga', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('74', 'KWL', 'KWL04', 'Kinango', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('75', 'KLF', 'KLF01', 'Ganze', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('76', 'KLF', 'KLF02', 'Kaloleni', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('77', 'KLF', 'KLF03', 'Kilifi North', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('78', 'KLF', 'KLF04', 'Kilifi South', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('79', 'KLF', 'KLF05', 'Magarini', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('80', 'KLF', 'KLF06', 'Malindi', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('81', 'TRV', 'TRV01', 'Bura', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('82', 'TRV', 'TRV02', 'Galole', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('83', 'TRV', 'TRV03', 'Garsen', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('84', 'LAM', 'LAM01', 'Lamu East', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('85', 'LAM', 'LAM02', 'Lamu West', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('86', 'TTV', 'TTV01', 'Mwatate', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('87', 'TTV', 'TTV02', 'Taveta', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('88', 'TTV', 'TTV03', 'Voi', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('89', 'TTV', 'TTV04', 'Wundanyi', '2026-04-05 14:19:06', '2026-04-05 14:19:06');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('90', 'EMB', 'EMB01', 'Manyatta', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('91', 'EMB', 'EMB02', 'Mbeere North', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('92', 'EMB', 'EMB03', 'Mbeere South', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('93', 'EMB', 'EMB04', 'Runyenjes', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('94', 'KIT', 'KIT01', 'Kitui Central', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('95', 'KIT', 'KIT02', 'Kitui East', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('96', 'KIT', 'KIT03', 'Kitui West', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('97', 'KIT', 'KIT04', 'Mwingi Central', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('98', 'KIT', 'KIT05', 'Mwingi East', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('99', 'KIT', 'KIT06', 'Mwingi West', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('100', 'KIT', 'KIT07', 'Kitui South', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('101', 'MAC', 'MAC01', 'Kathiani', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('102', 'MAC', 'MAC02', 'Machakos Town', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('103', 'MAC', 'MAC03', 'Masinga', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('104', 'MAC', 'MAC04', 'Matungulu', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('105', 'MAC', 'MAC05', 'Mavoko', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('106', 'MAC', 'MAC06', 'Mwala', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('107', 'MAC', 'MAC07', 'Yatta', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('108', 'MKU', 'MKU01', 'Kibwezi East', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('109', 'MKU', 'MKU02', 'Kibwezi West', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('110', 'MKU', 'MKU03', 'Kilome', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('111', 'MKU', 'MKU04', 'Makueni', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('112', 'MKU', 'MKU05', 'Mbooni', '2026-04-05 14:20:12', '2026-04-05 14:20:12');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('113', 'NRB', 'NRB01', 'Dagoretti North', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('114', 'NRB', 'NRB02', 'Dagoretti South', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('115', 'NRB', 'NRB03', 'Embakasi Central', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('116', 'NRB', 'NRB04', 'Embakasi East', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('117', 'NRB', 'NRB05', 'Embakasi North', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('118', 'NRB', 'NRB06', 'Embakasi South', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('119', 'NRB', 'NRB07', 'Embakasi West', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('120', 'NRB', 'NRB08', 'Kamukunji', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('121', 'NRB', 'NRB09', 'Kasarani', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('122', 'NRB', 'NRB10', 'Kibra', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('123', 'NRB', 'NRB11', 'Langata', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('124', 'NRB', 'NRB12', 'Makadara', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('125', 'NRB', 'NRB13', 'Mathare', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('126', 'NRB', 'NRB14', 'Roysambu', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('127', 'NRB', 'NRB15', 'Ruaraka', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('128', 'NRB', 'NRB16', 'Starehe', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('129', 'NRB', 'NRB17', 'Westlands', '2026-04-05 14:21:23', '2026-04-05 14:21:23');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('130', 'GAR', 'GAR01', 'Balambala', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('131', 'GAR', 'GAR02', 'Dadaab', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('132', 'GAR', 'GAR03', 'Fafi', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('133', 'GAR', 'GAR04', 'Garissa Township', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('134', 'GAR', 'GAR05', 'Ijara', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('135', 'WAJ', 'WAJ01', 'Wajir East', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('136', 'WAJ', 'WAJ02', 'Wajir North', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('137', 'WAJ', 'WAJ03', 'Wajir South', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('138', 'WAJ', 'WAJ04', 'Wajir West', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('139', 'WAJ', 'WAJ05', 'Tarbaj', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('140', 'WAJ', 'WAJ06', 'Eldas', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('141', 'WAJ', 'WAJ07', 'Wajir East', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('142', 'MAN', 'MAN01', 'Banisa', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('143', 'MAN', 'MAN02', 'Lafey', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('144', 'MAN', 'MAN03', 'Mandera East', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('145', 'MAN', 'MAN04', 'Mandera North', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('146', 'MAN', 'MAN05', 'Mandera South', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('147', 'MAN', 'MAN06', 'Mandera West', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('148', 'MAN', 'MAN07', 'Kutulo', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('149', 'MAN', 'MAN08', 'Arabia', '2026-04-05 14:22:47', '2026-04-05 14:22:47');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('150', 'SIA', 'SIA01', 'Alego Usonga', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('151', 'SIA', 'SIA02', 'Gem', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('152', 'SIA', 'SIA03', 'Bondo', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('153', 'SIA', 'SIA04', 'Rarieda', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('154', 'SIA', 'SIA05', 'Ugunja', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('155', 'SIA', 'SIA06', 'Ugenya', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('156', 'KSM', 'KSM01', 'Kisumu Central', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('157', 'KSM', 'KSM02', 'Kisumu East', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('158', 'KSM', 'KSM03', 'Kisumu West', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('159', 'KSM', 'KSM04', 'Muhoroni', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('160', 'KSM', 'KSM05', 'Nyakach', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('161', 'KSM', 'KSM06', 'Nyando', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('162', 'KSM', 'KSM07', 'Seme', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('163', 'HMB', 'HMB01', 'Homa Bay Town', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('164', 'HMB', 'HMB02', 'Kabondo Kasipul', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('165', 'HMB', 'HMB03', 'Karachuonyo', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('166', 'HMB', 'HMB04', 'Kasipul', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('167', 'HMB', 'HMB05', 'Mbita', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('168', 'HMB', 'HMB06', 'Ndhiwa', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('169', 'HMB', 'HMB07', 'Rangwe', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('170', 'HMB', 'HMB08', 'Suba North', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('171', 'HMB', 'HMB09', 'Suba South', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('172', 'MIG', 'MIG01', 'Awendo', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('173', 'MIG', 'MIG02', 'Kuria East', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('174', 'MIG', 'MIG03', 'Kuria West', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('175', 'MIG', 'MIG04', 'Nyatike', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('176', 'MIG', 'MIG05', 'Rongo', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('177', 'MIG', 'MIG06', 'Suna East', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('178', 'MIG', 'MIG07', 'Suna West', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('179', 'MIG', 'MIG08', 'Uriri', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('180', 'KSI', 'KSI01', 'Bobasi', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('181', 'KSI', 'KSI02', 'Bomachoge Borabu', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('182', 'KSI', 'KSI03', 'Bomachoge Chache', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('183', 'KSI', 'KSI04', 'Bonchari', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('184', 'KSI', 'KSI05', 'Nyaribari Chache', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('185', 'KSI', 'KSI06', 'Nyaribari Masaba', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('186', 'KSI', 'KSI07', 'South Mugirango', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('187', 'KSI', 'KSI08', 'Kitutu Chache North', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('188', 'KSI', 'KSI09', 'Kitutu Chache South', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('189', 'NYM', 'NYM01', 'Borabu', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('190', 'NYM', 'NYM02', 'Manga', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('191', 'NYM', 'NYM03', 'Masaba North', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('192', 'NYM', 'NYM04', 'Nyamira North', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('193', 'NYM', 'NYM05', 'Nyamira South', '2026-04-05 14:23:49', '2026-04-05 14:23:49');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('194', 'NAK', 'NAK01', 'Nakuru Town East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('195', 'NAK', 'NAK02', 'Nakuru Town West', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('196', 'NAK', 'NAK03', 'Naivasha', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('197', 'NAK', 'NAK04', 'Gilgil', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('198', 'NAK', 'NAK05', 'Kuresoi North', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('199', 'NAK', 'NAK06', 'Kuresoi South', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('200', 'NAK', 'NAK07', 'Molo', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('201', 'NAK', 'NAK08', 'Njoro', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('202', 'NAK', 'NAK09', 'Subukia', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('203', 'NAK', 'NAK10', 'Rongai', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('204', 'NAK', 'NAK11', 'Bahati', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('205', 'UGI', 'UGI01', 'Ainabkoi', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('206', 'UGI', 'UGI02', 'Kapseret', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('207', 'UGI', 'UGI03', 'Kesses', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('208', 'UGI', 'UGI04', 'Moiben', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('209', 'UGI', 'UGI05', 'Soy', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('210', 'UGI', 'UGI06', 'Turbo', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('211', 'BAR', 'BAR01', 'Baringo Central', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('212', 'BAR', 'BAR02', 'Baringo North', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('213', 'BAR', 'BAR03', 'Baringo South', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('214', 'BAR', 'BAR04', 'Eldama Ravine', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('215', 'BAR', 'BAR05', 'Mogotio', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('216', 'BAR', 'BAR06', 'Tiaty', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('217', 'KAJ', 'KAJ01', 'Kajiado Central', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('218', 'KAJ', 'KAJ02', 'Kajiado East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('219', 'KAJ', 'KAJ03', 'Kajiado North', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('220', 'KAJ', 'KAJ04', 'Kajiado West', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('221', 'KAJ', 'KAJ05', 'Loitokitok', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('222', 'KAJ', 'KAJ06', 'Mashuuru', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('223', 'KER', 'KER01', 'Ainamoi', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('224', 'KER', 'KER02', 'Belgut', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('225', 'KER', 'KER03', 'Bureti', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('226', 'KER', 'KER04', 'Kipkelion East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('227', 'KER', 'KER05', 'Kipkelion West', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('228', 'KER', 'KER06', 'Soin Sigowet', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('229', 'BOM', 'BOM01', 'Bomet Central', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('230', 'BOM', 'BOM02', 'Bomet East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('231', 'BOM', 'BOM03', 'Chepalungu', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('232', 'BOM', 'BOM04', 'Konoin', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('233', 'BOM', 'BOM05', 'Sotik', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('234', 'NAR', 'NAR01', 'Narok East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('235', 'NAR', 'NAR02', 'Narok North', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('236', 'NAR', 'NAR03', 'Narok South', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('237', 'NAR', 'NAR04', 'Narok West', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('238', 'NAR', 'NAR05', 'Transmara East', '2026-04-05 14:26:04', '2026-04-05 14:26:04');
INSERT INTO `sub_county` (`id`, `county`, `code`, `description`, `created_at`, `updated_at`) VALUES ('239', 'NAR', 'NAR06', 'Transmara West', '2026-04-05 14:26:04', '2026-04-05 14:26:04');

-- Structure for table `subject`
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

-- Data for table `subject`
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('1', 'LANG100', 'Language Activities', 'Pre-Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('2', 'MATH100', 'Mathematical Activities', 'Pre-Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('3', 'ENV100', 'Environmental Activities', 'Pre-Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('4', 'CRE100', 'Creative Activities', 'Pre-Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('5', 'REL100', 'Religious Education Activities', 'Pre-Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('6', 'PE100', 'Psychomotor & Outdoor Play', 'Pre-Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('7', 'LIFE101', 'Life Skills Activities', 'Pre-Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('8', 'ENG101', 'English', 'Lower Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('9', 'KIS101', 'Kiswahili', 'Lower Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('10', 'MATH101', 'Mathematics', 'Lower Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('11', 'ENV101', 'Environmental Activities', 'Lower Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('12', 'CRE101', 'Creative Arts', 'Lower Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('13', 'REL101', 'Religious Education', 'Lower Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('14', 'PE101', 'Physical & Health Education', 'Lower Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('15', 'LANG101', 'Indigenous Language / Sign Language', 'Lower Primary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('16', 'ICT101', 'Intro to ICT', 'Lower Primary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('17', 'ENG201', 'English', 'Upper Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('18', 'KIS201', 'Kiswahili', 'Upper Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('19', 'MATH201', 'Mathematics', 'Upper Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('20', 'SCI201', 'Science & Technology', 'Upper Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('21', 'SST201', 'Social Studies', 'Upper Primary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('22', 'REL201', 'Religious Education', 'Upper Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('23', 'CRE201', 'Creative Arts', 'Upper Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('24', 'PE201', 'Physical & Health Education', 'Upper Primary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('25', 'AGR201', 'Agriculture', 'Upper Primary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('26', 'ICT201', 'ICT', 'Upper Primary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('27', 'LANG201', 'Foreign / Indigenous Language', 'Upper Primary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('28', 'ENG301', 'English', 'Junior Secondary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('29', 'KIS301', 'Kiswahili', 'Junior Secondary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('30', 'MATH301', 'Mathematics', 'Junior Secondary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('31', 'SCI301', 'Integrated Science', 'Junior Secondary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('32', 'SST301', 'Social Studies', 'Junior Secondary', NULL, 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('33', 'REL301', 'Religious Education', 'Junior Secondary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('34', 'PE301', 'Physical Education', 'Junior Secondary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('35', 'LIFE301', 'Life Skills', 'Junior Secondary', NULL, 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('36', 'CRE301', 'Creative Arts', 'Junior Secondary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('37', 'AGR301', 'Agriculture', 'Junior Secondary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('38', 'ICT301', 'Computer Studies', 'Junior Secondary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('39', 'LANG301', 'Indigenous / Foreign Language', 'Junior Secondary', NULL, 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('40', 'ENG401', 'English', 'Senior Secondary', '1', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('41', 'KIS401', 'Kiswahili', 'Senior Secondary', '1', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('42', 'MATH401', 'Mathematics', 'Senior Secondary', '1', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('43', 'FMT401', 'Further Mathematics', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('44', 'PHY401', 'Physics', 'Senior Secondary', '1', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('45', 'CHE401', 'Chemistry', 'Senior Secondary', '1', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('46', 'BIO401', 'Biology', 'Senior Secondary', '1', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('47', 'CSC401', 'Computer Science', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('48', 'AGR401', 'Agriculture', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('49', 'ELE401', 'Electrical Technology', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('50', 'ICT401', 'Information & Communication Technology', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('51', 'GEO401', 'Geography', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('52', 'ECON401', 'Economics', 'Senior Secondary', '1', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('53', 'ENG402', 'English', 'Senior Secondary', '2', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('54', 'KIS402', 'Kiswahili', 'Senior Secondary', '2', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('55', 'MATH402', 'Mathematics', 'Senior Secondary', '2', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('56', 'VIS402', 'Visual Arts', 'Senior Secondary', '2', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('57', 'PER402', 'Performing Arts', 'Senior Secondary', '2', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('58', 'MUS402', 'Music', 'Senior Secondary', '2', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('59', 'DRA402', 'Drama', 'Senior Secondary', '2', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('60', 'PE402', 'Physical Education & Sports Science', 'Senior Secondary', '2', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('61', 'FILM402', 'Film & Media Studies', 'Senior Secondary', '2', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('62', 'CRE402', 'Creative Writing & Literature', 'Senior Secondary', '2', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('63', 'GEO402', 'Geography', 'Senior Secondary', '2', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('64', 'ENG403', 'English', 'Senior Secondary', '3', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('65', 'KIS403', 'Kiswahili', 'Senior Secondary', '3', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('66', 'MATH403', 'Mathematics', 'Senior Secondary', '3', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('67', 'HIS403', 'History', 'Senior Secondary', '3', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('68', 'GEO403', 'Geography', 'Senior Secondary', '3', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('69', 'ECO403', 'Economics', 'Senior Secondary', '3', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('70', 'SOC403', 'Sociology', 'Senior Secondary', '3', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('71', 'PSY403', 'Psychology', 'Senior Secondary', '3', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('72', 'REL403', 'Religious Education', 'Senior Secondary', '3', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('73', 'PHIL403', 'Philosophy', 'Senior Secondary', '3', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('74', 'LANG403', 'Foreign Language (French / German / Arabic / Mandarin)', 'Senior Secondary', '3', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('75', 'ENG404', 'English', 'Senior Secondary', '4', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('76', 'KIS404', 'Kiswahili', 'Senior Secondary', '4', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('77', 'MATH404', 'Mathematics', 'Senior Secondary', '4', 'Core');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('78', 'BUS404', 'Business Studies', 'Senior Secondary', '4', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('79', 'ENT404', 'Entrepreneurship', 'Senior Secondary', '4', 'Compulsory');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('80', 'ACC404', 'Accounting', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('81', 'AGR404', 'Agriculture', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('82', 'ELE404', 'Electrical Technology', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('83', 'AUTO404', 'Automotive Technology', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('84', 'HOSP404', 'Hospitality & Catering', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('85', 'ICT404', 'ICT / Computer Studies', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('86', 'FNB404', 'Food & Nutrition', 'Senior Secondary', '4', 'Optional');
INSERT INTO `subject` (`id`, `subject_code`, `subject_name`, `level`, `pathway`, `category`) VALUES ('87', 'TEC404', 'Technical Drawing / Industrial Design', 'Senior Secondary', '4', 'Optional');

-- Structure for table `subject_preference`
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

-- Structure for table `subject_teacher`
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

-- Structure for table `tax`
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

-- Structure for table `term`
CREATE TABLE `term` (
  `id` int NOT NULL AUTO_INCREMENT,
  `term_code` smallint NOT NULL,
  `term_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `opening_date` date DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `term_code` (`term_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `term`
INSERT INTO `term` (`id`, `term_code`, `term_name`, `opening_date`, `closing_date`) VALUES ('1', '1', 'Term 1', '2026-01-01', '2026-04-30');
INSERT INTO `term` (`id`, `term_code`, `term_name`, `opening_date`, `closing_date`) VALUES ('2', '2', 'Term 2', '2026-05-01', '2026-08-08');
INSERT INTO `term` (`id`, `term_code`, `term_name`, `opening_date`, `closing_date`) VALUES ('3', '3', 'Term 3', '2026-09-01', '2026-12-31');

-- Structure for table `timetable_constraint`
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

-- Structure for table `training_program`
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

-- Data for table `training_program`
INSERT INTO `training_program` (`id`, `school`, `program_code`, `program_name`, `facilitator_name`, `start_date`, `end_date`, `status`, `comment`, `created_at`, `updated_at`) VALUES ('1', '12345678', '4tTpv', 'MIS Training', 'Paramount Communication Centre', '2025-10-15', '2025-10-14', 'New', 'Will be done at workin stations', '2025-10-15 20:03:29', '2025-10-17 06:08:21');

-- Structure for table `unit_category`
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

-- Data for table `unit_category`
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('1', 'Weight', 'Units related to mass and weight (grams, kilograms, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('2', 'Length', 'Units related to linear distance (meters, centimeters, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('3', 'Volume', 'Units related to liquid or space (liters, milliliters, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('4', 'Count', 'Discrete countable items (each, dozen, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('5', 'Area', 'Surface area units (square meters, hectares, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('6', 'Time', 'Time measurement units (seconds, hours, days, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('7', 'Energy', 'Energy or power units (joules, kilowatt-hours, etc.)', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');
INSERT INTO `unit_category` (`id`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('8', 'Compound', 'Compound units like boxes, cartons, etc.', '1', '2025-04-20 12:35:41', '2025-04-20 12:35:41');

-- Structure for table `unit_of_measure`
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

-- Data for table `unit_of_measure`
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('1', 'Gram', 'g', '1', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('2', 'Kilogram', 'kg', '1', '1000.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('3', 'Meter', 'm', '3', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('4', 'Centimeter', 'cm', '3', '0.010000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('5', 'Liter', 'L', '5', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('6', 'Milliliter', 'mL', '5', '0.001000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('7', 'Each', 'EA', '7', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('8', 'Dozen', 'DZ', '7', '12.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('9', 'Pair', 'PR', '7', '2.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('10', 'Gross', 'GR', '7', '144.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('11', 'Square Meter', 'mâ”¬â–“', '8', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('12', 'Hectare', 'ha', '8', '10000.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('13', 'Second', 's', '9', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('14', 'Minute', 'min', '9', '60.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('15', 'Hour', 'hr', '9', '3600.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('16', 'Joule', 'J', '11', '1.000000', '1', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('17', 'Kilojoule', 'kJ', '11', '1000.000000', '0', '0', NULL, NULL, '1', '2025-04-20 12:35:52', '2025-04-20 12:35:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('18', 'Box of 12 Each', 'BOX12', '7', '12.000000', '0', '1', '{\"unit\": \"Each\", \"contains\": 12}', '1 Box contains 12 items', '1', '2025-04-20 12:40:52', '2025-04-20 12:40:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('19', 'Pack of 6 Each', 'PK6', '7', '6.000000', '0', '1', '{\"unit\": \"Each\", \"contains\": 6}', '1 Pack contains 6 items', '1', '2025-04-20 12:40:52', '2025-04-20 12:40:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('20', 'Carton of 24 Bottles', 'CTN24', '7', '24.000000', '0', '1', '{\"unit\": \"Bottle\", \"contains\": 24}', '1 Carton contains 24 Bottles', '1', '2025-04-20 12:40:52', '2025-04-20 12:40:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('21', 'Tray of 30 Eggs', 'TRY30', '7', '30.000000', '0', '1', '{\"unit\": \"Egg\", \"contains\": 30}', '1 Tray contains 30 eggs', '1', '2025-04-20 12:40:52', '2025-04-20 12:40:52');
INSERT INTO `unit_of_measure` (`id`, `name`, `abbreviation`, `base_unit_id`, `conversion_factor`, `is_default`, `is_compound`, `compound_structure`, `description`, `is_active`, `created_at`, `updated_at`) VALUES ('22', 'Pallet of 50 Boxes (12 Each)', 'PLT50B12', '7', '600.000000', '0', '1', '{\"structure\": [{\"unit\": \"Box\", \"contains\": 50}, {\"unit\": \"Each\", \"box_contains\": 12}]}', '1 Pallet contains 50 boxes of 12 each (total 600 items)', '1', '2025-04-20 12:40:52', '2025-04-20 12:40:52');

-- Structure for table `user`
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data for table `user`
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('1', '43544646', 'hWbFL', 'pcc', '$2y$12$ffvLK.eQFbhSKr2wEb42f.AQwVrN2flmFT.3iZEjP5HazbWh6oXPG', 'Musee Abiud', 'sa', 'school', 'museeabiud@outlook.com', '0741915943', 'upload/png/user-default-2-min.png', '2025-09-19', '2026-05-11', '02:59:00', '2026-05-11', '12:19:11', '4', '1', '39fe9298783aca2e86186609d8b2d173', '2025-09-19 18:55:28', '2026-05-11 05:59:00', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('2', '12345678', 'Bd8aS', '12345678', '$2y$12$OXpzfJvEDMrgopZrDfR1eOdHQLngV.cJhkrB27lZ.4VjgL1t2i06y', 'PCC Secondary School', 'school', 'hrm', 'pccws.limited@gmail.com', '0741915943', 'upload/png/user-default-2-min.png', '2025-09-19', '2026-05-10', '09:30:39', '2026-05-10', '09:31:35', '4', '1', NULL, '2025-09-19 18:55:28', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('3', '12345678', 'gfgdg', '87654321', '$2y$12$OXpzfJvEDMrgopZrDfR1eOdHQLngV.cJhkrB27lZ.4VjgL1t2i06y', 'PCC Secondary School', 'school', 'hrm', '87654321@gmail.com', '0741915943', 'upload/png/user-default-2-min.png', '2025-09-19', '2025-10-06', '10:06:04', NULL, NULL, '4', '1', 'cf41678d2a5c6b011a12e179dc194789', '2025-09-21 18:05:33', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('4', '12345678', '32456578', 'kobwoyo', '$2y$12$bVU05pt2Ui1Ie32tX4nlZ.PeDDPNQuvMnqMZpGv2sxhAzBbnOvLLe', 'Kelvin Obwoyo', 'support', 'support', 'kobwoyo@gmail.com', '0767856545', 'upload/png/user-default-2-min.png', '2025-09-27', '2026-05-03', '06:06:46', '2026-05-03', '06:06:57', '4', '1', NULL, '2025-09-27 09:49:27', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('5', '12345678', '32352452', 'nancy', '$2y$12$szlcVnQWJtH85xsj5GsUWeB5wWu0sebeB1dnwxo/EDuwGMR7yZiRe', 'Nancy Chemtai', 'support', 'support', 'nancychem@gmail.com', '0751423652', 'upload/png/user-default-2-min.png', '2025-09-27', '2026-05-03', '06:05:49', '2026-05-03', '06:06:30', '4', '1', NULL, '2025-09-27 10:05:29', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('6', '36626126', 'KtsBm', '36626126', '$2y$12$9/UCKFOQNRVB556vX7Mqc.WdlBc53zGc7fnoiCvpcrfIKLBW3F.Rq', 'Sibanga S.A Comprehensive School', 'school', 'school', 'sasibangacs@go.ke', '0700212354', 'upload/jpeg/68e0c9c2849db_1759562178.jpg', '2025-10-04', '2025-10-04', '10:22:24', '2025-10-04', '10:28:47', '4', '1', NULL, '2025-10-04 10:22:07', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('7', '36626205', 'dcOJC', '36626205', '$2y$12$cQD5rhGTUyawq9.8mAGgjuCInC.XTzyEg./6gxHtZyiyk52AWbuwW', 'AC. Bungonge High School', 'school', 'school', 'acbutongehs@go.ke', '0788665544', 'upload/jpeg/68e0d92e08b41_1759566126.jpg', '2025-10-04', '2025-10-04', '11:25:42', NULL, NULL, '4', '1', '3f67af1d38ad76996480364d534aea53', '2025-10-04 11:25:28', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('8', '12345678', '15643256', 'silas', '$2y$12$ffvLK.eQFbhSKr2wEb42f.AQwVrN2flmFT.3iZEjP5HazbWh6oXPG', 'Silas Wanambisi', 'sa', 'sa', 'wsilas@gmail.com', '0124345365', 'upload/png/user-default-2-min.png', '2025-10-04', '2026-05-11', '01:12:28', '2026-05-11', '12:44:55', '4', '1', 'c6bf0abded22b51ddb304228f2d8215f', '2025-10-04 11:47:04', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('9', '36626123', 'cVfoi', '36626123', '$2y$12$CfTAMDFzUAzzY5IxT33gJuVG2f4eB0M6aQO7lSJl.m640tFLGGdyi', 'Namwela Friends Boys High School', 'school', 'hrm', 'namwelafbhs@gmail.com', '0723456789', 'upload/jpeg/68e257cca7e30_1759664076.jpg', '2025-10-05', '2025-10-12', '07:55:01', '2025-10-12', '08:20:52', '4', '1', NULL, '2025-10-05 16:23:23', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('10', '12345678', '12345678', 'bahati', '$2y$12$d2Hszxqn7UF3uoSHzvai4.UwMwlSwgukhjICimt85oCC85sAUNUJy', 'Abigael Bahati', 'teacher', 'teacher', 'abigaelbahati@gmail.com', '0756342314', 'upload/jpeg/2e4d26d7e8f5e1b62f2a17d549ffe6c5.jpg', '2025-10-06', '2026-05-03', '06:09:20', '2025-10-09', '03:17:02', '4', '1', '15f02c59fa1f837efc252aa3e52424b5', '2025-10-06 11:05:58', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('11', '32564215', 'VUw6a', '32564215', '$2y$12$W/pfxfovS4ed.yeQk.7vS.MxEzMRXLFDVcvSWt0hO5XVoXPmQ2XWO', 'St. Ann\'s Comprehensive School', 'school', 'school', 'stannscs@gmail.com', '0752142635', 'upload/jpeg/696b614ad9442_1768644938.jpg', '2026-01-18', NULL, NULL, NULL, NULL, '4', '1', NULL, '2026-01-18 13:15:14', '2026-05-11 05:00:58', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('12', '43544646', 'jNh0g', '43544646', '$2y$12$qaB.HOqvAphQOzlHo3nKc.vlWZw3ECnBY.82ElOsHaxGGXNpYXGYa', 'Friends Senior School Kimugui Girls', 'school', 'school', 'gkimugui@gmail.com', '0745635243', 'upload/jpeg/69f700baee57c_1777795258.jpg', '2026-05-04', '2026-05-11', '12:59:51', '2026-05-11', '01:12:08', '4', '1', '8f3c6f015b95f838b21150e216075d12', '2026-05-04 14:54:59', '2026-05-11 05:00:59', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('13', '43544646', '67544347', 'Paul', '$2y$12$P9o3jKIykm/n0ZczP8TOUORTKWUeHGRCEWLKcL3robMk8EmXZzQRK', 'Paul Khisa', 'teacher', 'teacher', 'khisap@gmail.com', '0756345245', 'upload/jpeg/6a00bdc905c7b_1778433481.jpg', '2026-05-11', '2026-05-11', '12:58:16', '2026-05-11', '01:00:36', '4', '1', 'd382b37fb74697741b029828e39687d9', '2026-05-11 03:57:15', '2026-05-11 05:00:59', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('14', '43544646', '32876789', 'Mang\'oli', '$2y$12$Yt.FY43vxe.C99UyYhRA8uXECliILcAPj0R7i6VA3Ee57SFrqnATG', 'Stephen Mang\'oli', 'teacher', 'teacher', 'msteve@gmail.com', '0189676547', 'upload/jpeg/6a00bee52c921_1778433765.jpg', '2026-05-11', '2026-05-11', '01:03:20', NULL, NULL, '4', '1', '1dd6c11c4c62bd8add7fd5700dcb80ed', '2026-05-11 04:03:07', '2026-05-11 05:00:59', NULL);
INSERT INTO `user` (`id`, `school`, `userid`, `username`, `password`, `displayname`, `role`, `profile`, `email`, `contact`, `photo`, `regdate`, `lastlogindate`, `lastlogintime`, `lastlogoutdate`, `lastlogouttime`, `attempts`, `status`, `session_id`, `created_at`, `updated_at`, `updated_by`) VALUES ('15', '36508767', 'kXao5', '36508767', '$2y$12$PbKWwToi8T1qTCgxpwz0kuY47gorWD.vmB5bC/PXc3en6vkLPnP4u', 'Petra Education Centre', 'school', 'hrm', 'petra@gmail.com', '0720686453', 'upload/jpeg/6a012e0d5cf1e_1778462221.jpg', '2026-05-11', '2026-05-11', '01:57:12', '2026-05-11', '02:05:50', '4', '1', 'a4f87d80466bca223abbdf2bc9baa12e', '2026-05-11 04:56:21', '2026-05-11 05:05:50', NULL);

-- Structure for table `vendor`
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

-- Structure for table `village`
CREATE TABLE `village` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ward` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_village_ward` (`ward`),
  CONSTRAINT `village_ibfk_1` FOREIGN KEY (`ward`) REFERENCES `ward` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Structure for table `ward`
CREATE TABLE `ward` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sub_county` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_ward_sub_county` (`sub_county`),
  CONSTRAINT `ward_ibfk_1` FOREIGN KEY (`sub_county`) REFERENCES `sub_county` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Backup Views
DROP VIEW IF EXISTS `branch`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `branch` AS select distinct `dv_branch`.`id` AS `id`,`dv_branch`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_branch`.`dv_code` AS `branch_code`,`dv_branch`.`dv_name` AS `branch_name`,`dv_branch`.`description` AS `description`,`dv_branch`.`incharge` AS `manager` from (((`dim_value` `dv_branch` join `dimension` `d` on((`dv_branch`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_branch`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_branch`.`incharge` = `t`.`staff_code`))) where (`dv_branch`.`filter_name` = 'Branch');

DROP VIEW IF EXISTS `department`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `department` AS select distinct `dv_department`.`id` AS `id`,`dv_department`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_department`.`dv_code` AS `dept_code`,`dv_department`.`dv_name` AS `dept_name`,`dv_department`.`description` AS `description`,`dv_department`.`incharge` AS `dept_hod` from (((`dim_value` `dv_department` join `dimension` `d` on((`dv_department`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_department`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_department`.`incharge` = `t`.`staff_code`))) where (`dv_department`.`filter_name` = 'Department');

DROP VIEW IF EXISTS `location`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `location` AS select distinct `dv_location`.`id` AS `id`,`dv_location`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_location`.`dv_code` AS `location_code`,`dv_location`.`dv_name` AS `location_name`,`dv_location`.`description` AS `description`,`dv_location`.`incharge` AS `manager` from (((`dim_value` `dv_location` join `dimension` `d` on((`dv_location`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_location`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_location`.`incharge` = `t`.`staff_code`))) where (`dv_location`.`filter_name` = 'Store Location');

DROP VIEW IF EXISTS `principal`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `principal` AS select `staff`.`school` AS `school`,`staff`.`staff_code` AS `teacher_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Principal');

DROP VIEW IF EXISTS `settlement_type`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `settlement_type` AS select distinct `dv_stype`.`id` AS `id`,`dv_stype`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_stype`.`dv_code` AS `st_code`,`dv_stype`.`dv_name` AS `st_name`,`dv_stype`.`description` AS `description`,`dv_stype`.`incharge` AS `manager` from (((`dim_value` `dv_stype` join `dimension` `d` on((`dv_stype`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_stype`.`school` = `sch`.`school_code`))) left join `staff` `t` on((`dv_stype`.`incharge` = `t`.`staff_code`))) where (`dv_stype`.`filter_name` = 'Settlement Type');

DROP VIEW IF EXISTS `subject_department`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `subject_department` AS select distinct `dv_subject_dept`.`id` AS `id`,`dv_subject_dept`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_subject_dept`.`dv_code` AS `dept_code`,`dv_subject_dept`.`dv_name` AS `dept_name`,`dv_subject_dept`.`description` AS `description` from ((`dim_value` `dv_subject_dept` join `dimension` `d` on((`dv_subject_dept`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_subject_dept`.`school` = `sch`.`school_code`))) where (`dv_subject_dept`.`filter_name` = 'Subject Department');

DROP VIEW IF EXISTS `subject_group`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `subject_group` AS select distinct `dv_group`.`id` AS `id`,`dv_group`.`school` AS `school_code`,`sch`.`school_name` AS `school_name`,`dv_group`.`dv_code` AS `group_code`,`dv_group`.`dv_name` AS `group_name`,`dv_group`.`description` AS `description` from ((`dim_value` `dv_group` join `dimension` `d` on((`dv_group`.`dim_id` = `d`.`dim_id`))) join `school` `sch` on((`dv_group`.`school` = `sch`.`school_code`))) where (`dv_group`.`filter_name` = 'Subject Group');

DROP VIEW IF EXISTS `support_staff`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `support_staff` AS select `staff`.`id` AS `id`,`staff`.`school` AS `school`,`staff`.`staff_code` AS `staff_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Support');

DROP VIEW IF EXISTS `teacher`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `teacher` AS select `staff`.`id` AS `id`,`staff`.`school` AS `school`,`staff`.`staff_code` AS `teacher_code`,`staff`.`first_name` AS `first_name`,`staff`.`last_name` AS `last_name`,`staff`.`gender` AS `gender`,`staff`.`email` AS `email`,`staff`.`phone` AS `phone`,`staff`.`id_no` AS `id_no`,`staff`.`hire_date` AS `hire_date`,`staff`.`emp_term` AS `emp_term`,`staff`.`status` AS `status` from `staff` where (`staff`.`role` = 'Teacher');

-- Backup Stored Procedures & Functions
DROP PROCEDURE IF EXISTS `generate_balance_sheet`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_balance_sheet`()
BEGIN
    SELECT 
        type,
        SUM(jl.debit - jl.credit) AS balance
    FROM chart_of_account coa
    JOIN journal_line jl ON jl.account_id = coa.id
    WHERE coa.type IN ('Asset', 'Liability', 'Equity')
    GROUP BY type;
END;

DROP PROCEDURE IF EXISTS `generate_trial_balance`;
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
END;

DROP PROCEDURE IF EXISTS `mark_bill_paid`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_bill_paid`(IN billId INT)
BEGIN
    UPDATE bill
    SET status = 'Paid', payment_status = 'Paid'
    WHERE id = billId;
END;

DROP PROCEDURE IF EXISTS `mark_invoice_paid`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_invoice_paid`(IN invoiceId INT)
BEGIN
    UPDATE invoice
    SET status = 'Paid', payment_status = 'Paid'
    WHERE id = invoiceId;
END;

DROP PROCEDURE IF EXISTS `pivot_assessment_result`;
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
END;

-- Backup Triggers
-- Backup Events
SET FOREIGN_KEY_CHECKS=1;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY',''));