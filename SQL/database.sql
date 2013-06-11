---  DEFAULT CHARSET=latin1

CREATE TABLE IF NOT EXISTS `admins` (
  `ckey` varchar(255) NOT NULL,
  `rank` int(1) NOT NULL,
  PRIMARY KEY  (`ckey`)
);

CREATE TABLE IF NOT EXISTS `bans` (
  `ckey` varchar(255) NOT NULL,
  `computerid` text NOT NULL,
  `ips` varchar(255) NOT NULL,
  `reason` text NOT NULL,
  `bannedby` varchar(255) NOT NULL,
  `temp` int(1) NOT NULL COMMENT '0 = perma ban / minutes banned',
  `minute` int(255) NOT NULL default '0',
  `timebanned` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`ckey`)
);

CREATE TABLE IF NOT EXISTS `booklog` (
  `ckey` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL default 'INSERT',
  `title` text NOT NULL,
  `author` varchar(256) NOT NULL,
  `text` longtext NOT NULL,
  `cat` int(11) NOT NULL
);

CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `text` longtext NOT NULL,
  `cat` int(2) NOT NULL default '1',
  PRIMARY KEY  (`id`)
);

CREATE TABLE IF NOT EXISTS `changelog` (
  `id` int(11) NOT NULL auto_increment,
  `bywho` varchar(255) NOT NULL,
  `changes` text NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
);

CREATE TABLE IF NOT EXISTS `config` (
  `motd` text NOT NULL
);

CREATE TABLE IF NOT EXISTS `jobban` (
  `ckey` varchar(255) NOT NULL,
  `rank` varchar(255) NOT NULL,
  UNIQUE KEY `NODUPES` (`ckey`(100),`rank`(100))
);

CREATE TABLE IF NOT EXISTS `jobbanlog` (
  `ckey` varchar(255) NOT NULL COMMENT 'By who',
  `targetckey` varchar(255) NOT NULL COMMENT 'Target',
  `rank` varchar(255) NOT NULL COMMENT 'rank',
  `when` timestamp NOT NULL default CURRENT_TIMESTAMP COMMENT 'when',
  `why` varchar(355) NOT NULL,
  UNIQUE KEY `targetckey` (`targetckey`(100),`rank`(100))
);

CREATE TABLE IF NOT EXISTS `medals` (
  `ckey` varchar(255) NOT NULL,
  `medal` text NOT NULL,
  `medaldesc` text NOT NULL,
  `medaldiff` text NOT NULL,
  UNIQUE KEY `NODUPES` (`ckey`,`medal`(8))
);

CREATE TABLE IF NOT EXISTS `players` (
  `ckey` varchar(255) NOT NULL,
  `slot` int(2) NOT NULL default '1',
  `slotname` varchar(255) NOT NULL default 'Default',
  `real_name` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `occupation1` varchar(255) NOT NULL,
  `occupation2` varchar(255) NOT NULL,
  `occupation3` varchar(255) NOT NULL,
  `hair_red` int(3) NOT NULL,
  `hair_green` int(3) NOT NULL,
  `hair_blue` int(3) NOT NULL,
  `ages` int(3) NOT NULL,
  `facial_red` int(3) NOT NULL,
  `facial_green` int(3) NOT NULL,
  `facial_blue` int(3) NOT NULL,
  `skin_tone` int(3) NOT NULL,
  `hair_style_name` varchar(255) NOT NULL,
  `facial_style_name` varchar(255) NOT NULL,
  `eyes_red` int(3) NOT NULL,
  `eyes_green` int(3) NOT NULL,
  `eyes_blue` int(3) NOT NULL,
  `blood_type` varchar(3) NOT NULL,
  `be_syndicate` int(3) NOT NULL,
  `underwear` int(3) NOT NULL,
  `name_is_always_random` int(3) NOT NULL,
  `bios` longtext NOT NULL,
  `show` int(1) NOT NULL default '1',
  `be_nuke_agent` tinyint(1) NOT NULL,
  `be_takeover_agent` tinyint(1) NOT NULL,
  UNIQUE KEY `ckey` (`ckey`,`slot`)
);

CREATE TABLE IF NOT EXISTS `traitorlogs` (
  `CKey` varchar(128) NOT NULL,
  `Objective` text NOT NULL,
  `Succeeded` tinyint(4) NOT NULL,
  `Spawned` text NOT NULL,
  `Occupation` varchar(128) NOT NULL,
  `PlayerCount` int(11) NOT NULL,
  KEY `CKey` (`CKey`),
  KEY `Succeeded` (`Succeeded`)
);

CREATE TABLE IF NOT EXISTS `unbans` (
  `ckey` varchar(255) NOT NULL,
  `computerid` text NOT NULL,
  `ips` varchar(255) NOT NULL,
  `reason` text NOT NULL,
  `bannedby` varchar(255) NOT NULL,
  `temp` int(255) NOT NULL COMMENT '0 = perma ban / minutes banned',
  `minutes` int(255) NOT NULL,
  `timebanned` timestamp NOT NULL default CURRENT_TIMESTAMP
);
