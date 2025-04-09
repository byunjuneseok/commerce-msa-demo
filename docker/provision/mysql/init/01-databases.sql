CREATE DATABASE IF NOT EXISTS `inventory`;
CREATE DATABASE IF NOT EXISTS `order`;

CREATE USER 'inventory'@'%' IDENTIFIED BY 'inventory';
GRANT ALL PRIVILEGES ON `inventory`.* TO 'inventory'@'%';

CREATE USER 'order'@'%' IDENTIFIED BY 'order';
GRANT ALL PRIVILEGES ON `order`.* TO 'order'@'%';
