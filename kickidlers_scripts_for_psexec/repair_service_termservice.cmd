@echo off
sc query termservice > nul
IF ERRORLEVEL 0 (
	echo "%COMPUTERNAME%: termservice is exists, Exit"
	exit 0
) ELSE (
	rem ������ ����, ������ ��������� ��� �� ������� ����� �������
	regedit /s \\esmc\distr\kickidler-agent\termsrv.reg
	IF ERRORLEVEL 0 (
		echo "%COMPUTERNAME%: SUCCESS importing reg"
	) ELSE (
		echo "%COMPUTERNAME%: ERROR importing reg"
	)
)
