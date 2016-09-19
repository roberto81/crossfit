/*
	crea il database se questo non esiste
*/
create database if not exists crossfit2;

/*
	seleziona il database crossfit
*/
use crossfit2;

/*
	crea la tabella esercizio
*/
create table if not exists esercizio(
	nome_esercizio VARCHAR(255) NOT NULL,
	descrizione VARCHAR(255) NOT NULL,
	primary key (nome_esercizio)
) ENGINE=INNODB;

/*
	crea la tabella persona
*/
create table if not exists persona(
	codice_fiscale VARCHAR(20) NOT NULL,
	nome VARCHAR(255) NOT NULL,
	cognome VARCHAR(255) NOT NULL,
	data_nascita DATE NOT NULL,
	sesso ENUM('m','f'),
	PRIMARY KEY (codice_fiscale)
) ENGINE=INNODB;

/*
	crea la tabella box
*/
create table if not exists box(
	nome_box VARCHAR(255) NOT NULL,
	stato VARCHAR(255) NOT NULL,
	PRIMARY KEY (nome_box)
) ENGINE=INNODB;

/*
	crea la tabella BO_PE questa e' una relaione
*/
create table if not exists bo_pe(
	nome_box VARCHAR(255) NOT NULL,
	codice_fiscale VARCHAR(255) NOT NULL,
	data_presenza DATE NOT NULL,
	FOREIGN KEY (nome_box) REFERENCES box(nome_box),
	FOREIGN KEY (codice_fiscale) REFERENCES persona(codice_fiscale),
	PRIMARY KEY (nome_box,codice_fiscale,data_presenza)
) ENGINE=INNODB;

/*
	crea la tabella wod
*/
create table if not exists wod(
	data_pubblicazione DATE NOT NULL,
	data_termine DATE NOT NULL,
	id_wod VARCHAR(255) NOT NULL,
	nome_box VARCHAR(255) NOT NULL,
	FOREIGN key (nome_box) REFERENCES box(nome_box),
	PRIMARY KEY (id_wod)
) ENGINE=INNODB;

/*
	crea la tabella WO_ES questa e' una relazione
*/
create table if not exists wo_es(
	id_wod VARCHAR(255) NOT NULL,
	nome_esercizio VARCHAR(255) NOT NULL,
	attrezzo VARCHAR(255) NULL,
	peso INTEGER NULL,
	ripetizioni INTEGER NOT NULL,
	FOREIGN KEY (id_wod) REFERENCES wod(id_wod),
	FOREIGN KEY (nome_esercizio) REFERENCES esercizio(nome_esercizio),
	PRIMARY KEY (id_wod,nome_esercizio)
) ENGINE=INNODB;

/*
	crea la tabella giudice
*/
create table if not exists giudice(
	id_giudice VARCHAR(255) NOT NULL,
	nome VARCHAR(255) NOT NULL,
	cognome VARCHAR(255) NOT NULL,
	data_nascita DATE NOT NULL,
	sesso ENUM('m','f'),
	PRIMARY KEY (id_giudice)
) ENGINE=INNODB;

/*
	crea la tabella team
*/
create table if not exists team(
	nome VARCHAR(255) NOT NULL,
	data_iscrizione DATE NOT NULL,
	stato VARCHAR(255) NOT NULL,
	PRIMARY KEY (nome)
) ENGINE=INNODB;

/*
	crea la tabella sponsor
*/
create table if not exists sponsor(
	nome VARCHAR(255) NOT NULL,
	nome_team VARCHAR(255) NOT NULL,
	quota_versata INTEGER NOT NULL,
	FOREIGN KEY(nome_team) REFERENCES team(nome),
	PRIMARY KEY(nome)
) ENGINE=INNODB;

/*
	crea la tabella team
*/
create table if not exists atleta(
	e_mail VARCHAR(255) NOT NULL,
	nome_team VARCHAR(255) NOT NULL,
	nome VARCHAR(255) NOT NULL,
	cognome VARCHAR(255) NOT NULL,
	data_nascita DATE NOT NULL,
	sesso ENUM('m','f'),
	FOREIGN KEY (nome_team) REFERENCES team(nome),
	PRIMARY KEY (e_mail)
) ENGINE=INNODB;

create table if not exists coach(
	e_mail VARCHAR(255) NOT NULL,
	nome_team VARCHAR(255) NOT NULL,
	nome VARCHAR(255) NOT NULL,
	cognome VARCHAR(255) NOT NULL,
	data_nascita DATE NOT NULL,
	sesso ENUM('m','f'),
	FOREIGN KEY (nome_team) REFERENCES team(nome),
	PRIMARY KEY (e_mail)
) ENGINE=INNODB;

/*
	crea la tabella certificazione
*/
create table if not exists certificazione(
	id_livello VARCHAR(255) NOT NULL,
	descrizione VARCHAR(255) NOT NULL,
	PRIMARY KEY (id_livello)
) ENGINE=INNODB;

/*
	crea la tabella CO_CE e' una relazione
*/
create table if not exists co_ce(
	e_mail VARCHAR(255) NOT NULL,
	id_livello VARCHAR(255) NOT NULL,
	FOREIGN KEY (e_mail) REFERENCES coach(e_mail),
	FOREIGN KEY (id_livello) REFERENCES certificazione(id_livello),
	PRIMARY KEY (e_mail, id_livello)
) ENGINE=INNODB;

/*
	crea la tabella TE_GI_WO e' una relazione
*/
create table if not exists te_gi_wo(
	id_giudice VARCHAR(255) NOT NULL,
	id_wod VARCHAR(255) NOT NULL,
	data_esecuzione DATE NOT NULL,
	nome_team VARCHAR(255) NOT NULL,
	punteggio INTEGER NOT NULL,
	PRIMARY KEY (id_giudice,id_wod,nome_team),
	UNIQUE (id_wod,nome_team)
) ENGINE=INNODB;