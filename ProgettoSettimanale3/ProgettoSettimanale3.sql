CREATE DATABASE GestioneSanzioni;

USE GestioneSanzioni;

CREATE TABLE ANAGRAFICA (
    idanagrafica INT PRIMARY KEY,
    Cognome VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Indirizzo VARCHAR(100),
    Città VARCHAR(50),
    CAP CHAR(5) NOT NULL,
    Cod_Fisc CHAR(16) UNIQUE NOT NULL, 
    CHECK (CAP >= '00000' AND CAP <= '99999') 
);

CREATE TABLE TIPO_VIOLAZIONE (
    idviolazione INT PRIMARY KEY,
    descrizione VARCHAR(255) NOT NULL
);

CREATE TABLE VERBALE (
    idverbale INT PRIMARY KEY,
    idanagrafica INT NOT NULL,
    idviolazione INT NOT NULL,
    DataViolazione DATE NOT NULL,
    IndirizzoViolazione VARCHAR(100),
    Nominativo_Agente VARCHAR(50),
    DataTrascrizioneVerbale DATE,
    Importo DECIMAL(10,2) NOT NULL,
    DecurtamentoPunti INT,
    FOREIGN KEY (idanagrafica) REFERENCES ANAGRAFICA(idanagrafica),
    FOREIGN KEY (idviolazione) REFERENCES TIPO_VIOLAZIONE(idviolazione)
);

-- Popolamento Tabella ANAGRAFICA

INSERT INTO ANAGRAFICA (idanagrafica, Cognome, Nome, Indirizzo, Città, CAP, Cod_Fisc)
VALUES
(1, 'Rossi', 'Mario', 'Via Roma 10', 'Palermo', '90100', 'RSSMRA80A01H501U'),
(2, 'Bianchi', 'Laura', 'Via Milano 5', 'Palermo', '90100', 'BNCLRA85B51H501Q'),
(3, 'Verdi', 'Giovanni', 'Via Libertà 20', 'Palermo', '90100', 'VRDGVN70C01L726Z'),
(4, 'Neri', 'Sara', 'Via Napoli 30', 'Roma', '00100', 'NRISRA95D02L219H'),
(5, 'Gialli', 'Luca', 'Corso Italia 12', 'Napoli', '80100', 'GLLLCA92E03M345Y'),
(6, 'Azzurri', 'Anna', 'Via Venezia 8', 'Palermo', '90100', 'AZZANN78F04S842W'),
(7, 'Aranci', 'Paolo', 'Via Bologna 22', 'Palermo', '90100', 'ARNPLA82G05T631X'),
(8, 'Viola', 'Giulia', 'Via Bari 17', 'Bari', '70100', 'VLAGIA90H06B112Y'),
(9, 'Rosa', 'Francesca', 'Via Genova 9', 'Genova', '16100', 'RSFFRN89I07H832T'),
(10, 'Marrone', 'Davide', 'Via Verona 15', 'Palermo', '90100', 'MRRDVD85L08H671Q');

-- Popolamento Tabella TIPO_VIOLAZIONE

INSERT INTO TIPO_VIOLAZIONE (idviolazione, descrizione)
VALUES
(1, 'Eccesso di velocità'),
(2, 'Divieto di sosta'),
(3, 'Passaggio col rosso'),
(4, 'Guida senza cintura'),
(5, 'Sosta su posto per disabili'),
(6, 'Utilizzo del cellulare alla guida'),
(7, 'Mancato rispetto della precedenza'),
(8, 'Sosta in doppia fila'),
(9, 'Guida contromano'),
(10, 'Mancata revisione del veicolo');

-- Popolamento Tabella VERBALE

INSERT INTO VERBALE (idverbale, idanagrafica, idviolazione, DataViolazione, IndirizzoViolazione, Nominativo_Agente, DataTrascrizioneVerbale, Importo, DecurtamentoPunti)
VALUES
(1, 1, 1, '2025-02-01', 'Via Libertà', 'Giovanni Verdi', '2025-02-02', 150.00, 3),
(2, 2, 2, '2025-02-10', 'Via Roma', 'Sara Neri', '2025-02-11', 50.00, 0),
(3, 3, 3, '2025-02-20', 'Corso Italia', 'Luca Gialli', '2025-02-21', 200.00, 6),
(4, 4, 4, '2025-02-25', 'Via Napoli', 'Anna Azzurri', '2025-02-26', 100.00, 2),
(5, 5, 5, '2009-02-15', 'Via Roma', 'Paolo Aranci', '2009-02-16', 300.00, 4),
(6, 6, 6, '2009-03-01', 'Via Venezia', 'Giulia Viola', '2009-03-02', 500.00, 5),
(7, 7, 7, '2009-06-20', 'Via Bologna', 'Francesca Rosa', '2009-06-21', 250.00, 3),
(8, 8, 8, '2009-07-01', 'Via Bari', 'Davide Marrone', '2009-07-02', 150.00, 1),
(9, 9, 9, '2025-01-25', 'Via Genova', 'Giovanni Verdi', '2025-01-26', 100.00, 2),
(10, 10, 10, '2025-02-28', 'Via Verona', 'Sara Neri', '2025-03-01', 50.00, 0);

-- Query 1: Conteggio dei verbali trascritti
SELECT COUNT(*) AS TotaleVerbali FROM VERBALE;

-- Query 2: Conteggio dei verbali trascritti raggruppati per anagrafica
SELECT idanagrafica, COUNT(*) AS TotaleVerbali
FROM VERBALE
GROUP BY idanagrafica;

-- Query 3: Conteggio dei verbali trascritti raggruppati per tipo di violazione
SELECT idviolazione, COUNT(*) AS TotaleViolazioni
FROM VERBALE
GROUP BY idviolazione;

-- Query 4: Totale dei punti decurtati per ogni anagrafica
SELECT idanagrafica, SUM(DecurtamentoPunti) AS TotalePuntiDecurtati
FROM VERBALE
GROUP BY idanagrafica;

-- Query 5: Informazioni sui residenti a Palermo (cognome, nome, data violazione, indirizzo violazione, importo e punti decurtati)
SELECT A.Cognome, A.Nome, V.DataViolazione, V.IndirizzoViolazione, V.Importo, V.DecurtamentoPunti
FROM ANAGRAFICA as A
INNER JOIN VERBALE as V ON A.idanagrafica = V.idanagrafica
WHERE A.Città = 'Palermo';

-- Query 6: Violazioni registrate tra febbraio 2009 e luglio 2009
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM ANAGRAFICA A
INNER JOIN VERBALE V ON A.idanagrafica = V.idanagrafica
WHERE V.DataViolazione BETWEEN '2009-02-01' AND '2009-07-31';

-- Query 7: Totale degli importi per ogni anagrafica
SELECT idanagrafica, SUM(Importo) AS TotaleImporti
FROM VERBALE
GROUP BY idanagrafica;

-- Query 8: Visualizzazione di tutti gli anagrafici residenti a Palermo
SELECT * FROM ANAGRAFICA WHERE Città = 'Palermo';

-- Query 9: Dettaglio dei verbali (data violazione, importo, punti decurtati) per una data specifica
SELECT DataViolazione, Importo, DecurtamentoPunti
FROM VERBALE
WHERE DataViolazione = '2025-02-01';

-- Query 10: Conteggio delle violazioni contestate raggruppate per agente
SELECT Nominativo_Agente, COUNT(*) AS TotaleViolazioni
FROM VERBALE
GROUP BY Nominativo_Agente;

-- Query 11: Violazioni con decurtamento superiore a 5 punti
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM ANAGRAFICA A
INNER JOIN VERBALE V ON A.idanagrafica = V.idanagrafica
WHERE V.DecurtamentoPunti > 5;

-- Query 12: Violazioni con importo superiore a 400 euro
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM ANAGRAFICA A
INNER JOIN VERBALE V ON A.idanagrafica = V.idanagrafica
WHERE V.Importo > 400;

-- Query 13: Numero di verbali e importo totale delle multe emesse per ogni agente di polizia
SELECT Nominativo_Agente, 
       COUNT(*) AS NumeroVerbali, 
       SUM(Importo) AS ImportoTotale
FROM VERBALE
GROUP BY Nominativo_Agente;

-- Query 14: Media degli importi delle multe per tipo di violazione
SELECT T.descrizione AS TipoViolazione, 
       AVG(V.Importo) AS MediaImporto
FROM VERBALE V
INNER JOIN TIPO_VIOLAZIONE T ON V.idviolazione = T.idviolazione
GROUP BY T.descrizione;


