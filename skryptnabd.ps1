echo "[*] Witaj! Upewnij sie ze masz uprawnienia administratora aby zainstalowac ta zaleznosc: Simply-SQL"
Pause
#Install-Module -Name SimplySql -RequiredVersion 1.6.2
Open-MySqlConnection -DataSource "localhost" -InitialCatalog "baza_danych"
Show-SqlConnection