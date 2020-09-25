`user_seatmap``user`CREATE DATABASE seatmap_management



USE `seatmap_management`;

CREATE TABLE `admin` (
`id` INT(10) NOT NULL,
`username` VARCHAR (100) NOT NULL,
`password` VARCHAR (100) NOT NULL 
) ENGINE=INNODB DEFAULT  CHARSET=latin1;

ALTER TABLE `admin` ADD PRIMARY KEY (`id`)

CREATE TABLE `user` (
`id` INT(10) NOT NULL,
`username` VARCHAR (100) NOT NULL,
`email` VARCHAR (100) ,
`avatar` VARCHAR(100) NOT NULL,
`status` ENUM ('active','inactive') DEFAULT 'active',
`create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`update_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=INNODB DEFAULT  CHARSET=latin1;

DROP TABLE `user`
ALTER TABLE `user` ADD PRIMARY KEY (`id`)

CREATE TABLE `seatmap` (
`id` INT(10) NOT NULL,
`name` VARCHAR (100) NOT NULL,
`filename` VARCHAR (100) NOT NULL,
`create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`update_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=INNODB DEFAULT  CHARSET=latin1;

ALTER TABLE `seatmap` ADD PRIMARY KEY (`id`)


CREATE TABLE `user_seatmap` (
`id` INT(10) NOT NULL,
`id_user` INT (10) NOT NULL,
`id_seatmap` INT (10) NOT NULL,
`coordinate_x` FLOAT NOT NULL,
`coordinate_y` FLOAT NOT NULL,
`create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`update_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=INNODB DEFAULT  CHARSET=latin1;

ALTER TABLE `user_seatmap` ADD PRIMARY KEY (`id`);


ALTER TABLE user_seatmap ADD FOREIGN KEY (id_user) REFERENCES `user`(id) ON DELETE CASCADE;
ALTER TABLE user_seatmap ADD FOREIGN KEY (id_seatmap) REFERENCES seatmap(id) ON DELETE CASCADE;

ALTER TABLE `user` MODIFY `id` INT(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `seatmap` MODIFY `id` INT(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_seatmap` MODIFY `id` INT(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `seatmap` MODIFY `create_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;




DROP TABLE `user`;
DROP TABLE `seatmap`;
DROP TABLE `user_seatmap`;
ALTER TABLE user_seatmap DROP FOREIGN KEY user_seatmap_ibfk_1 ;
ALTER TABLE user_seatmap DROP FOREIGN KEY user_seatmap_ibfk_2 ;




INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user1','user1@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user2','user2@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user3','user3@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user4','user4@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user5','user5@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user6','user6@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user7','user7@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user8','user8@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user9','user9@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user10','user10@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user11','user11@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user12','user12@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user13','user13@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user14','user14@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user15','user15@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user16','user16@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user17','user17@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user18','user18@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user19','user19@gmail.com','upload/Thank-you.jpg');
INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('user20','user20@gmail.com','upload/Thank-you.jpg');


INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 1','seatmap/seatmap1.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 2','seatmap/seatmap2.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 3','seatmap/seatmap1.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 4','seatmap/seatmap2.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 5','seatmap/seatmap1.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 6','seatmap/seatmap2.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 7','seatmap/seatmap1.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 8','seatmap/seatmap2.png');
INSERT INTO `seatmap`( `name`, `filename`)VALUES ('seat-map 9','seatmap/seatmap1.png');

INSERT INTO `admin` (`id`,`username`, `password`) VALUES (1,'admin', '21232f297a57a5a743894a0e4a801fc3')
INSERT INTO `user_seatmap`( `id_user`, `id_seatmap`,`coordinate_x`, `coordinate_y`)VALUES (4,1,369, 92.640625);
INSERT INTO `user_seatmap`( `id_user`, `id_seatmap`,`coordinate_x`, `coordinate_y`)VALUES (5,1,807, 69.640625);


SELECT * FROM `user_seatmap`
SELECT * FROM `seatmap`
SELECT * FROM `user`
SELECT * FROM `admin`


SELECT `user`.id, `user`.username, `user`.avatar FROM `user`  LEFT JOIN  `user_seatmap` ON `user_seatmap`.id_user = `user`.id WHERE `user_seatmap`.id_user IS NULL AND `user`.status = 'active'
SELECT * FROM `user`  JOIN `user_seatmap` WHERE `user`.id = `user_seatmap`.id_user AND `user_seatmap`.id_seatmap =1
SELECT COUNT(id_user) AS `count` FROM `user_seatmap` WHERE  `user_seatmap`.id_user = 4 AND `user_seatmap`.id_seatmap=1
SELECT COUNT(id) AS `count` FROM `user`

SELECT * FROM `user` LIMIT 10,20
SELECT * FROM `user` LIMIT 10
 
