@echo off
sc query termservice > nul
rem ���� ������ TermService, 
IF %ERRORLEVEL% == 0 (
rem ������ �������� ngs
	sc query ngs > nul
	IF %ERRORLEVEL% == 0 (
		rem �� � ������� �� ���������� ngs
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