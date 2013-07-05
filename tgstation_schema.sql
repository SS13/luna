CREATE TABLE IF NOT EXISTS `admins` (
  `ckey` varchar(255) NOT NULL,
  `rank` int(1) NOT NULL,
  PRIMARY KEY  (`ckey`)
);

CREATE  TABLE IF NOT EXISTS `library` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `author` TEXT NOT NULL ,
  `title` TEXT NOT NULL ,
  `content` TEXT NOT NULL ,
  `category` TEXT NOT NULL ,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET = latin1;
