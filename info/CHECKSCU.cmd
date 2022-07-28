$Date: 2009-05-05 14:14:14 +0300 (╨Т╤В, 05 ╨╝╨░╨╣ 2009) $
$Rev: 10 $
@REM Written BoaSoft aka Yuru
@REM Last Edited  02.05.2009
@echo off
rem cd %~dp0

reg export HKLM\SYSTEM\Setup\Pid .\scu.txt >nul

set SCU=

rem Проверка PID на PRO VL
Find /I "270" ".\scu.txt" >nul
If "%ErrorLevel%"=="0" set SCU=VOLUM

rem Проверка PID на PRO OEM
Find /I "OEM" ".\scu.txt" >nul
If "%ErrorLevel%"=="0" set SCU=OEM

rem Проверка PID на HOME OEM
rem Find /I "OEM" ".\scu.txt" >nul
rem If "%ErrorLevel%"=="0" set SCU=HOMEOEM


echo "****************"
echo "тип лицензии "
echo "****************"
echo "%SCU%"

pause
del .\scu.txt
