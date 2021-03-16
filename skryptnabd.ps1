


echo "[*]Witam w programie frontendowym bazy danych! Upewnij sie ze masz uprawnienia administratora w tym oknie"
Pause
echo "[*]Aby program dzialal poprawnie musimy pobrac pewne zaleznosci oraz ustawic PolitykeWykonywania na 'YES'"
Pause
echo "[*]Zatwierdz ta opcje(pozniej mozna sobie ja zmienic, to tylko po to zeby zainstalowac zaleznosc"
Pause
Set-ExecutionPolicy RemoteSigned
$location = Read-host -Prompt "Wpisz sciezke instalacji dla modulu Powershella"
$location = -join($location, "\", "MySql.zip")
Invoke-WebRequest  -Uri https://github.com/adbertram/MySQL/archive/master.zip -OutFile  ( New-Item -Path "$location" -Force )
$modulesFolder =  'C:\Program Files\WindowsPowerShell\Modules'
Expand-Archive -Path  "$location" -DestinationPath $modulesFolder
Rename-Item -Path  "$modulesFolder\MySql-master" -NewName MySQL
echo "[*]Teraz podaj dane logowania do bazy danych"
$dbCred =  Get-Credential

Pause

