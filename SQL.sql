-- --------------------------------------------------------
-- Host:                         main
-- Server version:               10.5.19-MariaDB-0+deb11u2 - Debian 11
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for Base
CREATE DATABASE IF NOT EXISTS `Base` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `Base`;

-- Dumping structure for table Base.discord_whitelist
CREATE TABLE IF NOT EXISTS `discord_whitelist` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DiscordID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.discord_whitelist: ~1 rows (approximately)
DELETE FROM `discord_whitelist`;
INSERT INTO `discord_whitelist` (`ID`, `DiscordID`) VALUES
	(1, '892504906576048138');

-- Dumping structure for table Base.items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.items: ~1 rows (approximately)
DELETE FROM `items`;
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('radio', 'Rádio', 1, 0, 1);

-- Dumping structure for table Base.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.jobs: ~1 rows (approximately)
DELETE FROM `jobs`;
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
	('unemployed', 'Desempregado', 0);

-- Dumping structure for table Base.job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.job_grades: ~1 rows (approximately)
DELETE FROM `job_grades`;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(1, 'unemployed', 0, 'unemployed', 'Desempregado', 200, '{}', '{}');

-- Dumping structure for table Base.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.licenses: ~4 rows (approximately)
DELETE FROM `licenses`;
INSERT INTO `licenses` (`type`, `label`) VALUES
	('dmv', 'Código da Estrada'),
	('drive', 'Carta de Condução B'),
	('drive_bike', 'Carta de Condução A'),
	('drive_truck', 'Carta de Condução C'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License');

-- Dumping structure for table Base.multicharacter_slots
CREATE TABLE IF NOT EXISTS `multicharacter_slots` (
  `identifier` varchar(46) NOT NULL,
  `slots` int(11) NOT NULL,
  PRIMARY KEY (`identifier`) USING BTREE,
  KEY `slots` (`slots`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.multicharacter_slots: ~0 rows (approximately)
DELETE FROM `multicharacter_slots`;

-- Dumping structure for table Base.owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(46) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.owned_vehicles: ~0 rows (approximately)
DELETE FROM `owned_vehicles`;

-- Dumping structure for table Base.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(46) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.ox_inventory: ~0 rows (approximately)
DELETE FROM `ox_inventory`;

-- Dumping structure for table Base.users
CREATE TABLE IF NOT EXISTS `users` (
  `uId` int(11) NOT NULL,
  `identifier` varchar(46) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `metadata` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table Base.users: ~1 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`uId`, `identifier`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `metadata`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `id`, `disabled`) VALUES
	(1, 'char1:391a38f06c95f8e488ff79e788562896d8ce5cb7', '{"money":0,"black_money":0,"bank":50000}', 'user', '[]', 'unemployed', 0, '[]', '{"z":35.83447265625,"x":-533.1824340820313,"y":-247.16043090820313}', 'Joao', 'Almeida', '11/01/1999', 'm', 189, '{"age_1":0,"ears_1":-1,"arms_2":0,"helmet_2":-1,"glasses_1":-1,"chain_2":0,"hair_2":0,"nose_3":0,"cheeks_1":0,"blush_3":"2","chin_2":0,"makeup_2":0,"complexion_2":0,"lip_thickness":0,"pants_1":0,"eyebrows_5":0,"eyebrows_3":0,"makeup_3":0,"moles_1":0,"moles_2":0,"cheeks_2":0,"makeup_4":0,"chin_1":0,"helmet_1":-1,"jaw_2":0,"watches_1":-1,"chin_4":0,"chain_1":0,"torso_1":0,"lipstick_3":32,"eye_color":0,"tshirt_2":0,"complexion_1":0,"neck_thickness":0,"beard_3":61,"shoes_2":0,"nose_6":0,"torso_2":0,"blush_1":0,"watches_2":-1,"chin_3":0,"eyebrows_6":0,"lipstick_1":0,"skin_md_weight":50,"glasses_2":-1,"nose_2":0,"eyebrows_1":0,"makeup_1":0,"blush_2":0,"beard_1":0,"eye_squint":0,"tshirt_1":0,"ears_2":-1,"hair_color_1":0,"eyebrows_2":10,"sun_2":0,"sun_1":0,"nose_4":0,"jaw_1":0,"age_2":0,"lipstick_2":0,"shoes_1":0,"hair_1":0,"nose_1":0,"arms":0,"nose_5":0,"beard_2":0,"face_md_weight":50,"eyebrows_4":0,"hair_color_2":0,"cheeks_3":0,"sex":0,"pants_2":0}', 18, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
