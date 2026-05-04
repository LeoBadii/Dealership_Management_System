/************************Base di dati DBConcessionario di ********************
*************************Leonardo Badii 7167065*******************************
*************************Alessandro Lenchuk 7159666***************************/

DROP DATABASE IF EXISTS DBConcessionario;
CREATE DATABASE DBConcessionario;
USE DBConcessionario;
SET GLOBAL local_infile = 1;

DROP TABLE IF EXISTS Contratto;
DROP TABLE IF EXISTS TestDrive;
DROP TABLE IF EXISTS Afferenza;
DROP TABLE IF EXISTS AfferenzaPassata;
DROP TABLE IF EXISTS Auto;
DROP TABLE IF EXISTS Concessionario;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Personale;

CREATE TABLE IF NOT EXISTS Personale(
	ID_Pers INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Perc_Provv TINYINT,
    Data_Abil date
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Concessionario(
	P_Iva CHAR(11) PRIMARY KEY,
    Nome VARCHAR(20),
    Fatturato LONG,
    N_Auto INT,
    N_Pers SMALLINT,
    Via VARCHAR(50),
    Civico VARCHAR(8),
    Citta Varchar(30),
    CAP CHAR(5),
    ID_Dir INT NOT NULL,
    FOREIGN KEY (ID_Dir) REFERENCES Personale(ID_Pers)
		ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Afferenza(
	ID_Pers INT,
    P_Iva CHAR(11),
    PRIMARY KEY (ID_Pers, P_Iva),
    Stipendio DECIMAL(7, 2),
    Data_Inizio date,
    FOREIGN KEY (ID_Pers) REFERENCES Personale(ID_Pers)
		ON DELETE CASCADE,
	FOREIGN KEY (P_Iva) REFERENCES Concessionario(P_Iva)
		ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AfferenzaPassata(
	ID_Pers INT,
    P_Iva CHAR(11),
    Data_Fine date,
    PRIMARY KEY (ID_Pers, P_Iva, Data_Fine),
    Data_Inizio date,
    FOREIGN KEY (ID_Pers) REFERENCES Personale(ID_Pers)
		ON DELETE CASCADE,
	FOREIGN KEY (P_Iva) REFERENCES Concessionario(P_Iva)
		ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Auto(
	N_Telaio CHAR(17) PRIMARY KEY,
    Targa VARCHAR(7),
    Prz_List INT NOT NULL,
    Stato ENUM('Disponibile','Venduta') NOT NULL,
    Marca VARCHAR(20),
    Modello VARCHAR(20),
    Potenza CHAR(4),
    Carb ENUM('Benzina','Diesel','Hybrid','Elettrica'),
    P_Iva CHAR(11),
    FOREIGN KEY (P_Iva) REFERENCES Concessionario(P_Iva)
		ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Cliente(
	Cod_F VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Data_Pat date NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS TestDrive(
	Cod_Test INT PRIMARY KEY AUTO_INCREMENT,
    Data date,
    Ora TIME,
    N_Telaio CHAR(17),
    ID_Pers INT,
    Cod_F VARCHAR(16),
    FOREIGN KEY (N_Telaio) REFERENCES Auto(N_Telaio)
		ON DELETE CASCADE,
    FOREIGN KEY (ID_Pers) REFERENCES Personale(ID_Pers)
		ON DELETE CASCADE,
	FOREIGN KEY (Cod_F) REFERENCES Cliente(Cod_F)
        ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Contratto(
	Cod_Contr INT PRIMARY KEY AUTO_INCREMENT,
    Data date NOT NULL,
    Mod_Pag ENUM('Contanti','Bancomat','Finanziamento') NOT NULL,
    Cod_F VARCHAR(16),
    N_Telaio CHAR(17),
    ID_Pers INT,
    FOREIGN KEY (Cod_F) REFERENCES Cliente(Cod_F)
        ON DELETE CASCADE,
	FOREIGN KEY (N_Telaio) REFERENCES Auto(N_Telaio)
		ON DELETE CASCADE,
	FOREIGN KEY (ID_Pers) REFERENCES Personale(ID_Pers)
		ON DELETE CASCADE
) ENGINE = InnoDB;

/************************Popolamento***************************/
/***Inserire nei comandi INSERT da File, il proprio percorso***/

INSERT INTO Personale (Nome, Cognome, Perc_Provv, Data_Abil) VALUES
('Leonardo','Badii', 20, NULL),
('Alessandro','Lenchuk', NULL, '2020-01-07'),
('Pippo','Baudo', 5, NULL),
('Checco','Zalone', 10, NULL),
('Gaetano','Castrovilli', 15, NULL),
('Santiago','Castro', 18, NULL),
('Alessandro','Borghese', 22, NULL),
('Anne','Jacobs', 13, NULL),
('Rossella','Rosario', 20, NULL),
('Ken','Follet', NULL, '2025-01-06');

INSERT INTO Cliente (Cod_F, Nome, Cognome, Data_Pat) VALUES
('RSSMRA80A01H501U','Maria', 'Rossella', '2025-12-12'),
('BNCFRC85B12L219X','Bencini', 'Pietro', '2020-05-14'),
('GVNNNN90C15F205W','Giovanni', 'Vannini', '2000-08-24'),
('MRALRI75D20G388Y','Maril', 'Monroe', '2016-04-27'),
('SCRLND88E25I441Z','Serena', 'Landini', '1998-12-16'),
('FLIPPI92F30A794K','Filippo', 'Maria', '2001-11-01'),
('RSSMRC80A01H501Z','Marco', 'Rossi', '2013-09-15'),
('BNCGLI92R41L219X','Giulia', 'Bianchi', '1981-03-07'),
('VRDLUC75M10F205A','Luca', 'Verdi', '2007-06-02'),
('SPSLSN85T20H501U','Alessandro', 'Esposito', '2005-11-22'),
('MGNLNE95E55D612P', 'Elena', 'Magnelli', '2014-06-20');

LOAD DATA LOCAL INFILE 'popolamentoConcessionario.txt' 
INTO TABLE Concessionario 
FIELDS TERMINATED BY ', ' 
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'popolamentoAfferenza.txt' 
INTO TABLE Afferenza 
FIELDS TERMINATED BY ', ' 
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'popolamentoAfferenzaPassata.txt' 
INTO TABLE AfferenzaPassata
FIELDS TERMINATED BY ', ' 
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'popolamentoAuto.txt' 
INTO TABLE Auto
FIELDS TERMINATED BY ', ' 
LINES TERMINATED BY '\n';

INSERT INTO TestDrive (Data, Ora, N_Telaio, ID_Pers, Cod_F) 
VALUES 
('2026-01-16', '10:30:00', 'ZFA12345678901234', 1, 'RSSMRA80A01H501U'),
('2026-01-16', '11:45:00', 'WBA98765432109876', 1, 'BNCFRC85B12L219X'),
('2026-01-17', '09:15:00', 'ZAR99887766554433', 1, 'MGNLNE95E55D612P'),
('2026-01-17', '15:00:00', 'WVG55667788990011', 5, 'MRALRI75D20G388Y'),
('2026-01-18', '16:30:00', 'WDC44332211009988', 6, 'SCRLND88E25I441Z'),
('2026-01-18', '17:00:00', 'WDC44332211009988', 7, 'FLIPPI92F30A794K');

LOAD DATA LOCAL INFILE 'popolamentoContratto.txt'
INTO TABLE Contratto
FIELDS TERMINATED BY ', ' 
LINES TERMINATED BY '\n';

/************************Trigger***************************/

/***1***/
DELIMITER $$
CREATE TRIGGER check_personale_ruolo
BEFORE INSERT ON Personale
FOR EACH ROW
BEGIN
    IF (NEW.Data_Abil IS NULL AND NEW.Perc_Provv IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Inserire almeno la Provvigione o la Data Abilitazione.';
    END IF;
    IF (NEW.Data_Abil IS NOT NULL AND NEW.Perc_Provv IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Un membro del personale non può avere sia Provvigione che Abilitazione.';
    END IF;
END;
$$ DELIMITER ;

/***2***/
DELIMITER $$
CREATE TRIGGER check_idoneita_direttore
BEFORE INSERT ON Concessionario
FOR EACH ROW
BEGIN
    DECLARE v_data_abil DATE;
    SELECT Data_Abil INTO v_data_abil 
    FROM Personale 
    WHERE ID_Pers = NEW.ID_Dir;
    IF v_data_abil IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Il personale scelto come direttore non possiede una data di abilitazione.';
    END IF;
END;
$$ DELIMITER ;

/***3***/
DELIMITER $$
CREATE TRIGGER check_anzianita_abilitazione
BEFORE INSERT ON Personale
FOR EACH ROW
BEGIN
    IF (NEW.Data_Abil IS NOT NULL AND NEW.Data_Abil < DATE_SUB(CURDATE(), INTERVAL 10 YEAR)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Abilitazione conseguita più di 10 anni fa.';
    END IF;
END;
$$ DELIMITER ;

/***4***/
DELIMITER $$
CREATE TRIGGER check_neopatentati_testdrive
BEFORE INSERT ON TestDrive
FOR EACH ROW
BEGIN
    DECLARE v_potenza INT;
    DECLARE v_data_pat DATE;
    SELECT CAST(Potenza AS UNSIGNED) INTO v_potenza FROM Auto WHERE N_Telaio = NEW.N_Telaio;
    SELECT Data_Pat INTO v_data_pat FROM Cliente WHERE Cod_F = NEW.Cod_F;
    IF (v_potenza > 95 AND v_data_pat > DATE_SUB(CURDATE(), INTERVAL 3 YEAR)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Un Cliente neo-patentato non può guidare auto con più di 95 CV.';
    END IF;
END;
$$ DELIMITER ;

/***5***/
DELIMITER $$
CREATE TRIGGER check_date_afferenza_passata
BEFORE INSERT ON AfferenzaPassata
FOR EACH ROW
BEGIN
    IF (NEW.Data_Inizio >= NEW.Data_Fine) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! La data di inizio deve essere antecedente alla data di fine rapporto.';
    END IF;
END;
$$ DELIMITER ;

/***6***/
DELIMITER $$
CREATE TRIGGER check_auto_disponibile_test
BEFORE INSERT ON TestDrive
FOR EACH ROW
BEGIN
    DECLARE v_stato VARCHAR(20);
    SELECT Stato INTO v_stato FROM Auto WHERE N_Telaio = NEW.N_Telaio;
    IF (v_stato = 'Venduta') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Impossibile effettuare un test drive su un auto già venduta.';
    END IF;
END;
$$ DELIMITER ;

/***7***/
DELIMITER $$
CREATE TRIGGER aggiorna_n_auto_insert
AFTER INSERT ON Auto
FOR EACH ROW
BEGIN
    IF NEW.P_Iva IS NOT NULL THEN
        UPDATE Concessionario 
        SET N_Auto = N_Auto + 1 
        WHERE P_Iva = NEW.P_Iva;
    END IF;
END;
$$
CREATE TRIGGER aggiorna_n_auto_update
AFTER UPDATE ON Auto
FOR EACH ROW
BEGIN
    IF (OLD.P_Iva <> NEW.P_Iva) THEN
        UPDATE Concessionario SET N_Auto = N_Auto - 1 WHERE P_Iva = OLD.P_Iva;
        UPDATE Concessionario SET N_Auto = N_Auto + 1 WHERE P_Iva = NEW.P_Iva;
    END IF;
END;
$$ DELIMITER ;

/***8***/
DELIMITER $$
CREATE TRIGGER aggiorna_n_pers_insert
AFTER INSERT ON Afferenza
FOR EACH ROW
BEGIN
    UPDATE Concessionario 
    SET N_Pers = N_Pers + 1 
    WHERE P_Iva = NEW.P_Iva;
END;
$$
CREATE TRIGGER aggiorna_n_pers_delete
AFTER DELETE ON Afferenza
FOR EACH ROW
BEGIN
    UPDATE Concessionario 
    SET N_Pers = N_Pers - 1 
    WHERE P_Iva = OLD.P_Iva;
END;
$$ DELIMITER ;

/***9***/
DELIMITER $$
CREATE TRIGGER aggiorna_fatturato_insert
AFTER INSERT ON Contratto
FOR EACH ROW
BEGIN
    DECLARE v_prezzo INT;
    DECLARE v_iva_sede CHAR(11);
    SELECT Prz_List, P_Iva INTO v_prezzo, v_iva_sede 
    FROM Auto 
    WHERE N_Telaio = NEW.N_Telaio;
    UPDATE Concessionario 
    SET Fatturato = Fatturato + v_prezzo 
    WHERE P_Iva = v_iva_sede;
    UPDATE Auto SET Stato = 'Venduta' WHERE N_Telaio = NEW.N_Telaio;
END;
$$ DELIMITER ;

/************************Interrogazioni***************************/

/***1***/
SELECT P.Nome, P.Cognome, GROUP_CONCAT(C.Nome SEPARATOR ' - ') AS Sedi_Amministrate
FROM Personale P
JOIN Concessionario C ON P.ID_Pers = C.ID_Dir
WHERE P.Data_Abil IS NOT NULL
GROUP BY P.ID_Pers, P.Nome, P.Cognome;

/***2***/
CREATE VIEW Personale_GuadagniVenditori AS
SELECT P.ID_Pers, P.Nome, P.Cognome, A.N_Telaio, A.Modello, A.Prz_List, (A.Prz_List * P.Perc_Provv / 100) AS Importo_Provvigione
FROM Personale P
JOIN Contratto C ON P.ID_Pers = C.ID_Pers
JOIN Auto A ON C.N_Telaio = A.N_Telaio;

SELECT Nome, Cognome, SUM(Importo_Provvigione) AS Totale_Provvigioni
FROM Personale_GuadagniVenditori
GROUP BY ID_Pers;

/***3***/
CREATE VIEW Vista_Info_Sedi AS
SELECT C.Nome AS Nome_Sede, C.Citta, C.Fatturato, P.Nome AS Nome_Dir, P.Cognome AS Cognome_Dir
FROM Concessionario C
JOIN Personale P ON C.ID_Dir = P.ID_Pers;

SELECT Nome_Sede, Citta, Fatturato, Cognome_Dir
FROM Vista_Info_Sedi
WHERE Fatturato > (SELECT AVG(Fatturato) FROM Concessionario)
ORDER BY Fatturato DESC;

/***4***/
SELECT CL.Nome, CL.Cognome, A.Marca, A.Modello, T.Data AS Data_Test, CO.Data AS Data_Acquisto
FROM Cliente CL
JOIN TestDrive T ON CL.Cod_F = T.Cod_F
JOIN Contratto CO ON CL.Cod_F = CO.Cod_F AND T.N_Telaio = CO.N_Telaio
JOIN Auto A ON T.N_Telaio = A.N_Telaio
WHERE CO.Data >= T.Data;

/************************Procedure e Funzioni***************************/

/***1***/

DELIMITER $$
CREATE PROCEDURE TrasferimentoAuto(
    IN p_telaio CHAR(17), 
    IN p_nuova_iva CHAR(11)
)
BEGIN
    IF (SELECT Stato FROM Auto WHERE N_Telaio = p_telaio) = 'Disponibile' THEN
        UPDATE Auto 
        SET P_Iva = p_nuova_iva 
        WHERE N_Telaio = p_telaio;
        SELECT 'Trasferimento completato' AS Messaggio;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attenzione! Auto già venduta o non esistente';
    END IF;
END; 
$$ DELIMITER ;

CALL TrasferimentoAuto('ZFA12345678901234', '01234567890');

/***2***/

DELIMITER $$
CREATE PROCEDURE RegistraVendita(
    IN p_cod_f VARCHAR(16),
    IN p_telaio CHAR(17),
    IN p_id_venditore INT,
    IN p_metodo ENUM('Contanti','Bancomat','Finanziamento')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
        INSERT INTO Contratto (Data, Mod_Pag, Cod_F, N_Telaio, ID_Pers)
        VALUES (CURDATE(), p_metodo, p_cod_f, p_telaio, p_id_venditore);
        UPDATE Auto SET Stato = 'Venduta' WHERE N_Telaio = p_telaio;
    COMMIT;
END;
$$ DELIMITER ;

CALL RegistraVendita('BNCFRC85B12L219X', 'ZFA12345678901234', 1, 'Contanti');

/***3***/

DELIMITER $$
CREATE FUNCTION ContaAutoMarca(p_marca VARCHAR(20)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE totale INT;
    SELECT COUNT(*) INTO totale FROM Auto WHERE Marca = p_marca;
    RETURN totale;
END;
$$ DELIMITER ;

SELECT ContaAutoMarca('Fiat');

/***4***/

DELIMITER $$
CREATE PROCEDURE RicercaPerBudget(IN budget_max INT)
BEGIN
    SELECT Marca, Modello, Prz_List, Carb
    FROM Auto
    WHERE Prz_List <= budget_max AND Stato = 'Disponibile'
    ORDER BY Prz_List DESC;
END;
$$ DELIMITER ;

call RicercaPerBudget(35000);