SELECT  num_state.stato,num_state.`team per stato`,avg_age.`eta' media`
FROM (select stato,count(stato) as `team per stato`
	from team group by stato) AS num_state
INNER JOIN
	(SELECT /*! STRAIGHT_JOIN */ stato, avg(date_format(from_days(datediff(now(),atleta.data_nascita)),'%Y')+0) AS `eta' media`
	FROM atleta,team
	WHERE atleta.nome_team=team.nome group by team.stato) AS avg_age
ON num_state.stato=avg_age.stato;

SELECT /*! STRAIGHT_JOIN */  te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.id_wod,te_gi_wo.punteggio,giudice.nome,giudice.cognome,team.stato
FROM giudice,te_gi_wo,team
WHERE te_gi_wo.nome_team = team.nome AND te_gi_wo.id_giudice = giudice.id_giudice AND team.stato = 'italy' AND te_gi_wo.id_wod='2rfupf2bhl' ORDER BY te_gi_wo.punteggio DESC;

SELECT te_gi_wo.nome_team,te_gi_wo.data_esecuzione,te_gi_wo.punteggio,wod.nome_box
FROM giudice INNER JOIN te_gi_wo
ON giudice.id_giudice=te_gi_wo.id_giudice
INNER JOIN wod
ON te_gi_wo.id_wod=wod.id_wod
WHERE giudice.nome='Jutta' AND giudice.cognome='Dezell';