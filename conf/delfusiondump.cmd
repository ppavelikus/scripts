for /F %%i in (\\rif-serv\LOG$\tmp\comps.txt) do (
if %computername%==%%i EXIT
)

rem проверка на разрядность.
if %PROCESSOR_ARCHITECTURE% == x86 (
	IF NOT EXIST "%ProgramFiles%\FusionInventory-Agent" (
	EXIT
	)
	rem удаление файла с device_id
	del "%programfiles%\FusionInventory-Agent\var\FusionInventory-Agent.dump" /q /f
) ELSE (
	IF NOT EXIST "%ProgramFiles (x86)%\FusionInventory-Agent" (
	EXIT
	)
	rem удаление файла с device_id
	del "%ProgramFiles (x86)%\FusionInventory-Agent\var\FusionInventory-Agent.dump" /q /f
)

rem запись результата
echo %computername% %date% %time% >> \\rif-serv\LOG$\tmp\comps.txt
