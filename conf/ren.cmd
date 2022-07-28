rem изменение поля Описание компьютера и имени компьютера, работает только после перезагрузки
rem имя пользователя
set name=Загинайко
rem имя компьютера
set comp=158-BORODKIN
rem новое имя компьютера
set newname=108-1

REG ADD \\%comp%\HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters /v "srvcomment" /t REG_SZ /d "%name%" /f
netdom renamecomputer %comp% /newname:%newname% /userD:rif\pavelik /passwordd:Ukjrfz819 /usero:rif\pavelik /passwordo:Ukjrfz819 /force /reboot:0
