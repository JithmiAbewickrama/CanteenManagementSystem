-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 05, 2021 at 10:12 PM
-- Server version: 5.7.21
-- PHP Version: 5.6.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `canteen`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_item`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_item` (IN `item_id` CHAR(6), IN `type` VARCHAR(100), IN `item_name` VARCHAR(100), IN `unit_price` FLOAT(5,2), IN `ex_date` DATE, IN `manu_date` DATE)  BEGIN
INSERT INTO item(item_id,item_type,name,unit_price,mfd_date,exp_date)
VALUES
(item_id,type,item_name,unit_price,ex_date,manu_date);
END$$

DROP PROCEDURE IF EXISTS `delete_item`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_item` (IN `item_id_no` CHAR(6))  BEGIN
DELETE FROM item 
WHERE item_id =item_id_no;
END$$

DROP PROCEDURE IF EXISTS `delete_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user` (IN `u_id` CHAR(6))  BEGIN
DELETE FROM user 
WHERE user_id =u_id;
END$$

DROP PROCEDURE IF EXISTS `insert_order`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_order` (IN `order_id` CHAR(6), IN `item` VARCHAR(255), IN `quantity` INT(3), IN `itm_id` CHAR(6), IN `user_id` CHAR(6))  BEGIN
DECLARE total FLOAT(5,2);
SELECT unit_price
INTO total
FROM item
WHERE item_id=itm_id;
SET total = total * quantity;
INSERT INTO order_details(order_id, item, quantity, item_id, user_id, amount)
VALUES
(order_id, item, quantity, itm_id, user_id, total);
END$$

DROP PROCEDURE IF EXISTS `insert_order_to_transaction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_order_to_transaction` (IN `t_id` CHAR(6), IN `o_id` CHAR(6))  BEGIN
DECLARE total FLOAT(2); 
DECLARE t_date DATE;
SELECT amount, curdate()
INTO total, t_date 
FROM order_details 
WHERE order_id = o_id;
INSERT INTO transaction(t_id, order_id, total_amount, date) 
VALUES (t_id, o_id, total, t_date);
END$$

DROP PROCEDURE IF EXISTS `insert_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user` (IN `u_id` CHAR(6), IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255), IN `mobile` INT, IN `role` VARCHAR(255))  BEGIN

INSERT INTO user(user_id, name, email, password, mobile, role)
VALUES
(u_id, name, email, password, mobile, role);
END$$

DROP PROCEDURE IF EXISTS `order_details_invoice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_details_invoice` (IN `u_id` VARCHAR(6))  BEGIN
SELECT o.user_id, i.item_id, i.name, o.quantity, i.unit_price, o.amount, o.date 
FROM order_details o, item i  
WHERE o.item_id = i.item_id AND o.user_id = u_id;
END$$

DROP PROCEDURE IF EXISTS `update_item`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_item` (IN `id` CHAR(6), IN `type` VARCHAR(100), IN `item_name` VARCHAR(100), IN `price` FLOAT(5,2), IN `ex_date` DATE, IN `manu_date` DATE)  BEGIN
UPDATE item
SET item_type=type,
name=item_name,
unit_price=price,
mfd_date=manu_date,
exp_date=ex_date
WHERE item_id =id;
END$$

DROP PROCEDURE IF EXISTS `update_order`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_order` (IN `o_id` CHAR(6), IN `item_name` VARCHAR(255), IN `quantity` INT, IN `itm_id` CHAR(6), IN `u_id` CHAR(6))  BEGIN
DECLARE total FLOAT(5,2);

   SELECT unit_price
   INTO total
   FROM item
   WHERE item_id=itm_id;
   SET total = total * quantity;

   UPDATE order_details
   SET 
      item=item_name,
      quantity=quantity,
      item_id =itm_id,
      user_id=u_id,
      amount=total
   WHERE order_id =o_id;

END$$

DROP PROCEDURE IF EXISTS `update_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user` (IN `u_id` CHAR(6), IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255), IN `mobile` INT, IN `role` VARCHAR(255))  BEGIN
UPDATE user 
SET 
user_id = u_id, 
name = name, 
email = email, 
password = password,
mobile = mobile,
role = role
WHERE user_id = u_id;
END$$

DROP PROCEDURE IF EXISTS `view_user_orders`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_user_orders` (IN `u_id` VARCHAR(6))  BEGIN
SELECT o.user_id, i.item_id, i.name, o.quantity, i.unit_price, o.amount, o.date 
FROM order_details o, item i  
WHERE o.item_id = i.item_id AND o.user_id = u_id;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `calculate_daily_transaction_amount`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_daily_transaction_amount` () RETURNS FLOAT BEGIN
    DECLARE daily_transaction_amount FLOAT;
    SELECT SUM(total_amount) 
    INTO daily_transaction_amount
    FROM transaction
    WHERE DATE(date)=DATE(NOW())
    GROUP BY date;
    RETURN (daily_transaction_amount);
END$$

DROP FUNCTION IF EXISTS `calculate_daily_transaction_count`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_daily_transaction_count` () RETURNS INT(11) BEGIN
    DECLARE daily_transaction_count INT;
    SELECT COUNT(t_id) 
    INTO daily_transaction_count
    FROM transaction
    WHERE DATE(date)=DATE(now())
    GROUP BY date;
    RETURN (daily_transaction_count);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `admin_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `admin_view`;
CREATE TABLE IF NOT EXISTS `admin_view` (
`order_id` char(6)
,`unit_price` float(5,2)
,`quantity` int(3)
,`item_id` char(6)
,`date` timestamp
,`total_amount` double(19,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `hibernate_sequence`
--

DROP TABLE IF EXISTS `hibernate_sequence`;
CREATE TABLE IF NOT EXISTS `hibernate_sequence` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `hibernate_sequence`
--

INSERT INTO `hibernate_sequence` (`next_val`) VALUES
(1);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
CREATE TABLE IF NOT EXISTS `inventory` (
  `inve_id` char(6) NOT NULL,
  `quantity` int(11) NOT NULL,
  `item_id` char(6) NOT NULL,
  `order_id` char(6) NOT NULL,
  PRIMARY KEY (`inve_id`),
  KEY `item_id` (`item_id`),
  KEY `order_id` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inve_id`, `quantity`, `item_id`, `order_id`) VALUES
('I001', 498, 'P001', 'OD/01'),
('I002', 497, 'P002', 'OD/02'),
('I003', 500, 'P003', 'OD/03'),
('I004', 497, 'P004', 'OD/04'),
('I005', 493, 'P005', 'OD/05'),
('I006', 500, 'P006', 'OD/06');

--
-- Triggers `inventory`
--
DROP TRIGGER IF EXISTS `TR_after_insert_inventory`;
DELIMITER $$
CREATE TRIGGER `TR_after_insert_inventory` AFTER INSERT ON `inventory` FOR EACH ROW BEGIN

DECLARE inve_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET inve_data  = CONCAT_WS(', ', new.inve_id, new.quantity, new.item_id, new.order_id);
SET user = CURRENT_USER;
SET operation = 'INSERT';
SET changedat = now();

INSERT INTO inventory_log (data, user, operation, changedat)
VALUES
(inve_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_after_update_inventory`;
DELIMITER $$
CREATE TRIGGER `TR_after_update_inventory` AFTER UPDATE ON `inventory` FOR EACH ROW BEGIN

DECLARE inve_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET inve_data  = CONCAT_WS(', ', new.inve_id, new.quantity, new.item_id, new.order_id);
SET user = CURRENT_USER;
SET operation = 'UPDATE';
SET changedat = now();

INSERT INTO inventory_log (data, user, operation, changedat)
VALUES
(inve_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_before_delete_inventory`;
DELIMITER $$
CREATE TRIGGER `TR_before_delete_inventory` BEFORE DELETE ON `inventory` FOR EACH ROW BEGIN

DECLARE inve_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET inve_data  = CONCAT_WS(', ', old.inve_id, old.quantity, old.item_id, old.order_id);
SET user = CURRENT_USER;
SET operation = 'DELETE';
SET changedat = now();

INSERT INTO inventory_log (data, user, operation, changedat)
VALUES
(inve_data, user, operation, changedat);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_log`
--

DROP TABLE IF EXISTS `inventory_log`;
CREATE TABLE IF NOT EXISTS `inventory_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `operation` varchar(7) DEFAULT NULL,
  `changedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `inventory_log`
--

INSERT INTO `inventory_log` (`id`, `data`, `user`, `operation`, `changedat`) VALUES
(1, 'I001, 500, P001, OD/01', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(2, 'I002, 500, P002, OD/02', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(3, 'I003, 500, P003, OD/03', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(4, 'I004, 500, P004, OD/04', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(5, 'I005, 500, P005, OD/05', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(6, 'I006, 500, P006, OD/06', 'root@localhost', 'INSERT', '2021-06-30 13:37:41'),
(7, 'I004, 497, P004, OD/04', 'root@localhost', 'UPDATE', '2021-06-30 13:49:04'),
(8, 'I005, 495, P005, OD/05', 'root@localhost', 'UPDATE', '2021-06-30 13:49:41'),
(9, 'I001, 498, P001, OD/01', 'root@localhost', 'UPDATE', '2021-06-30 13:49:41'),
(10, 'I002, 497, P002, OD/02', 'root@localhost', 'UPDATE', '2021-06-30 13:50:37'),
(11, 'I006, 496, P006, OD/06', 'root@localhost', 'UPDATE', '2021-06-30 14:16:12'),
(12, 'I006, 500, P006, OD/06', 'root@localhost', 'UPDATE', '2021-06-30 14:17:18'),
(13, 'I005, 493, P005, OD/05', 'root@localhost', 'UPDATE', '2021-07-05 02:25:32'),
(14, 'I005, 495, P005, OD/05', 'root@localhost', 'UPDATE', '2021-07-05 02:31:20'),
(15, 'I005, 493, P005, OD/05', 'root@localhost', 'UPDATE', '2021-07-05 02:39:33');

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE IF NOT EXISTS `item` (
  `item_id` char(6) NOT NULL,
  `item_type` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `unit_price` float(5,2) NOT NULL,
  `mfd_date` date NOT NULL,
  `exp_date` date NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`item_id`, `item_type`, `name`, `unit_price`, `mfd_date`, `exp_date`) VALUES
('P001', 'Product', 'Chocalate', 105.00, '2021-01-01', '2022-01-01'),
('P002', 'Product', 'Biscuit', 60.00, '2021-08-01', '2022-08-01'),
('P003', 'Food', 'Rice', 90.00, '2021-06-30', '2021-06-30'),
('P004', 'Product', 'Cake', 150.00, '2021-01-01', '2022-01-01'),
('P005', 'Roles', 'Food', 35.00, '2021-07-06', '2021-07-06');

--
-- Triggers `item`
--
DROP TRIGGER IF EXISTS `TR_after_insert_item`;
DELIMITER $$
CREATE TRIGGER `TR_after_insert_item` AFTER INSERT ON `item` FOR EACH ROW BEGIN

DECLARE item_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET item_data  = CONCAT_WS(', ', new.item_id, new.item_type, new.name, new.unit_price, new.mfd_date, new.exp_date);
SET user = CURRENT_USER;
SET operation = 'INSERT';
SET changedat = now();

INSERT INTO item_log (data, user, operation, changedat)
VALUES
(item_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_after_update_item`;
DELIMITER $$
CREATE TRIGGER `TR_after_update_item` AFTER UPDATE ON `item` FOR EACH ROW BEGIN

DECLARE item_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET item_data  = CONCAT_WS(', ', new.item_id, new.item_type, new.name, new.unit_price, new.mfd_date, new.exp_date);
SET user = CURRENT_USER;
SET operation = 'UPDATE';
SET changedat = now();

INSERT INTO item_log (data, user, operation, changedat)
VALUES
(item_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_before_delete_item`;
DELIMITER $$
CREATE TRIGGER `TR_before_delete_item` BEFORE DELETE ON `item` FOR EACH ROW BEGIN

DECLARE item_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET item_data  = CONCAT_WS(', ', old.item_id, old.item_type, old.name, old.unit_price, old.mfd_date, old.exp_date);
SET user = CURRENT_USER;
SET operation = 'DELETE';
SET changedat = now();

INSERT INTO item_log (data, user, operation, changedat)
VALUES
(item_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_update_price_on_item`;
DELIMITER $$
CREATE TRIGGER `TR_update_price_on_item` AFTER UPDATE ON `item` FOR EACH ROW BEGIN

    UPDATE order_details
    SET amount = quantity * new.unit_price
    WHERE item_id = new.item_id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `item_log`
--

DROP TABLE IF EXISTS `item_log`;
CREATE TABLE IF NOT EXISTS `item_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `operation` varchar(7) DEFAULT NULL,
  `changedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `item_log`
--

INSERT INTO `item_log` (`id`, `data`, `user`, `operation`, `changedat`) VALUES
(1, 'P001, Product, Chocalate, 100.00, 2021-01-01, 2022-01-01', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(2, 'P002, Product, Biscuit, 60.00, 2021-08-01, 2022-08-01', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(3, 'P003, Food, Rice, 80.00, 2021-06-30, 2021-06-30', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(4, 'P004, Product, Cake, 150.00, 2021-01-01, 2022-01-01', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(5, 'P005, Product, Yogurt, 45.00, 2021-01-01, 2021-08-01', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(6, 'P006, Food, Kottu, 120.00, 2021-06-30, 2021-06-30', 'root@localhost', 'INSERT', '2021-06-30 13:18:49'),
(7, 'P001, Product, Chocalate, 105.00, 2021-01-01, 2022-01-01', 'root@localhost', 'UPDATE', '2021-06-30 13:19:57'),
(8, 'P003, Food, Rice, 90.00, 2021-06-30, 2021-06-30', 'root@localhost', 'UPDATE', '2021-06-30 13:57:17'),
(9, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'INSERT', '2021-07-04 23:06:14'),
(10, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'DELETE', '2021-07-04 23:31:55'),
(11, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'INSERT', '2021-07-04 23:32:14'),
(12, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'DELETE', '2021-07-04 23:42:00'),
(13, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'INSERT', '2021-07-04 23:44:24'),
(14, 'P007, Roles, Food, 35.00, 2021-07-04, 2021-07-04', 'root@localhost', 'DELETE', '2021-07-06 02:32:32'),
(15, 'P006, Food, Kottu, 120.00, 2021-06-30, 2021-06-30', 'root@localhost', 'DELETE', '2021-07-06 02:34:57'),
(16, 'P005, Product, Yogurt, 45.00, 2021-01-01, 2021-08-01', 'root@localhost', 'DELETE', '2021-07-06 02:37:04'),
(17, 'P005, Roles, Food, 35.00, 2021-07-06, 2021-07-06', 'root@localhost', 'INSERT', '2021-07-06 02:42:00');

-- --------------------------------------------------------

--
-- Stand-in structure for view `item_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `item_view`;
CREATE TABLE IF NOT EXISTS `item_view` (
`ID` char(6)
,`Type` varchar(100)
,`Name` varchar(100)
,`Unit Price` float(5,2)
,`Mfd_date` date
,`Exp_date` date
);

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
CREATE TABLE IF NOT EXISTS `order_details` (
  `order_id` char(6) NOT NULL,
  `item` varchar(255) NOT NULL,
  `quantity` int(3) NOT NULL,
  `item_id` char(6) NOT NULL,
  `user_id` char(6) NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` float NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `item_id` (`item_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`order_id`, `item`, `quantity`, `item_id`, `user_id`, `date`, `amount`) VALUES
('OD/01', 'Cake', 3, 'P004', 'U001', '2021-06-30 08:19:04', 450),
('OD/02', 'Yogurt', 5, 'P005', 'U001', '2021-06-30 08:19:41', 225),
('OD/03', 'Chocolate', 2, 'P001', 'U002', '2021-06-30 08:19:41', 210),
('OD/04', 'Biscuit', 3, 'P002', 'U002', '2021-06-30 08:20:37', 180),
('OD/05', 'Yogurt', 2, 'P005', 'U007', '2021-07-04 21:09:33', 90);

--
-- Triggers `order_details`
--
DROP TRIGGER IF EXISTS `TR_after_insert_order`;
DELIMITER $$
CREATE TRIGGER `TR_after_insert_order` AFTER INSERT ON `order_details` FOR EACH ROW BEGIN

DECLARE order_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET order_data  = CONCAT_WS(', ', new.order_id, new.item, new.quantity, new.item_id, new.user_id, new.date, new.amount);
SET user = CURRENT_USER;
SET operation = 'INSERT';
SET changedat = now();

INSERT INTO order_log (data, user, operation, changedat)
VALUES
(order_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_after_update_order`;
DELIMITER $$
CREATE TRIGGER `TR_after_update_order` AFTER UPDATE ON `order_details` FOR EACH ROW BEGIN

DECLARE order_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET order_data  = CONCAT_WS(', ', new.order_id, new.item, new.quantity, new.item_id, new.user_id, new.date, new.amount);
SET user = CURRENT_USER;
SET operation = 'UPDATE';
SET changedat = now();

INSERT INTO order_log (data, user, operation, changedat)
VALUES
(order_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_before_delete_order`;
DELIMITER $$
CREATE TRIGGER `TR_before_delete_order` BEFORE DELETE ON `order_details` FOR EACH ROW BEGIN

DECLARE order_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET order_data  = CONCAT_WS(', ', old.order_id, old.item, old.quantity, old.item_id, old.user_id, old.date, old.amount);
SET user = CURRENT_USER;
SET operation = 'DELETE';
SET changedat = now();

INSERT INTO order_log (data, user, operation, changedat)
VALUES
(order_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_update_inventory`;
DELIMITER $$
CREATE TRIGGER `TR_update_inventory` AFTER INSERT ON `order_details` FOR EACH ROW BEGIN

    UPDATE Inventory
    SET quantity = quantity - NEW.quantity 
    WHERE item_id = New.item_id;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_update_inventory_delete_order`;
DELIMITER $$
CREATE TRIGGER `TR_update_inventory_delete_order` BEFORE DELETE ON `order_details` FOR EACH ROW BEGIN

    UPDATE Inventory
    SET quantity = quantity + old.quantity 
    WHERE item_id = old.item_id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_log`
--

DROP TABLE IF EXISTS `order_log`;
CREATE TABLE IF NOT EXISTS `order_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `operation` varchar(7) DEFAULT NULL,
  `changedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_log`
--

INSERT INTO `order_log` (`id`, `data`, `user`, `operation`, `changedat`) VALUES
(1, 'OD/01, Cake, 3, P004, U001, 2021-06-30 13:49:04, 450', 'root@localhost', 'INSERT', '2021-06-30 13:49:04'),
(2, 'OD/02, Yogurt, 5, P005, U001, 2021-06-30 13:49:41, 225', 'root@localhost', 'INSERT', '2021-06-30 13:49:41'),
(3, 'OD/03, Chocolate, 2, P001, U002, 2021-06-30 13:49:41, 210', 'root@localhost', 'INSERT', '2021-06-30 13:49:41'),
(4, 'OD/04, Biscuit, 3, P002, U002, 2021-06-30 13:50:37, 180', 'root@localhost', 'INSERT', '2021-06-30 13:50:37'),
(5, 'OD/05, Kottu, 4, P006, U003, 2021-06-30 14:16:12, 480', 'root@localhost', 'INSERT', '2021-06-30 14:16:12'),
(6, 'OD/05, Kottu, 4, P006, U003, 2021-06-30 14:16:12, 480', 'root@localhost', 'DELETE', '2021-06-30 14:17:18'),
(7, 'OD/05, Yogurt, 2, P005, U007, 2021-07-05 02:25:32, 90', 'root@localhost', 'INSERT', '2021-07-05 02:25:32'),
(8, 'OD/05, Yogurt, 2, P005, U007, 2021-07-05 02:25:32, 90', 'root@localhost', 'DELETE', '2021-07-05 02:31:20'),
(9, 'OD/05, Yogurt, 2, P005, U007, 2021-07-05 02:39:33, 90', 'root@localhost', 'INSERT', '2021-07-05 02:39:33');

-- --------------------------------------------------------

--
-- Stand-in structure for view `staff_details`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `staff_details`;
CREATE TABLE IF NOT EXISTS `staff_details` (
`Registration_no` char(6)
,`Lecturer_name` varchar(50)
,`email` varchar(50)
,`contact_no` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `student_details`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `student_details`;
CREATE TABLE IF NOT EXISTS `student_details` (
`Registration_no` char(6)
,`student_name` varchar(50)
,`email` varchar(50)
,`contact_no` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE IF NOT EXISTS `transaction` (
  `t_id` char(6) NOT NULL,
  `order_id` char(6) NOT NULL,
  `total_amount` decimal(6,2) NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`t_id`),
  KEY `order_no` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`t_id`, `order_id`, `total_amount`, `date`) VALUES
('T001', 'OD/01', '450.00', '2021-06-30'),
('T002', 'OD/02', '225.00', '2021-06-30'),
('T003', 'OD/03', '210.00', '2021-06-30'),
('T004', 'OD/04', '180.00', '2021-06-30');

-- --------------------------------------------------------

--
-- Table structure for table `transactions_summary`
--

DROP TABLE IF EXISTS `transactions_summary`;
CREATE TABLE IF NOT EXISTS `transactions_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions_summary`
--

INSERT INTO `transactions_summary` (`id`, `date`, `amount`, `count`) VALUES
(1, '2021-06-30', 1065, 4);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` char(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `mobile` int(11) NOT NULL,
  `role` varchar(10) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `email`, `password`, `mobile`, `role`) VALUES
('U001', 'Jithmi', 'jithmi@gmail.com', 'jithmi', 781234568, 'Admin'),
('U002', 'Dasunika', 'dasunika@gmail.com', 'dasu123', 751234568, 'Staff'),
('U003', 'Isanka', 'isanka@gmail.com', 'isanka', 715234568, 'Staff');

--
-- Triggers `user`
--
DROP TRIGGER IF EXISTS `TR_after_insert_user`;
DELIMITER $$
CREATE TRIGGER `TR_after_insert_user` AFTER INSERT ON `user` FOR EACH ROW BEGIN

DECLARE user_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET user_data  = CONCAT_WS(', ', new.user_id, new.name, new.email, new.password, new.mobile, new.role);
SET user = CURRENT_USER;
SET operation = 'INSERT';
SET changedat = now();

INSERT INTO user_log (data, user, operation, changedat)
VALUES
(user_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_after_update_user`;
DELIMITER $$
CREATE TRIGGER `TR_after_update_user` AFTER UPDATE ON `user` FOR EACH ROW BEGIN

DECLARE user_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET user_data  = CONCAT_WS(', ', new.user_id, new.name, new.email, new.password, new.mobile, new.role);
SET user = CURRENT_USER;
SET operation = 'UPDATE';
SET changedat = now();

INSERT INTO user_log (data, user, operation, changedat)
VALUES
(user_data, user, operation, changedat);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `TR_before_delete_user`;
DELIMITER $$
CREATE TRIGGER `TR_before_delete_user` BEFORE DELETE ON `user` FOR EACH ROW BEGIN

DECLARE user_data VARCHAR(100);
DECLARE user VARCHAR(20);
DECLARE operation VARCHAR(10);
DECLARE changedat DATETIME;

SET user_data  = CONCAT_WS(', ', old.user_id, old.name, old.email, old.password, old.mobile, old.role);
SET user = CURRENT_USER;
SET operation = 'DELETE';
SET changedat = now();

INSERT INTO user_log (data, user, operation, changedat)
VALUES
(user_data, user, operation, changedat);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `users_view_by_admin`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `users_view_by_admin`;
CREATE TABLE IF NOT EXISTS `users_view_by_admin` (
`user_id` char(6)
,`name` varchar(50)
,`email` varchar(50)
,`mobile` int(11)
,`role` varchar(10)
);

-- --------------------------------------------------------

--
-- Table structure for table `user_log`
--

DROP TABLE IF EXISTS `user_log`;
CREATE TABLE IF NOT EXISTS `user_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `operation` varchar(7) DEFAULT NULL,
  `changedat` datetime DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_log`
--

INSERT INTO `user_log` (`id`, `data`, `user`, `operation`, `changedat`, `date`) VALUES
(1, 'U001, Jithmi, jithmi@gmail.com, jithmi, 781234568, Student', 'root@localhost', 'INSERT', '2021-06-30 13:09:39', NULL),
(2, 'U002, Dasunika, dasunika@gmail.com, dasu, 751234568, Staff', 'root@localhost', 'INSERT', '2021-06-30 13:09:39', NULL),
(3, 'U003, Isanka, isanka@gmail.com, isanka, 715234568, Staff', 'root@localhost', 'INSERT', '2021-06-30 13:09:39', NULL),
(4, 'U004, Ishara, ishara@gmail.com, ishara, 771234568, Student', 'root@localhost', 'INSERT', '2021-06-30 13:09:39', NULL),
(5, 'U002, Dasunika, dasunika@gmail.com, dasu123, 751234568, Staff', 'root@localhost', 'UPDATE', '2021-06-30 13:11:10', NULL),
(6, 'U005, Kalpa, kalpa@gmail.com, kalpa, 721345678, Staff', 'root@localhost', 'INSERT', '2021-06-30 13:13:12', NULL),
(7, 'U005, Kalpa, kalpa@gmail.com, kalpa, 721345678, Staff', 'root@localhost', 'DELETE', '2021-06-30 13:13:32', NULL),
(8, 'U007, jithmi, jithmi@gmail.com, 123, 1234567890, Student', 'root@localhost', 'INSERT', '2021-07-04 13:05:31', NULL),
(9, 'U001, Jithmi, jithmi@gmail.com, jithmi, 781234568, Amin', 'root@localhost', 'UPDATE', '2021-07-04 13:34:40', NULL),
(10, 'U001, Jithmi, jithmi@gmail.com, jithmi, 781234568, Admin', 'root@localhost', 'UPDATE', '2021-07-04 13:39:22', NULL),
(11, 'U007, jithmi, jithmi@gmail.com, 123, 1234567890, Student', 'root@localhost', 'DELETE', '2021-07-05 23:57:19', NULL),
(12, 'U005, Kalpa, kalpa@gmail.com, kalpa, 987654321, Admin', 'root@localhost', 'INSERT', '2021-07-06 00:09:33', NULL),
(13, 'U005, Kalpa, kalpa@gmail.com, kalpa, 987654321, Admin', 'root@localhost', 'DELETE', '2021-07-06 03:12:12', NULL),
(14, 'U004, Ishara, ishara@gmail.com, ishara, 771234568, Student', 'root@localhost', 'DELETE', '2021-07-06 03:16:31', NULL);

-- --------------------------------------------------------

--
-- Structure for view `admin_view`
--
DROP TABLE IF EXISTS `admin_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `admin_view`  AS  select `o`.`order_id` AS `order_id`,`i`.`unit_price` AS `unit_price`,`o`.`quantity` AS `quantity`,`o`.`item_id` AS `item_id`,`o`.`date` AS `date`,(`i`.`unit_price` * `o`.`quantity`) AS `total_amount` from (`order_details` `o` join `item` `i`) where (`i`.`item_id` = `o`.`item_id`) ;

-- --------------------------------------------------------

--
-- Structure for view `item_view`
--
DROP TABLE IF EXISTS `item_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `item_view`  AS  select `item`.`item_id` AS `ID`,`item`.`item_type` AS `Type`,`item`.`name` AS `Name`,`item`.`unit_price` AS `Unit Price`,`item`.`mfd_date` AS `Mfd_date`,`item`.`exp_date` AS `Exp_date` from `item` ;

-- --------------------------------------------------------

--
-- Structure for view `staff_details`
--
DROP TABLE IF EXISTS `staff_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `staff_details`  AS  select `user`.`user_id` AS `Registration_no`,`user`.`name` AS `Lecturer_name`,`user`.`email` AS `email`,`user`.`mobile` AS `contact_no` from `user` where (`user`.`role` = 'Staff') order by `user`.`user_id` ;

-- --------------------------------------------------------

--
-- Structure for view `student_details`
--
DROP TABLE IF EXISTS `student_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `student_details`  AS  select `user`.`user_id` AS `Registration_no`,`user`.`name` AS `student_name`,`user`.`email` AS `email`,`user`.`mobile` AS `contact_no` from `user` where (`user`.`role` = 'Student') order by `user`.`user_id` ;

-- --------------------------------------------------------

--
-- Structure for view `users_view_by_admin`
--
DROP TABLE IF EXISTS `users_view_by_admin`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `users_view_by_admin`  AS  select `user`.`user_id` AS `user_id`,`user`.`name` AS `name`,`user`.`email` AS `email`,`user`.`mobile` AS `mobile`,`user`.`role` AS `role` from `user` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
