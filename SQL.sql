-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.1.0 - MySQL Community Server - GPL
-- Server OS:                    Win64
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


-- Dumping database structure for base
CREATE DATABASE IF NOT EXISTS `base` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `base`;

-- Dumping structure for table base.cd_garage_keys
CREATE TABLE IF NOT EXISTS `cd_garage_keys` (
  `plate` varchar(8) COLLATE utf8mb4_bin NOT NULL,
  `owner_identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `reciever_identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `char_name` varchar(50) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table base.cd_garage_keys: ~0 rows (approximately)
DELETE FROM `cd_garage_keys`;

-- Dumping structure for table base.cd_garage_privategarage
CREATE TABLE IF NOT EXISTS `cd_garage_privategarage` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `data` longtext COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table base.cd_garage_privategarage: ~0 rows (approximately)
DELETE FROM `cd_garage_privategarage`;

-- Dumping structure for table base.discord_whitelist
CREATE TABLE IF NOT EXISTS `discord_whitelist` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DiscordID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.discord_whitelist: ~1 rows (approximately)
DELETE FROM `discord_whitelist`;
INSERT INTO `discord_whitelist` (`ID`, `DiscordID`) VALUES
	(1, '892504906576048138'),
	(2, '942409225517273098');

-- Dumping structure for table base.gas_station_balance
CREATE TABLE IF NOT EXISTS `gas_station_balance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gas_station_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `income` bit(1) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `amount` int unsigned NOT NULL,
  `date` int unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table base.gas_station_balance: ~0 rows (approximately)
DELETE FROM `gas_station_balance`;
INSERT INTO `gas_station_balance` (`id`, `gas_station_id`, `income`, `title`, `amount`, `date`) VALUES
	(1, 'gas_station_1', b'0', 'Dinheiro depositado', 5000, 1693492821),
	(2, 'gas_station_1', b'1', 'Dinheiro levantado', 5000, 1693492848),
	(3, 'gas_station_1', b'0', 'Dinheiro depositado', 50000, 1693492851),
	(4, 'gas_station_1', b'1', 'Dinheiro levantado', 50000, 1693492860),
	(5, 'gas_station_1', b'0', 'Dinheiro depositado', 50000, 1693492870),
	(6, 'gas_station_1', b'1', 'Stock comprado: Small cargo de 50 Litros', 1500, 1693492906),
	(7, 'gas_station_1', b'0', 'Fuel sold (25 Liters)', 5, 1693493173),
	(8, 'gas_station_1', b'1', 'Dinheiro levantado', 48505, 1693493485),
	(9, 'gas_station_1', b'0', 'Dinheiro depositado', 40000, 1693493506);

-- Dumping structure for table base.gas_station_business
CREATE TABLE IF NOT EXISTS `gas_station_business` (
  `gas_station_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `user_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `stock` int unsigned NOT NULL DEFAULT '0',
  `price` int unsigned NOT NULL DEFAULT '0',
  `stock_upgrade` tinyint unsigned NOT NULL DEFAULT '0',
  `truck_upgrade` tinyint unsigned NOT NULL DEFAULT '0',
  `relationship_upgrade` tinyint unsigned NOT NULL DEFAULT '0',
  `money` int unsigned NOT NULL DEFAULT '0',
  `total_money_earned` int unsigned NOT NULL DEFAULT '0',
  `total_money_spent` int unsigned NOT NULL DEFAULT '0',
  `gas_bought` int unsigned NOT NULL DEFAULT '0',
  `gas_sold` int unsigned NOT NULL DEFAULT '0',
  `distance_traveled` double unsigned NOT NULL DEFAULT '0',
  `total_visits` int unsigned NOT NULL DEFAULT '0',
  `customers` int unsigned NOT NULL DEFAULT '0',
  `timer` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`gas_station_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table base.gas_station_business: ~0 rows (approximately)
DELETE FROM `gas_station_business`;
INSERT INTO `gas_station_business` (`gas_station_id`, `user_id`, `stock`, `price`, `stock_upgrade`, `truck_upgrade`, `relationship_upgrade`, `money`, `total_money_earned`, `total_money_spent`, `gas_bought`, `gas_sold`, `distance_traveled`, `total_visits`, `customers`, `timer`) VALUES
	('gas_station_1', 'char1:66ca53f5a836c0f7a80f3c524d842537230cc8a1', 25, 180, 0, 0, 0, 40000, 5, 1500, 50, 25, 0.69, 6, 1, 1693492738);

-- Dumping structure for table base.gas_station_jobs
CREATE TABLE IF NOT EXISTS `gas_station_jobs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gas_station_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reward` int unsigned NOT NULL DEFAULT '0',
  `amount` int NOT NULL DEFAULT '0',
  `progress` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table base.gas_station_jobs: ~0 rows (approximately)
DELETE FROM `gas_station_jobs`;

-- Dumping structure for table base.items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int NOT NULL DEFAULT '1',
  `rare` tinyint NOT NULL DEFAULT '0',
  `can_remove` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.items: ~1 rows (approximately)
DELETE FROM `items`;
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('radio', 'Rádio', 1, 0, 1);

-- Dumping structure for table base.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.jobs: ~1 rows (approximately)
DELETE FROM `jobs`;
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
	('unemployed', 'Desempregado', 0);

-- Dumping structure for table base.job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.job_grades: ~1 rows (approximately)
DELETE FROM `job_grades`;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(1, 'unemployed', 0, 'unemployed', 'Desempregado', 200, '{}', '{}');

-- Dumping structure for table base.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.licenses: ~7 rows (approximately)
DELETE FROM `licenses`;
INSERT INTO `licenses` (`type`, `label`) VALUES
	('dmv', 'Código da Estrada'),
	('drive', 'Carta de Condução B'),
	('drive_bike', 'Carta de Condução A'),
	('drive_truck', 'Carta de Condução C'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License'),
	('weapon', 'Weapon License');

-- Dumping structure for table base.multicharacter_slots
CREATE TABLE IF NOT EXISTS `multicharacter_slots` (
  `identifier` varchar(46) NOT NULL,
  `slots` int NOT NULL,
  PRIMARY KEY (`identifier`) USING BTREE,
  KEY `slots` (`slots`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.multicharacter_slots: ~0 rows (approximately)
DELETE FROM `multicharacter_slots`;

-- Dumping structure for table base.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(46) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext,
  `lastupdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.ox_inventory: ~0 rows (approximately)
DELETE FROM `ox_inventory`;

-- Dumping structure for table base.users
CREATE TABLE IF NOT EXISTS `users` (
  `uId` int NOT NULL,
  `identifier` varchar(46) NOT NULL,
  `accounts` longtext,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int DEFAULT '0',
  `metadata` longtext,
  `position` longtext,
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int DEFAULT NULL,
  `skin` longtext,
  `id` int NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

-- Dumping data for table base.users: ~1 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`uId`, `identifier`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `metadata`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `id`, `disabled`) VALUES
	(1, 'char1:391a38f06c95f8e488ff79e788562896d8ce5cb7', '{"black_money":0,"bank":50204,"money":0}', 'staff', '[{"name":"lockpick","slot":1,"count":1}]', 'unemployed', 0, '[]', '{"x":221.11648559570313,"y":-814.03515625,"z":31.3355712890625}', 'Joao', 'Almeida', '11/01/1999', 'm', 189, '{"age_1":0,"ears_1":-1,"arms_2":0,"helmet_2":-1,"glasses_1":-1,"chain_2":0,"hair_2":0,"nose_3":0,"cheeks_1":0,"blush_3":"2","chin_2":0,"makeup_2":0,"complexion_2":0,"lip_thickness":0,"pants_1":0,"eyebrows_5":0,"eyebrows_3":0,"makeup_3":0,"moles_1":0,"moles_2":0,"cheeks_2":0,"makeup_4":0,"chin_1":0,"helmet_1":-1,"jaw_2":0,"watches_1":-1,"chin_4":0,"chain_1":0,"torso_1":0,"lipstick_3":32,"eye_color":0,"tshirt_2":0,"complexion_1":0,"neck_thickness":0,"beard_3":61,"shoes_2":0,"nose_6":0,"torso_2":0,"blush_1":0,"watches_2":-1,"chin_3":0,"eyebrows_6":0,"lipstick_1":0,"skin_md_weight":50,"glasses_2":-1,"nose_2":0,"eyebrows_1":0,"makeup_1":0,"blush_2":0,"beard_1":0,"eye_squint":0,"tshirt_1":0,"ears_2":-1,"hair_color_1":0,"eyebrows_2":10,"sun_2":0,"sun_1":0,"nose_4":0,"jaw_1":0,"age_2":0,"lipstick_2":0,"shoes_1":0,"hair_1":0,"nose_1":0,"arms":0,"nose_5":0,"beard_2":0,"face_md_weight":50,"eyebrows_4":0,"hair_color_2":0,"cheeks_3":0,"sex":0,"pants_2":0}', 18, 0),
	(2, 'char1:66ca53f5a836c0f7a80f3c524d842537230cc8a1', '{"black_money":0,"bank":9099,"money":0}', 'staff', '[{"count":5,"name":"scrapmetal","slot":1,"metadata":{"type":"item"}},{"count":5,"name":"scrapmetal","slot":2,"metadata":{"type":"type"}},{"name":"lockpick","slot":3,"count":1}]', 'unemployed', 0, '[]', '{"x":265.4769287109375,"y":-1245.86376953125,"z":29.128173828125}', 'Texugo', 'Latt', '05/03/1997', 'm', 125, '{"eyebrows_4":0,"watches_2":-1,"chin_3":0,"eyebrows_2":10,"face_md_weight":50,"watches_1":-1,"cheeks_3":0,"eyebrows_1":0,"makeup_4":0,"torso_2":0,"eyebrows_6":0,"beard_2":0,"arms_2":0,"nose_3":0,"tshirt_2":0,"beard_3":61,"tshirt_1":0,"hair_color_2":0,"blush_3":"2","nose_6":0,"glasses_2":-1,"beard_1":0,"chin_2":0,"eyebrows_5":0,"hair_1":0,"lipstick_2":0,"sun_1":0,"eye_squint":0,"lipstick_3":32,"jaw_1":0,"torso_1":0,"shoes_1":0,"glasses_1":-1,"nose_1":0,"blush_1":0,"arms":0,"blush_2":0,"cheeks_1":0,"chin_4":0,"makeup_2":0,"age_2":0,"chain_1":0,"jaw_2":0,"nose_5":0,"complexion_2":0,"nose_4":0,"eye_color":0,"lipstick_1":0,"helmet_2":-1,"chin_1":0,"hair_color_1":0,"sun_2":0,"skin_md_weight":50,"eyebrows_3":0,"makeup_1":0,"age_1":0,"pants_2":0,"cheeks_2":0,"ears_2":-1,"helmet_1":-1,"pants_1":0,"shoes_2":0,"nose_2":0,"complexion_1":0,"makeup_3":0,"neck_thickness":0,"ears_1":-1,"sex":0,"moles_2":0,"hair_2":0,"chain_2":0,"lip_thickness":0,"moles_1":0}', 19, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
