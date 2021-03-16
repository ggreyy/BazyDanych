$location = Read-host -Prompt "Podaj sciezke pliku wykonywalnego sql"
$var = -join($location, "/", "mysql");
& $var