@echo off
rem setlocal
rem 
rem set comp=FABKONST01
rem echo %comp%
rem ..\psexec.exe \\%comp% -s C:\Windows\System32\msiexec.exe /i \\esmc\distr\kickidler-agent\grabber.x64.msi ALLUSERS=1 INVITE=a08e4a5238b4517a9eeccbe51aa722f1f57c8e04 /l*x \\kscs\log$\kickidler-agent\%comp%.log /quiet 
rem ..\psexec.exe @list2.lst -s C:\Windows\System32\msiexec.exe /i \\esmc\distr\kickidler-agent\grabber.x64.msi ALLUSERS=1 INVITE=5fd6c1217f6a5f4b664949672a1ec88ed163b3a6 /l*x \\esmc\log$\kickidler-agent\%comp%.log /quiet
rem endlocal

rem  sc query ngs > nul
rem reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TermService"
rem есть служба NGS, 
rem  IF %ERRORLEVEL% == 0 (
rem    echo "%COMPUTERNAME%: Service ngs is installed. Stopped."
rem    exit 0
rem    rem echo "%COMPUTERNAME%: Has keys in register"
rem  ) ELSE (
rem    echo "%COMPUTERNAME%: Installing service ngs"
rem    C:\Windows\System32\msiexec.exe /i \\esmc\distr\kickidler-agent\grabber.x64.msi ALLUSERS=1 INVITE=a08e4a5238b4517a9eeccbe51aa722f1f57c8e04 /l*x \\kscs\log$\kickidler-agent\%COMPUTERNAME%.log /quiet
rem  )

sc query termservice > nul
rem reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TermService"
rem есть служба TermService, 
IF %ERRORLEVEL% == 0 (
  rem echo "%COMPUTERNAME%: Service TermService is installed"
  rem echo "%COMPUTERNAME%: Has keys in register"
) ELSE (
  rem Службы нету, значит выполняем код по импорту ветки реестра
  regedit /s \\esmc\distr\kickidler-agent\termsrv.reg
  IF ERRORLEVEL 0 (
  	echo "%COMPUTERNAME%: SUCCESS importing reg"
  ) ELSE (
  	echo "%COMPUTERNAME%: ERROR importing reg"
  )
  echo "%COMPUTERNAME%: Can't find service TermService. Exit..."
  exit 1
)

IF EXIST "%programfiles%\TeleLinkSoftHelper" (
  echo "%COMPUTERNAME%: Folder TeleLinkSoftHelper is exist."
  rem check abount service ngs
  sc query ngs > nul
  IF %ERRORLEVEL% NEQ 0 (
    echo "%COMPUTERNAME%: Registering service ngs"
    sc create ngs binPath= "C:\Program Files\TeleLinkSoftHelper\bin\grabber.exe" start= auto displayname= "Tele Link Soft Helper"
    net start ngs > nul
  ) ELSE (
    echo "%COMPUTERNAME%: Restarting TeleLinkSoftHelper..."
    net stop ngs > nul
    net start ngs > nul
  )
  rem echo "%COMPUTERNAME%: Service TermService is installed"
  rem echo "%COMPUTERNAME%: Has keys in register"
) ELSE (
  echo "%COMPUTERNAME%: Installing service ngs"
  C:\Windows\System32\msiexec.exe /i \\esmc\distr\kickidler-agent\grabber.x64.msi ALLUSERS=1 INVITE=bb9c5f747243209ac224ed269f67bdf27efd218f /l*x \\kscs\log$\kickidler-agent\%COMPUTERNAME%.log /quiet
)
