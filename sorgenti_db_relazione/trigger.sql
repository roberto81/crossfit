DELIMITER //
-- Nome: data_check_atleta
--
CREATE TRIGGER data_check_atleta BEFORE INSERT ON atleta
FOR EACH ROW
BEGIN
	IF NEW.data_nascita < DATE('1997-01-01') THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = '[table:persona] - `data_nascita` data di nascita non valida.';
	END IF;

	IF NEW.e_mail NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
		SIGNAL SQLSTATE VALUE '45000'
		SET MESSAGE_TEXT = '[table:persona] - `e_mail` formato della mail non valido.';
	END IF;
END //
DELIMITER ;


DELIMITER //
-- Nome: data_check_coach
--
CREATE TRIGGER data_check_coach BEFORE INSERT ON coach
FOR EACH ROW
BEGIN
	IF NEW.data_nascita < DATE('1997-01-01') THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = '[table:persona] - `data_nascita` data di nascita non valida.';
	END IF;

	IF NEW.e_mail NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
		SIGNAL SQLSTATE VALUE '45000'
		SET MESSAGE_TEXT = '[table:persona] - `e_mail` il formato della mail non  valido.';
	END IF;
END //
DELIMITER ;

DELIMITER //
-- Nome: data_check_giudice
--
CREATE TRIGGER data_check_giudice BEFORE INSERT ON giudice
FOR EACH ROW
BEGIN
	IF NEW.data_nascita < DATE('1997-01-01') THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = '[table:persona] - `data_nascita` data di nascita non valida.';
	END IF;
END //
DELIMITER ;