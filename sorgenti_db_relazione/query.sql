/*
 mostra_nome, cognome e le certificazioni possedute dai coach
*/
select t.nome,t.cognome,c1.id_livello as `certif. livel 1`,c2.id_livello as `certif. livel 2`,
c3.id_livello as `certif. livel 3`,c4.id_livello as `certif. livel 4`
from coach as t LEFT OUTER JOIN co_ce as c1
on t.e_mail=c1.e_mail and c1.id_livello='cf-l1'
LEFT OUTER JOIN co_ce AS c2
ON t.e_mail=c2.e_mail and c2.id_livello='cf-l2'
LEFT OUTER join co_ce AS c3
ON t.e_mail=c3.e_mail and c3.id_livello='cf-l3'
LEFT OUTER JOIN co_ce AS c4
ON t.e_mail=c4.e_mail AND c4.id_livello='cf-l4';

/*
vogliamo sapere nome, cognome, sesso dei coach di un certo team
*/
SELECT nome,cognome,sesso
FROM coach
WHERE nome_team='team01';

/*
vogliamo sapere quanti sponsor possiedono i team e la somma delle quote investite dai sponsor per questi team.
*/
SELECT nome_team AS `Nome team`, count(nome) AS `Numero sponsor`, sum(quota_versata) AS `Budget Totale`
FROM sponsor
GROUP BY nome_team;

/*
vogliamo sapere quali stati si sono reggistrati nella competizione e per ogni stato vogliamo sapere quanti gruppi
lo rappresentano e la media dell'eta' che li compone.
*/
SELECT num_state.stato,num_state.`team per stato`,avg_age.`eta' media`
FROM (select stato,count(stato) as `team per stato`
	from team group by stato) AS num_state
INNER JOIN
	(SELECT stato, avg(date_format(from_days(datediff(now(),atleta.data_nascita)),'%Y')+0) AS `eta' media`
	FROM team,atleta
	WHERE atleta.nome_team=team.nome group by team.stato) AS avg_age
ON num_state.stato=avg_age.stato;

/*
vogliamo determinare la media delle quote investite dagli sponsor e in base alla media vogliamo determinare
quali team si sono aggiudicati i sponsor che hanno investito con una quota maggiore o uguale alla media e
quale stato rappresenta il team
*/
SELECT nome_team AS 'Nome team', quota_versata AS 'Budget', t.stato
FROM (select avg(quota_versata) AS 'media' from sponsor) AS sm INNER JOIN sponsor AS st
ON st.quota_versata >= sm.media
INNER JOIN team AS t
ON st.nome_team = t.nome;

/*
seleziona il numero complessivo di spettatori per ogni box per avere l'affluenza avuta nella struttura.
*/
select nome_box as 'Nome box' ,count(nome_box) as 'Spettatori'
FROM bo_pe
GROUP BY nome_box;

/*
vogliamo determinare la classifica parziale di un determinato wod per un certo stato e vogliamo anche sapere
il nome e il cognome del giudice che ha assegnato il punteggio.
*/
SELECT te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.id_wod,te_gi_wo.punteggio,giudice.nome,giudice.cognome,team.stato
FROM te_gi_wo INNER JOIN team
ON te_gi_wo.nome_team = team.nome
INNER JOIN giudice
ON te_gi_wo.id_giudice = giudice.id_giudice
WHERE team.stato = 'italy' AND te_gi_wo.id_wod='2rfupf2bhl' ORDER BY te_gi_wo.punteggio DESC;

/*
come la query precedente ma vogliamo ottenere il risultato per ogni stato che ha partecipa al wod specifico
*/
SELECT te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.id_wod,te_gi_wo.punteggio,giudice.nome,giudice.cognome,team.stato
FROM te_gi_wo INNER JOIN team
ON te_gi_wo.nome_team = team.nome
INNER JOIN giudice
ON te_gi_wo.id_giudice = giudice.id_giudice
WHERE te_gi_wo.id_wod='2rfupf2bhl' ORDER BY te_gi_wo.punteggio DESC;

/*
vogliamo ottenere una classifica suddivisa per wod e per ogni wod vogliamo ricavare il nome del team la data di esecuzione
il punteggio ottenuto nome e cognome del giudice e lo stato che rappresenta il team.
*/
SELECT te_gi_wo.id_wod,te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.punteggio,giudice.nome,giudice.cognome,team.stato
FROM te_gi_wo INNER JOIN team
ON te_gi_wo.nome_team = team.nome
INNER JOIN giudice
ON te_gi_wo.id_giudice = giudice.id_giudice
INNER JOIN wod
ON te_gi_wo.id_wod=wod.id_wod ORDER BY te_gi_wo.id_wod,te_gi_wo.punteggio DESC;

/*
vogliamo avere la classifica generale al termine della competizione e i dati che vogliamo ottenere sono il nome del team il numero di wod
eseguit e il numoro di wod mancanti il punteggio realizzato sara calcolato in base alla somma dei punteggi ottenuti nei singoli wod meno
il numero di wod non eseguiti, infine vogliamo sapere di che stato fa parte il team.
*/
SELECT te_gi_wo.nome_team,count(id_wod) AS `Wod eseguiti`,num_wod.nw-count(id_wod) AS `Wod mancanti`,
sum(punteggio)-(num_wod.nw-count(id_wod)) AS `Punteggio`,team.stato
FROM te_gi_wo INNER JOIN team
ON te_gi_wo.nome_team=team.nome
INNER JOIN (SELECT count(id_wod) AS nw FROM wod) AS num_wod
GROUP BY te_gi_wo.nome_team ORDER BY `Punteggio` DESC;

/*
dato il nome e il cognome di un giudice vogliamo sapere quali team ha giudicato in che data e che punteggio gli e' stato
assegnato e il nome del box in cui si e' eseguito il wod.
*/
SELECT te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.punteggio,wod.nome_box
FROM giudice INNER JOIN te_gi_wo
ON giudice.id_giudice=te_gi_wo.id_giudice
INNER JOIN wod
ON te_gi_wo.id_wod=wod.id_wod
WHERE giudice.nome='Jutta' AND giudice.cognome='Dezell';

/*
vogliamo selezionare il nome dei team il nome degli sponsor a loro associati, nome e cognome del giudice che li ha giudicati e il box dove
hanno eseguito il wod. Di questi vogliamo solo i dati di quei team che hanno due coach di sesso femminile e che la data di nascita dei
giudici siano coprese in un certo intervallo di date e che siano di sesso femminile
*/
SELECT te_gi_wo.id_wod,te_gi_wo.nome_team,sponsor.nome AS `sponsor`,giudice.nome,giudice.cognome,giudice.data_nascita,wod.nome_box
FROM (select nome_team,count(*) as `nc` from coach where sesso='f' group by nome_team having `nc`=2) AS tb1
INNER JOIN te_gi_wo
ON tb1.nome_team=te_gi_wo.nome_team
INNER JOIN giudice
ON te_gi_wo.id_giudice=giudice.id_giudice
INNER JOIN sponsor
ON sponsor.nome_team=te_gi_wo.nome_team
INNER JOIN wod
ON te_gi_wo.id_wod=wod.id_wod
WHERE giudice.data_nascita between '1980-01-01' AND '1990-12-31' AND giudice.sesso='f' GROUP BY te_gi_wo.nome_team;

/*
si vuole sapere l'eta' media maschile e femminile di quei gruppi che hanno partecipato in un determinato wod
*/
SELECT te_gi_wo.id_wod AS `Id wod`, te_gi_wo.nome_team AS `Nome team`, atleta.sesso AS `Sesso`,
avg(date_format(from_days(datediff(now(),atleta.data_nascita)),'%Y')+0) AS `Media eta'`
FROM atleta INNER JOIN te_gi_wo
ON atleta.nome_team=te_gi_wo.nome_team
WHERE te_gi_wo.id_wod='7m1ive554u' GROUP BY `Nome team`,`Sesso`;

/*
seleziona nome del team, nome e cognome dell'atleta il quale ha il nome che inizia con M e termina con k e il cognome che iniza con B
e termina con r che ha svolto una competizione dove il nome del giudice inizia con E e termina con o e il cognome inizia con R e termina
con y. inoltre vogliamo sapere in che box e' stata svolta la competizione.
*/
SELECT te_gi_wo.nome_team,atleta.nome AS `Atleta: Nome`,atleta.cognome AS `Atleta: cognome`, box.nome_box AS `Nome box`
FROM atleta INNER JOIN te_gi_wo
ON atleta.nome_team=te_gi_wo.nome_team
INNER JOIN giudice
ON te_gi_wo.id_giudice=giudice.id_giudice
INNER JOIN wod
ON te_gi_wo.id_wod=wod.id_wod
INNER JOIN box
ON wod.nome_box=box.nome_box
 WHERE atleta.nome LIKE 'M%k' AND atleta.cognome LIKE 'B%r' AND giudice.nome LIKE 'E%o' AND giudice.cognome LIKE 'R%y';

/*
seleziona i nomi dei team l'id dei wod e il nome dell'esercizio dei wod che contengono esercizi con un determinato
numero di ripetizioni e di quei team che hanno uno o piu coach con una certificazione di livello 4
*/
SELECT te_gi_wo.nome_team,wo_es.id_wod,wo_es.nome_esercizio
FROM wo_es INNER JOIN te_gi_wo
ON wo_es.id_wod=te_gi_wo.id_wod
INNER JOIN coach
ON te_gi_wo.nome_team=coach.nome_team
INNER JOIN co_ce
ON coach.e_mail = co_ce.e_mail
WHERE wo_es.ripetizioni=15 AND co_ce.id_livello='cf-l4';

/*
fornita una data di una competizione vogliamo sapere chi era presente come spettatore ottenendo il nome e il cognome e i nomi dei team
che hanno visto gareggiare
*/
SELECT persona.nome, persona.cognome, te_gi_wo.nome_team
FROM te_gi_wo INNER JOIN bo_pe
ON bo_pe.data_presenza=te_gi_wo.data_esecuzione
INNER JOIN persona
ON bo_pe.codice_fiscale=persona.codice_fiscale
WHERE te_gi_wo.data_esecuzione='2015-08-28';

/*
vogliamo sapere il nome e il cognome di tutti gli spettatori di un determinato team e il nome dei box in cui hanno
seguito il team
*/
SELECT persona.nome, persona.cognome, wod.nome_box,wod.id_wod
FROM te_gi_wo,wod,bo_pe,persona
WHERE te_gi_wo.id_wod=wod.id_wod AND wod.nome_box=bo_pe.nome_box AND bo_pe.codice_fiscale=persona.codice_fiscale AND te_gi_wo.nome_team='team10' GROUP BY nome,cognome;

/*
selezionare tutte le persone che hanno fatto da spettatori con lo stesso nome di un giudice e di queste persone vogliamo sapere dove hanno fatto
da spettatori e in che data
*/
SELECT distinct  p1.nome AS `Nome`, p1.cognome AS `Cognome`, bo_pe.nome_box AS `Nome box`,te_gi_wo.data_esecuzione AS `Data partecipazione`
FROM persona AS p1, giudice AS p2,bo_pe,box,wod,te_gi_wo
WHERE p1.nome=p2.nome AND p1.cognome!=p2.cognome AND p1.codice_fiscale=bo_pe.codice_fiscale AND bo_pe.nome_box=box.nome_box
AND wod.nome_box=box.nome_box AND wod.id_wod=te_gi_wo.id_wod;