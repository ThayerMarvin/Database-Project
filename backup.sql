/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.27-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_kvortekj
-- ------------------------------------------------------
-- Server version	10.11.11-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Addresses`
--

DROP TABLE IF EXISTS `Addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Addresses` (
  `addressID` int(11) NOT NULL AUTO_INCREMENT,
  `addressLine1` varchar(50) NOT NULL,
  `city` varchar(30) NOT NULL,
  `state` varchar(20) NOT NULL,
  `postalCode` char(5) NOT NULL,
  PRIMARY KEY (`addressID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Addresses`
--

LOCK TABLES `Addresses` WRITE;
/*!40000 ALTER TABLE `Addresses` DISABLE KEYS */;
INSERT INTO `Addresses` VALUES (1,'123 Main St','Springfield','Oregon','97478'),(2,'407 Jefferson St','Eugene','Oregon','97407'),(3,'42 W 11th Ave','Eugene','Oregon','97407'),(4,'1389 Whitmore Circle','Eugene','Oregon','97408');
/*!40000 ALTER TABLE `Addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Customers` (
  `customerID` int(11) NOT NULL AUTO_INCREMENT,
  `customerName` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  `accountValue` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`customerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
INSERT INTO `Customers` VALUES (1,'Thayer Marvin','thayer@gmail.com','541-701-1881',51.00),(2,'Joven Kvortek','Jovenk@hotmail.com','541-567-8125',12.00),(3,'Madison Nelson','nelsonm@yahoo.com','541-968-3239',27.00),(4,'Penelope Paul','ppaul@gmail.com','541-701-1235',22.00);
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductBrands`
--

DROP TABLE IF EXISTS `ProductBrands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductBrands` (
  `productBrandID` int(11) NOT NULL AUTO_INCREMENT,
  `productBrand` varchar(50) NOT NULL,
  PRIMARY KEY (`productBrandID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductBrands`
--

LOCK TABLES `ProductBrands` WRITE;
/*!40000 ALTER TABLE `ProductBrands` DISABLE KEYS */;
INSERT INTO `ProductBrands` VALUES (1,'Topps'),(2,'Pokemon'),(3,'Magic The Gathering');
/*!40000 ALTER TABLE `ProductBrands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductHasSales`
--

DROP TABLE IF EXISTS `ProductHasSales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductHasSales` (
  `productHasSalesID` int(11) NOT NULL AUTO_INCREMENT,
  `productID` int(11) NOT NULL,
  `saleID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`productHasSalesID`),
  KEY `productID` (`productID`),
  KEY `saleID` (`saleID`),
  CONSTRAINT `ProductHasSales_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `Products` (`productID`) ON DELETE CASCADE,
  CONSTRAINT `ProductHasSales_ibfk_2` FOREIGN KEY (`saleID`) REFERENCES `Sales` (`saleID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductHasSales`
--

LOCK TABLES `ProductHasSales` WRITE;
/*!40000 ALTER TABLE `ProductHasSales` DISABLE KEYS */;
INSERT INTO `ProductHasSales` VALUES (1,1,1,3,5.99),(2,2,2,1,200.00),(3,3,3,2,14.99),(4,4,4,2,99.99);
/*!40000 ALTER TABLE `ProductHasSales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductTypes`
--

DROP TABLE IF EXISTS `ProductTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductTypes` (
  `productTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `productType` varchar(50) NOT NULL,
  `productBrandID` int(11) NOT NULL,
  `productDescription` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`productTypeID`),
  KEY `productBrandID` (`productBrandID`),
  CONSTRAINT `ProductTypes_ibfk_1` FOREIGN KEY (`productBrandID`) REFERENCES `ProductBrands` (`productBrandID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductTypes`
--

LOCK TABLES `ProductTypes` WRITE;
/*!40000 ALTER TABLE `ProductTypes` DISABLE KEYS */;
INSERT INTO `ProductTypes` VALUES (1,'Sports Card Box',1,'Box of 10 Booster Packs'),(2,'Pokemon Card Booster Pack',2,'Single Booster Pack'),(3,'Magic Cards Deck',3,'Prebuilt Deck'),(4,'Pokemon Card Binder',2,'Card Binder');
/*!40000 ALTER TABLE `ProductTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Products`
--

DROP TABLE IF EXISTS `Products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Products` (
  `productID` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `productSalesPrice` decimal(10,2) NOT NULL,
  `productTypeID` int(11) NOT NULL,
  `vendorID` int(11) NOT NULL,
  PRIMARY KEY (`productID`),
  KEY `productTypeID` (`productTypeID`),
  KEY `vendorID` (`vendorID`),
  CONSTRAINT `Products_ibfk_1` FOREIGN KEY (`productTypeID`) REFERENCES `ProductTypes` (`productTypeID`) ON DELETE CASCADE,
  CONSTRAINT `Products_ibfk_2` FOREIGN KEY (`vendorID`) REFERENCES `Vendors` (`vendorID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Products`
--

LOCK TABLES `Products` WRITE;
/*!40000 ALTER TABLE `Products` DISABLE KEYS */;
INSERT INTO `Products` VALUES (1,'Surging Sparks Blister',3.50,5.99,2,2),(2,'NFL Super Breaker',75.00,200.00,1,1),(3,'Catch Em All Binder',6.50,14.99,4,2),(4,'Final Fantasy Prebuilt Deck',47.89,99.99,3,4);
/*!40000 ALTER TABLE `Products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sales` (
  `saleID` int(11) NOT NULL AUTO_INCREMENT,
  `customerID` int(11) DEFAULT NULL,
  `saleDate` date NOT NULL,
  `transactionType` enum('sale','purchase') NOT NULL,
  `saleAmount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`saleID`),
  KEY `customerID` (`customerID`),
  CONSTRAINT `Sales_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customers` (`customerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
INSERT INTO `Sales` VALUES (1,1,'2025-01-19','sale',17.97),(2,2,'2025-03-04','sale',200.00),(3,3,'2025-04-11','sale',29.98),(4,1,'2025-04-24','sale',199.98);
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vendors`
--

DROP TABLE IF EXISTS `Vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Vendors` (
  `vendorID` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phoneNumber` varchar(12) NOT NULL,
  `addressID` int(11) NOT NULL,
  `accountsPayable` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`vendorID`),
  KEY `addressID` (`addressID`),
  CONSTRAINT `Vendors_ibfk_1` FOREIGN KEY (`addressID`) REFERENCES `Addresses` (`addressID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vendors`
--

LOCK TABLES `Vendors` WRITE;
/*!40000 ALTER TABLE `Vendors` DISABLE KEYS */;
INSERT INTO `Vendors` VALUES (1,'Sports N Stuff','sportsnstuff@gmail.com','541-920-6354',1,250.47),(2,'Pokemon Connect','pc@gmail.com','541-567-8125',2,900.54),(3,'TradingCards R Us','tradingcardsru@gmail.com','541-503-4487',3,133.56),(4,'Magical Cards','magical@gmail.com','541-330-2990',4,601.23);
/*!40000 ALTER TABLE `Vendors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bsg_cert`
--

DROP TABLE IF EXISTS `bsg_cert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bsg_cert` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bsg_cert`
--

LOCK TABLES `bsg_cert` WRITE;
/*!40000 ALTER TABLE `bsg_cert` DISABLE KEYS */;
INSERT INTO `bsg_cert` VALUES (1,'Raptor'),(2,'Viper'),(3,'Mechanic'),(4,'Command');
/*!40000 ALTER TABLE `bsg_cert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bsg_cert_people`
--

DROP TABLE IF EXISTS `bsg_cert_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bsg_cert_people` (
  `cid` int(11) NOT NULL DEFAULT 0,
  `pid` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`cid`,`pid`),
  KEY `pid` (`pid`),
  CONSTRAINT `bsg_cert_people_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `bsg_cert` (`id`),
  CONSTRAINT `bsg_cert_people_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `bsg_people` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bsg_cert_people`
--

LOCK TABLES `bsg_cert_people` WRITE;
/*!40000 ALTER TABLE `bsg_cert_people` DISABLE KEYS */;
INSERT INTO `bsg_cert_people` VALUES (1,7),(2,2),(2,4),(3,8),(3,9),(4,2),(4,3),(4,6);
/*!40000 ALTER TABLE `bsg_cert_people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bsg_people`
--

DROP TABLE IF EXISTS `bsg_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bsg_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) DEFAULT NULL,
  `homeworld` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `homeworld` (`homeworld`),
  CONSTRAINT `bsg_people_ibfk_1` FOREIGN KEY (`homeworld`) REFERENCES `bsg_planets` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bsg_people`
--

LOCK TABLES `bsg_people` WRITE;
/*!40000 ALTER TABLE `bsg_people` DISABLE KEYS */;
INSERT INTO `bsg_people` VALUES (1,'William','Adama',3,61),(2,'Lee','Adama',3,30),(3,'Laura','Roslin',3,NULL),(4,'Kara','Thrace',3,NULL),(5,'Gaius','Baltar',3,NULL),(6,'Saul','Tigh',NULL,71),(7,'Karl','Agathon',1,NULL),(8,'Galen','Tyrol',1,32),(9,'Callandra','Henderson',NULL,NULL);
/*!40000 ALTER TABLE `bsg_people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bsg_planets`
--

DROP TABLE IF EXISTS `bsg_planets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bsg_planets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `population` bigint(20) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `capital` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bsg_planets`
--

LOCK TABLES `bsg_planets` WRITE;
/*!40000 ALTER TABLE `bsg_planets` DISABLE KEYS */;
INSERT INTO `bsg_planets` VALUES (1,'Gemenon',2800000000,'Old Gemenese','Oranu'),(2,'Leonis',2600000000,'Leonese','Luminere'),(3,'Caprica',4900000000,'Caprican','Caprica City'),(7,'Sagittaron',1700000000,NULL,'Tawa'),(16,'Aquaria',25000,NULL,NULL),(17,'Canceron',6700000000,NULL,'Hades'),(18,'Libran',2100000,NULL,NULL),(19,'Picon',1400000000,NULL,'Queestown'),(20,'Scorpia',450000000,NULL,'Celeste'),(21,'Tauron',2500000000,'Tauron','Hypatia'),(22,'Virgon',4300000000,NULL,'Boskirk');
/*!40000 ALTER TABLE `bsg_planets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diag_function_cert_use`
--

DROP TABLE IF EXISTS `diag_function_cert_use`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diag_function_cert_use` (
  `used` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diag_function_cert_use`
--

LOCK TABLES `diag_function_cert_use` WRITE;
/*!40000 ALTER TABLE `diag_function_cert_use` DISABLE KEYS */;
INSERT INTO `diag_function_cert_use` VALUES (0);
/*!40000 ALTER TABLE `diag_function_cert_use` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_cert_people`
--

DROP TABLE IF EXISTS `v_cert_people`;
/*!50001 DROP VIEW IF EXISTS `v_cert_people`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_cert_people` AS SELECT
 1 AS `title`,
  1 AS `fname`,
  1 AS `lname`,
  1 AS `planet_name` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_cert_people`
--

/*!50001 DROP VIEW IF EXISTS `v_cert_people`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cs340_kvortekj`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_cert_people` AS select `c`.`title` AS `title`,`p`.`fname` AS `fname`,`p`.`lname` AS `lname`,`pl`.`name` AS `planet_name` from (((`bsg_cert_people` `cp` join `bsg_people` `p` on(`cp`.`pid` = `p`.`id`)) left join `bsg_cert` `c` on(`cp`.`cid` = `c`.`id`)) left join `bsg_planets` `pl` on(`p`.`homeworld` = `pl`.`id`)) */;
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

-- Dump completed on 2025-05-26 15:55:52
