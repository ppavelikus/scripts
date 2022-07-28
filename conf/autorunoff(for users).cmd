setlocal
rem запретить автозапуск с любых дисков
set KEY=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
REG ADD "%KEY%" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xff /f

endlocal
