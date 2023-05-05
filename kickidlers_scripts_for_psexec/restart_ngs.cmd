@echo off
sc query termservice > nul
rem есть служба TermService, 
IF %ERRORLEVEL% == 0 (
rem теперь проверим ngs
	sc query ngs > nul
	IF %ERRORLEVEL% == 0 (
		rem ну и команды на перезапуск ngs
		net stop ngs > nul && net start ngs > nul
		IF ERRORLEVEL 0 (
		echo "%COMPUTERNAME%: SUCCESS restarting service ngs"
		) ELSE (
		echo "%COMPUTERNAME%: Error restarting service ngs"
		)
	) ELSE (
	echo "%COMPUTERNAME%: Can't find service ngs"
	)
) ELSE (
echo "%COMPUTERNAME%: Can't find service TermService"
)