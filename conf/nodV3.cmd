setlocal
set KEY=HKEY_LOCAL_MACHINE\SOFTWARE\ESET\ESET Security\CurrentVersion\Plugins\01000400
set UPD=\\RIF-SERV\NOD
REG ADD "%KEY%\Profiles\@My profile" /v "SelectedServer" /t REG_SZ /d "%UPD%" /f
REG ADD "%KEY%\UI_Settings\Servers" /v "Server_0" /t REG_SZ /d "%UPD%" /f
endlocal
