
<#
    INSTRUKCJA OBSLUGI


    Open-*Connection -DataSource "SomeServer" -InitialCatalog "SomeDB"
    $data = Invoke-SqlQuery -query "SELECT * FROM someTable"

    #or using parameters
    $data = Invoke-SqlQuery -query "SELECT * FROM someTable WHERE someCol = @var" -Parameters @{var = 'a value'}
    Close-SqlConnection
#>

#nie wiem co robi powershell ale jakos formatuje te zapytania

echo "[*] Uruchom ten program w trybie administratora, zeby zainstalowac zaleznosci. Jesli tego nie zrobiles to wyjdz CTRL + C"
Pause
#Install-Module -Name SimplySql -RequiredVersion 1.6.2 -Scope CurrentUser -verbose
Import-Module -Name SimplySql
echo "[*] Zaleznosc zainstalowana pomyslnie! Teraz podaj nazwe uzytkownika bazy danych oraz jego haslo (puste haslo jest zabronione)"
$login = Read-Host -Prompt 'Podaj login'
$haslo = Read-Host -Prompt 'Podaj haslo'
Open-MySqlConnection -Server "localhost" -UserName $login -Password $haslo

#Tworze podstawowa strukture bazy danych
Invoke-SqlQuery -query "CREATE DATABASE wystawa_psow_rasowych;USE wystawa_psow_rasowych;"
Invoke-SqlQuery -query "CREATE TABLE Psy (id_psa int NOT NULL AUTO_INCREMENT, imie_psa varchar(20),wiek int, rasa varchar(20),plec varchar(1),id_wlasc int NOT NULL, PRIMARY KEY (id_psa,id_wlasc));"
Invoke-SqlQuery -query "CREATE TABLE Kategorie (id_kat int NOT NULL AUTO_INCREMENT, kat varchar(20), rasa varchar(20), wartosc_nagr int, id_psa int NOT NULL,FOREIGN KEY (id_psa) REFERENCES Psy (id_psa) ,PRIMARY KEY (id_kat,id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Nagrody (id_nagr int NOT NULL ,id_kat int NOT NULL, imie_psa varchar(20),wartosc_nagr int, rasa varchar(20),id_psa int NOT NULL, FOREIGN KEY (id_psa) REFERENCES Psy (id_psa), PRIMARY KEY (id_psa),FOREIGN KEY (id_kat) REFERENCES Kategorie(id_kat));"
Invoke-SqlQuery -query "CREATE TABLE Wlasciciele (id_wlasc int NOT NULL , id_psa int NOT NULL, imie varchar(20), miasto varchar(20),nazwisko varchar(20), imie_psa varchar(20),FOREIGN KEY (id_psa,id_wlasc) REFERENCES Psy(id_psa,id_wlasc),PRIMARY KEY (id_wlasc,id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Sprzedaz (id_psa int NOT NULL, cena int, PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy (id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Sedzia (id_psa int NOT NULL,nazwisko_sed varchar(20), wartosc_nagr int,PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy(id_psa));"
#Tworze indexy
Invoke-SqlQuery -query "CREATE INDEX ix_P ON Psy(wiek);"
Invoke-SqlQuery -query "CREATE INDEX ix_K ON Kategorie(wartosc_nagr)";
Invoke-SqlQuery -query "CREATE INDEX ix_N ON Nagrody(id_kat)";
#Procedury (call)
#wystawiam na sprzedaz psy ktore zdobyly nagrode

#$nasz_random = Get-Random -Maximum 10;
#$execstr = -join("'DELIMITER $$,CREATE PROCEDURE
#  nagrdane (OUT wartna int) BEGIN
 #  INSERT INTO Sprzedaz(id_psa,cena) SELECT id_psa,1 FROM Nagrody INNER JOIN Sprzedaz ON Nagrody.id_psa = Sprzedaz.id_psa WHERE Nagrody.wartosc_nagr = wartna;
 #   END;$$DELIMITER ;'");
#echo $execstr;
 #.Insert(112,$nasz_random);
  
$query= Get-Content -path C:\Users\gdzie\source\repos\BazyDanych\proced.sql -Raw
echo $query;
Invoke-SqlQuery -query $query;



Close-SqlConnection
