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
    score INT(11) NOT NULL,
    avatarID INT(11) NOT NULL
);

INSERT INTO Player (username, password, coins, score, avatarID)
	VALUES ('TROJANWARRIOR', 'pw', 5000, 12536, 4),
			('NIGHTKNIGHT', 'pw', 2000, 11401, 3),
            ('BETA3223', 'pw', 1500, 11193, 3),
            ('CSMONKEY', 'pw', 1249, 10087, 2),
            ('SOCALNINJA', 'pw', 1500, 9998, 3),
            ('TUMBLETANK', 'pw', 10000, 9994, 2),
            ('TESLAMODELV', 'pw', 900, 9878, 4),
            ('HIGHERSCORE', 'pw', 1200, 8901, 1),
            ('SAMURAISISTER', 'pw', 575, 8674, 2),
            ('Jeffery Miller PhD', 'pw', 9999, 999999, 1);
    
CREATE TABLE Ranking (
	rankID INT(11) PRIMARY KEY AUTO_INCREMENT,
    playerID INT(11) NOT NULL,
    FOREIGN KEY (playerID) REFERENCES Player(playerID)
);

INSERT INTO Ranking (playerID)
	VALUES (1),
			(2),
            (3),
            (4),
            (5),
            (6),
            (7),
            (8),
            (9),
            (10);
CREATE TABLE Purchased (
	purchaseID INT(11) PRIMARY KEY AUTO_INCREMENT,
    playerID INT(11) NOT NULL,
    hasSoldier INT(11) NOT NULL,
    hasViking INT(11) NOT NULL,
    hasSamurai INT(11) NOT NULL,
    FOREIGN KEY (playerID) REFERENCES Player(playerID)
);

INSERT INTO Purchased(playerID, hasSoldier, hasViking, hasSamurai)
	VALUES (1, 1, 1, 1),
			(2, 1, 1, 1),
            (3, 1, 1, 0),
            (4, 1, 1, 1),
            (5, 1, 1, 0),
            (6, 1, 0, 0),
            (7, 1, 1, 0),
            (8, 1, 0, 1),
            (9, 1, 0, 0),
            (10, 0, 0, 0);