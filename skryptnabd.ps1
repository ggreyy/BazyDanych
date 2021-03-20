
<#
    INSTRUKCJA OBSLUGI


    Open-*Connection -DataSource "SomeServer" -InitialCatalog "SomeDB"
    $data = Invoke-SqlQuery -query "SELECT * FROM someTable"

    #or using parameters
    $data = Invoke-SqlQuery -query "SELECT * FROM someTable WHERE someCol = @var" -Parameters @{var = 'a value'}
    Close-SqlConnection
#>

echo "[*] Uruchom ten program w trybie administratora, zeby zainstalowac zaleznosci. Jesli tego nie zrobiles to wyjdz CTRL + C"
Pause
#Install-Module -Name SimplySql -RequiredVersion 1.6.2 -Scope CurrentUser -verbose
Import-Module -Name SimplySql
echo "[*] Zaleznosc zainstalowana pomyslnie! Teraz podaj nazwe uzytkownika bazy danych oraz jego haslo (puste haslo jest zabronione)"
$login = Read-Host -Prompt 'Podaj login'
$haslo = Read-Host -Prompt 'Podaj haslo'
Open-MySqlConnection -Server "localhost" -UserName $login -Password $haslo


##FOREIGN KEY (id_psa) REFERENCES Nagrody(id_psa),FOREIGN KEY (imie_psa) REFERENCES Nagrody(imie_psa)
#PRIMARY KEY (id_wlasc,imie_psa),FOREIGN KEY (imie_psa) REFERENCES Nagrody(imie_psa)
Invoke-SqlQuery -query "CREATE DATABASE wystawa_psow_rasowych;USE wystawa_psow_rasowych;"
Invoke-SqlQuery -query "CREATE TABLE Psy (id_psa int NOT NULL, imie_psa varchar(20),wiek int, rasa varchar(20),plec varchar(1),id_wlasc int NOT NULL, PRIMARY KEY (id_psa,id_wlasc));"
Invoke-SqlQuery -query "CREATE TABLE Kategorie (id_kat int NOT NULL, kat varchar(20), rasa varchar(20), wartosc_nagr int, id_psa int NOT NULL,FOREIGN KEY (id_psa) REFERENCES Psy (id_psa) ,PRIMARY KEY (id_kat,id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Nagrody (id_nagr int NOT NULL,id_kat int NOT NULL, imie_psa varchar(20),wartosc_nagr int, rasa varchar(20),id_psa int NOT NULL, FOREIGN KEY (id_psa,imie_psa) REFERENCES Psy (id_psa,imie_psa), PRIMARY KEY (id_psa,id_nagr,id_kat),FOREIGN KEY (id_kat) REFERENCES Kategorie(id_kat));"
Invoke-SqlQuery -query "CREATE TABLE Wlasciciele (id_wlasc int NOT NULL, id_psa int NOT NULL, imie varchar(20), miasto varchar(20),nazwisko varchar(20), imie_psa varchar(20),FOREIGN KEY (id_psa,id_wlasc) REFERENCES Psy(id_psa,id_wlasc),PRIMARY KEY (id_wlasc,id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Sprzedaz (id_psa int NOT NULL, cena int, PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy (id_psa));"
Invoke-SqlQuery -query "CREATE TABLE Sedzia (id_psa int NOT NULL,nazwisko_sed varchar(20), wartosc_nagr int,PRIMARY KEY (id_psa),FOREIGN KEY (id_psa) REFERENCES Psy(id_psa));"

 

Close-SqlConnection