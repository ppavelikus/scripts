setlocal
rem зарубить на корню использование файлов autorun.inf

set KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer
REG ADD "%KEY%" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xff /f
REG ADD "%KEY%" /v "NoDriveAutoRun" /t REG_DWORD /d 0xff /f
REG ADD "%KEY%" /v "NoFolderOptions" /t REG_DWORD /d 00000000 /f

set KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL
REG ADD "%KEY%" /v "CheckedValue" /t REG_DWORD /d 00000001 /f

set KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf
REG ADD "%KEY%" /ve /t REG_SZ /d "@SYS:DoesNotExist" /f

endlocal
