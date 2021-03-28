
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
$env:Path += ";C:\xampp\mysql\bin";
echo "[*] Zaleznosc zainstalowana pomyslnie! Teraz podaj nazwe uzytkownika bazy danych oraz jego haslo (puste haslo jest zabronione)"
$login = Read-Host -Prompt 'Podaj login'
$haslo = Read-Host -Prompt 'Podaj haslo'
Open-MySqlConnection -Server "localhost" -UserName $login -Password $haslo
Invoke-SqlQuery -query "CREATE DATABASE wystawa_psow_rasowych;";
Close-SqlConnection



mysql.exe -u $login -p"$haslo" wystawa_psow_rasowych -e "source .\proced.sql"












