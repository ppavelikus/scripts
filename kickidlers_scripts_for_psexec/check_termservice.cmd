@echo off
sc query termservice > nul
rem reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TermService"
rem есть служба TermService, 
IF %ERRORLEVEL% == 0 (
echo "%COMPUTERNAME%: Service TermService is installed"
rem echo "%COMPUTERNAME%: Has keys in register"
) ELSE (
echo "%COMPUTERNAME%: Can't find service TermService"
)