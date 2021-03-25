DELIMITER $$ CREATE PROCEDURE
  nagrdane (OUT wartna int) BEGIN
   INSERT INTO Sprzedaz(id_psa,cena) SELECT id_psa,1 FROM Nagrody INNER JOIN Sprzedaz ON Nagrody.id_psa = Sprzedaz.id_psa WHERE Nagrody.wartosc_nagr = wartna;
    END;$$DELIMITER ;