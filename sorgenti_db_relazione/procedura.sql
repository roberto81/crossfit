DELIMITER //
-- Nome: loaddb
-- Parametri: num_tentativi = numero di tentativi effettuati per inserire i dati generati nelle entita' atleta,team, coach.
CREATE PROCEDURE loaddb(
	 IN numtentativi INTEGER
) COMMENT 'carica database'
BEGIN
	DECLARE dinizio DATE DEFAULT '2015-01-01';
	DECLARE dfine DATE DEFAULT '2015-01-14';
	DECLARE dnasinizio DATE DEFAULT '1955-01-01';
	DECLARE dnasfine DATE DEFAULT '2015-12-31';
	DECLARE dnascita DATE;
	DECLARE discrizione DATE;
	DECLARE count INT;
	DECLARE counta INT;
	DECLARE nteam VARCHAR(255);
	DECLARE stato VARCHAR(255);
	DECLARE email VARCHAR(255);
	DECLARE nome VARCHAR(255);
	DECLARE cognome VARCHAR(255);
	DECLARE ases VARCHAR(255);
	DECLARE rand_cert INTEGER;
	SET count = 1;
	SET counta = 1;

	CREATE TABLE IF NOT EXISTS stati(st VARCHAR(255));
	IF (SELECT count(*) FROM stati) = 0 THEN
		INSERT INTO stati(st) VALUES (
			'italy'),('france'),('germany'),('united kingdom'),('USA'
			);
	END IF;

	CREATE TABLE IF NOT EXISTS sesso(s ENUM('M','F'));
	IF (SELECT count(*) FROM sesso) = 0 THEN
		INSERT INTO sesso(s) VALUES ('M'),('F');
	END IF;

	WHILE count <= numtentativi DO
--		crea un team
		SELECT SUBSTR(MD5(RAND()),1,(5+RAND()*20)) INTO nteam;
		SELECT FROM_DAYS(floor(TO_DAYS(dinizio)+rand()*(TO_DAYS(dfine)-TO_DAYS(dinizio)))) INTO discrizione;
		SELECT st FROM stati ORDER BY rand() LIMIT 1 INTO stato;
		INSERT INTO team(nome,data_iscrizione,stato)VALUES(nteam,discrizione,stato);

		SELECT CONCAT(SUBSTR(MD5(RAND()),1,(5+RAND()*20)),'@',SUBSTR(MD5(RAND()),1,(5+RAND()*20)),'it') INTO email;
		SELECT SUBSTR(MD5(RAND()),1,(5+RAND()*20)) INTO nome;
		SELECT SUBSTR(MD5(RAND()),1,(5+RAND()*20)) INTO cognome;
		SELECT FROM_DAYS(floor(TO_DAYS(dnasinizio)+rand()*(TO_DAYS(dnasfine)-TO_DAYS(dnasinizio)))) INTO dnascita;
		SELECT s FROM sesso ORDER BY rand() LIMIT 1 INTO ases;
		INSERT INTO coach(e_mail,nome_team,nome,cognome,data_nascita,sesso) VALUES (
				email,nteam,nome,cognome,dnascita,ases
				);
		SELECT FLOOR(1 + RAND()*4) INTO rand_cert;
		IF rand_cert = 1 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l1");
		END IF;

		IF rand_cert = 2 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l2");
		END IF;
		IF rand_cert = 3 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l2");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l3");
		END IF;
		IF rand_cert = 4 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l2");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l3");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (email, "cf-l4");
		END IF;

		WHILE counta <= 2 DO
			SELECT CONCAT(SUBSTR(MD5(RAND()),1,(5+RAND()*20)),'@',SUBSTR(MD5(RAND()),1,(5+RAND()*20)),'it') INTO email;
			SELECT SUBSTR(MD5(RAND()),1,(5+RAND()*20)) INTO nome;
			SELECT SUBSTR(MD5(RAND()),1,(5+RAND()*20)) INTO cognome;
			SELECT FROM_DAYS(floor(TO_DAYS(dnasinizio)+rand()*(TO_DAYS(dnasfine)-TO_DAYS(dnasinizio)))) INTO dnascita;
			SELECT s FROM sesso ORDER BY rand() LIMIT 1 INTO ases;
			INSERT INTO atleta(e_mail,nome_team,nome,cognome,data_nascita,sesso) VALUES (
				email,nteam,nome,cognome,dnascita,ases
				);
			SET counta = counta + 1;
		END WHILE;
		SET count = count +1;
		SET counta = 1;
	END WHILE;
	DROP TABLE stati;
	DROP TABLE sesso;
END //
DELIMITER ;