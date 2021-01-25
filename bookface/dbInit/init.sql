/* Create database */
CREATE DATABASE IF NOT EXISTS `bookface`;

/* Create tables */
CREATE TABLE `users` (
  `uid` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(128) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `picture` LONGBLOB DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE = InnoDB CHARSET = utf8 COLLATE utf8_bin;

CREATE TABLE `posts` (
`pid` BIGINT(8) NOT NULL AUTO_INCREMENT,
`user` BIGINT(8) NOT NULL,
`title` VARCHAR(200) NOT NULL,
`content` VARCHAR(20000) NOT NULL,
PRIMARY KEY (`pid`),
FOREIGN KEY (`user`) REFERENCES users(`uid`)
) ENGINE = InnoDB CHARSET = utf8 COLLATE utf8_bin;


/* Insert data */
INSERT INTO `users` (`uid`, `email`, `password`) 
VALUES 
  ('1','testBruker1@example.com','40bcc6f6193986153cae1bb1c36668650a3d5f97'),
  ('2','testBruker2@example.net','1f66d81577cd95514cedc8504d65ec8eff9c336a'),
  ('3','testBruker3@example.com','3fcba21eebd2d09681515b4849d2bbeae566451e');

INSERT INTO `posts` 
VALUES 
  ('1','3','Test eksempelpost 1','Dette er en testpost.'),
  ('2','2','Test eksempelpost 2','Dette er en testpost.'),
  ('3','1','Test eksempelpost 3','Dette er en testpost.');
