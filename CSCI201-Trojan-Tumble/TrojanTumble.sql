DROP DATABASE IF EXISTS game;
CREATE DATABASE game;
USE game;

CREATE TABLE Avatar ( 
	avatarID INT(11) PRIMARY KEY AUTO_INCREMENT,
    avatarName VARCHAR(40) NOT NULL
);

INSERT INTO Avatar (avatarName)
	VALUES ('Trojan'),
			('Sergeant'),
            ('Viking'),
            ('Samurai');

CREATE TABLE Player (
	playerID INT(11) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(40) NOT NULL,
    password VARCHAR(40) NOT NULL,
    coins INT(11) NOT NULL,
    highestScore INT(11) NOT NULL,
    avatarID INT(11) NOT NULL,
    FOREIGN KEY (avatarID) REFERENCES Avatar(avatarID)
);

INSERT INTO Player (username, password, coins, highestScore, avatarID)
	VALUES ();
    
CREATE TABLE Ranking (
	rankID INT(11) PRIMARY KEY AUTO_INCREMENT,
    playerID INT(11) NOT NULL,
    score INT(11) NOT NULL,
	FOREIGN KEY (score) REFERENCES Player(highestScore),
    FOREIGN KEY (playerID) REFERENCES Player(playerID)
);

INSERT INTO Player (username, password, coins, highestScore, avatarID)
	VALUES ();