
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

mysql -u $login -p"$haslo" -e "SOURCE C:/users/gdzie/source/repos/BazyDanych/proced.sql;"


$val = 0;
while($val -ne 99){ 
  
   $rand =  Get-Random -Minimum 1 -Maximum 200;
   $nazwa_psa = (Get-Content -Path C:\users\gdzie\source\repos\BazyDanych\nazwy_psow.txt -TotalCount $rand)[-1];
   $rand = Get-Random -Minimum 1 -Maximum 20;
   $wiek_psa = $rand;
   $rand = Get-Random -Minimum 1 -Maximum 353;
   $rasa = (Get-Content -Path C:\users\gdzie\source\repos\BazyDanych\rasypsow.txt -TotalCount $rand)[-1];
   $rand = Get-Random -Minimum 1 -Maximum 3;
   if($rand -eq 1){
    $plec = "M";}
   else{
    $plec = "F";
    }
    $rand = Get-Random -Minimum 1 -Maximum 1000;
    if($rand -eq 1){
    $ilosc_psow =2;}
    else{
    $ilosc_psow = 1}



   mysql -u $login -p"$haslo" -e "USE wystawa_psow_rasowych; INSERT INTO Psy (imie_psa,wiek,rasa,plec,ilosc_psow) VALUES ('$nazwa_psa',$wiek_psa,'$rasa','$plec',$ilosc_psow);UPDATE Psy SET Psy.id_wlasc = Psy.id_psa;"
   $val++ ;
  }


  $valz = 1;

while($valz -ne 21)
{

$kategoria_n =  (Get-Content -Path C:\users\gdzie\source\repos\BazyDanych\kategorie.txt -TotalCount $valz)[-1];
$rand = Get-Random -Minimum 1 -Maximum 199;
$nagr = (Get-Content -Path C:\users\gdzie\source\repos\BazyDanych\punkty.txt -TotalCount $rand)[-1];



mysql -u $login -p"$haslo" -e "USE wystawa_psow_rasowych; INSERT INTO Kategorie(kat,wartosc_nagr,id_kat) VALUES ('$kategoria_n','$nagr','$valz');";
$valz++;
}


  <#
 $rand =  Get-Random -Maximum 4945;
   $imie_wlasc = (Get-Content -Path .\wlasciciele_imiona.txt -TotalCount $rand)[-1];
   $rand =  Get-Random -Maximum 20000;
   $nazw_wlasc = (Get-Content -Path .\wlasciciele_nazwiska.txt -TotalCount $rand)[-1];
   #>









