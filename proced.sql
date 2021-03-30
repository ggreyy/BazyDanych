






--Add sql to environmental path




--Tu sa trzymane logi w plikach


--SET GLOBAL log_output = "FILE";
--SET GLOBAL general_log_file = "C:\Users\gdzie\source\repos\BazyDanych\logi.txt"
--SET GLOBAL general_log = 'ON';


--standardowo


-- OPTIONAL:  CREATE DATABASE wystawa_psow_rasowych;
USE wystawa_psow_rasowych;

 --Tworze strukture bazy danych


CREATE TABLE Psy (id_psa int NOT NULL AUTO_INCREMENT, imie_psa varchar(20),wiek int, rasa varchar(50),plec varchar(1),id_wlasc int NOT NULL, ilosc_psow int,PRIMARY KEY (id_psa,id_wlasc));
CREATE TABLE Kategorie (id_kat int ,kat varchar(40), wartosc_nagr int);
CREATE TABLE Nagrody (id_nagr int NOT NULL ,id_kat int NOT NULL, imie_psa varchar(20),wartosc_nagr int, rasa varchar(20),id_psa int NOT NULL, FOREIGN KEY (id_psa) REFERENCES Psy (id_psa), PRIMARY KEY (id_psa));
CREATE TABLE Wlasciciele (id_wlasc int NOT NULL , id_psa int NOT NULL, imie varchar(20), miasto varchar(20),nazwisko varchar(20), imie_psa varchar(20),FOREIGN KEY (id_psa,id_wlasc) REFERENCES Psy(id_psa,id_wlasc),PRIMARY KEY (id_wlasc,id_psa));
CREATE TABLE Sprzedaz (id_psa int NOT NULL , cena int, PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy (id_psa));
CREATE TABLE Sedzia (id_psa int NOT NULL,nazwisko_sed varchar(20), wartosc_nagr int,PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy(id_psa));
CREATE TABLE Psy_w_Kate_1_rzad (ilosc int NOT NULL ,id_kat int NOT NULL,wartosc_nagr int ); 
CREATE TABLE Logi (logstring nvarchar(200));


 --Proste indexy
 
------------------------------zmien nagrody

CREATE INDEX ix_P ON Psy(wiek);
CREATE INDEX ix_N ON Nagrody(id_kat);
CREATE INDEX ix_S ON Sedzia(wartosc_nagr);



--Tutaj musialem uzyc delimitera ( w sensie na ten blok kodu )inaczej csie chyba nie da

DELIMITER //

--Tutaj uzupelniam kategorie po to zeby dzialal Trigger, do sortowania kategorii w Psy_w_Kate_1_rzad

FOR i IN 1..20
DO
  INSERT INTO Psy_w_Kate_1_rzad (id_kat)  VALUES (i);
END FOR;
//

--Randomowa cena dla psa o danej wartosci nagrody


CREATE PROCEDURE nagrdane (wartna INT)
 BEGIN
  INSERT INTO Sprzedaz(id_psa,cena) SELECT Nagrody.id_psa,FLOOR(RAND()*(10-5+1)+5) FROM Nagrody WHERE Nagrody.wartosc_nagr = wartna;
 END;
//

--Funkcja ktora zwraca stosunek ceny do wartosci nagrody dla id_psa

CREATE FUNCTION wsp (wyborid int)
RETURNS FLOAT DETERMINISTIC
 BEGIN
  SET @licz = (SELECT Sprzedaz.cena FROM Sprzedaz WHERE Sprzedaz.id_psa = wyborid);
  SET @mian = (SELECT Nagrody.wartosc_nagr FROM Nagrody WHERE Nagrody.id_psa = wyborid);
  RETURN @licz/@mian;
 END;
 //
 

--Trigger walidujacy czy przypadkiem wiek psa albo jego ilosc nie jest 0



CREATE TRIGGER validat
	BEFORE INSERT
	ON Psy
	FOR EACH ROW
BEGIN
	IF NEW.wiek = 0 OR NEW.ilosc_psow = 0 THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT ="Bledna wartosc (wiek ani ilosc_psow nie moze byc 0)";
	END IF;
END;
//

--Trigger tworzacy logi systemowe

CREATE TRIGGER obecne_sprzedaz
AFTER UPDATE
ON Sprzedaz
FOR EACH ROW
BEGIN 
			
			INSERT INTO Logi (logstring) VALUES (CONCAT ("Sprzedaz zaktualizowana,cena:", NEW.cena,"id_psa",NEW.id_psa));

 END;
 //
 
 -- Koniec delimitera
 
DELIMITER ;


--Kolejny trigger uzupelniajacy ilosc psow  w kategorii


 --  CREATE TRIGGER tr_insert 
 --  BEFORE INSERT ON Kategorie
--   FOR EACH ROW
  -- UPDATE Psy_w_Kate_1_rzad SET Psy_w_Kate_1_rzad.ilosc = Psy_w_Kate_1_rzad.ilosc+1 WHERE Psy_w_Kate_1_rzad.id_kat = NEW.id_kat;







