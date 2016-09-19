DELIMITER //
-- Nome: load_spettatori
-- Parametri: num_tentativi = numero di tentativi effettuati per inserire una tupla che identifica uno spettatore di un box
CREATE PROCEDURE load_bo_pe(
	 IN num_tentativi INTEGER
) COMMENT 'riempie la relazione bo_pe in modo random'
BEGIN
--	dichiara una variabile per il nome del box
	DECLARE boxn VARCHAR(255);
--	dichiara una variable per il codice fiscale dello spetatore
	DECLARE cf VARCHAR(255);
	DECLARE data_p DATE;
--	dichiara una variabile che fara da contatore e questa viene settata a 1
	DECLARE count INT;
	SET count = 1;
--	il ciclo e' utilizzato per riempire la relazione bo_pe in modo random
--	inserendo un certo numero di tuple che rappresentano gli spettatori di un box
	WHILE count <= num_tentativi DO
--		seleziona un nome radom di un box e lo assegna a boxn
		SELECT nome_box
		from box
		ORDER BY rand() LIMIT 1
		INTO boxn;
--		seleziona un cdodice fiscale random di una persona e lo assegna a cf
		SELECT codice_fiscale
		FROM persona
		ORDER BY rand() LIMIT 1
		INTO cf;
--		seleziona una data random di una competizione e l'assegna a data_p
		SELECT data_esecuzione
		FROM te_gi_wo
		ORDER BY rand() LIMIT 1
		INTO data_p;
--		inserisce i dati recuperati nella relazione bo_pe
		INSERT IGNORE INTO bo_pe (nome_box, codice_fiscale, data_presenza) VALUES (boxn, cf, data_p);
--		incrementa la variabile contatore
		SET count = count + 1;
	END WHILE;
END //
DELIMITER ;



DELIMITER //
-- Nome: load_esecuzione
-- Parametri: num_tentativi = numero di tentativi effettuati per inserire una tupla che identifica l'esecuzione di un wod
CREATE PROCEDURE load_esecuzione(
	IN num_tentativi INTEGER
)COMMENT 'riempie la relazione te_gi_wo in modo random'
BEGIN
--	variabili utilizzate per memorizzare i dati recuperati in modo random
--
--	usata per il nome del team
	DECLARE nome_t VARCHAR(255);
--	usata per l'id del giudice
	DECLARE id_g VARCHAR(255);
--	usata per l'id del wod
	DECLARE id_w VARCHAR(255);
--	usata per la data di pubblicazione del wod
	DECLARE d_pub DATE;
--	usata per la data di termine del wod
	DECLARE d_term DATE;
--	usata per memorizzare una data ricavata da un'intervallo di date
	DECLARE d_ins DATE;
--	usata per mmemorizzare il punteggio ricavato random
	DECLARE score INT;
--	variabile contatore
	DECLARE count INT;
--	usata per memorizzare il punteggio minimo
	DECLARE min_score INT;
--	usata per memorizzare il punteggio massimo
	DECLARE max_score INT;
--	imposta il punteggio minimo assegnabile
	SET min_score = 0;
--	imposta il punteggio massimo assegnabile
	SET max_score = 100;
--	inizializza il contatore
	SET count = 1;

--	il ciclo viene effettuato fintanto che il valore di count non e' uguale a num_tentativi, mentre nel corpo del while si
--	recuperano dei dati in modo random, quali: nome, id_giudice, id_wod, data_pubblicazione, data_termine e viene generata
--	una data random compresa tra data_publicazione e data_termine, questa data identifica il giorno in cui il team esegue il
--	wod, infine viene inserita una tupla nella relazione te_gi_wo con i dati recuperati e la data generata.
	WHILE count <= num_tentativi DO

		SELECT nome INTO nome_t from team ORDER BY RAND() LIMIT 1;
		SELECT id_giudice INTO id_g FROM giudice ORDER BY RAND() LIMIT 1;
		SELECT id_wod INTO id_w FROM wod ORDER BY RAND() LIMIT 1;
		SELECT data_pubblicazione INTO d_pub FROM wod WHERE  id_wod = id_w;
		SELECT data_termine INTO d_term FROM wod WHERE id_wod = id_w;

		SELECT FROM_DAYS(floor(TO_DAYS(d_pub)+rand()*(TO_DAYS(d_term)-TO_DAYS(d_pub)))) INTO d_ins;
		SELECT FLOOR(min_score + rand() * (max_score - min_score)) INTO score;

		INSERT IGNORE INTO te_gi_wo(id_giudice, id_wod, data_esecuzione, nome_team, punteggio) VALUES (id_g, id_w, d_ins, nome_t, score);

		SET count = count + 1;

	END WHILE;
END //
DELIMITER ;


DELIMITER //
-- Nome: load_co_ce
-- Parametri: nessun parametro
CREATE PROCEDURE load_co_ce(
)COMMENT 'riempie la relazione co_ce in modo random'
BEGIN
-- variabile per memorizzare la mail del coach
DECLARE mail VARCHAR(255);
-- variabile per contenere un valore numerico intero
DECLARE rand_cert INT;
-- variabile booleana per verificare lo stato di una condizione
DECLARE done BOOLEAN DEFAULT 0;
-- dichiarazione di un cursore sulla tabella coach
DECLARE tmpcoach CURSOR FOR SELECT e_mail FROM coach;
-- dichiara un handler che intercetta lo stato di errore 02000 e setta
-- la variabile booleana done a 1
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;
-- apre il cursore creato in precedenza
OPEN tmpcoach;
-- qui viene ripetuto il codice tra repeat e end repeat fintanto che l'handler
-- non intercetta lo stato di errore o vero non ci sono piu record da scorrere
-- nella tabella coach tramite il cursore.
-- per ogni coach recuperato gli si assegna random un certo numero di certificazioni.
REPEAT
FETCH tmpcoach INTO mail;

SELECT FLOOR(1 + RAND()*4) INTO rand_cert;
		IF rand_cert = 1 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l1");
		END IF;

		IF rand_cert = 2 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l2");
		END IF;
		IF rand_cert = 3 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l2");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l3");
		END IF;
		IF rand_cert = 4 THEN
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l1");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l2");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l3");
			INSERT INTO co_ce (e_mail, id_livello) VALUES (mail, "cf-l4");
		END IF;

UNTIL done END REPEAT;
-- chiude il cursore
CLOSE tmpcoach;
END //
DELIMITER ;