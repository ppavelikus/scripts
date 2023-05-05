@echo off
sc query ngs > nul
rem reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TermService"
rem есть служба NGS, 
IF %ERRORLEVEL% == 0 (
echo "%COMPUTERNAME%: Service ngs is installed. Removing"
MsiExec.exe /X{EB1FBC37-0B97-4CF5-A329-CF28BA653748} /quiet /l*x \\kscs\log$\kickidler-agent\%COMPUTERNAME%.log
rem echo "%COMPUTERNAME%: Has keys in register"
) ELSE (
echo "%COMPUTERNAME%: Can't find service ngs"
)
