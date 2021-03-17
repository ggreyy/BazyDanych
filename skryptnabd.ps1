


echo "[*] Uruchom ten program w trybie administratora, zeby zainstalowac zaleznosci. Jesli tego nie zrobiles to wyjdz CTRL + C"
Pause
Install-Module -Name SimplySql -RequiredVersion 1.6.2 -Scope CurrentUser -verbose
