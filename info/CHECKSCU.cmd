$Date: 2009-05-05 14:14:14 +0300 (Вт, 05 май 2009) $
$Rev: 10 $
@REM Written BoaSoft aka Yuru
@REM Last Edited  02.05.2009
@echo off
rem cd %~dp0

reg export HKLM\SYSTEM\Setup\Pid .\scu.txt >nul

set SCU=

rem �஢�ઠ PID �� PRO VL
Find /I "270" ".\scu.txt" >nul
If "%ErrorLevel%"=="0" set SCU=VOLUM

rem �஢�ઠ PID �� PRO OEM
Find /I "OEM" ".\scu.txt" >nul
If "%ErrorLevel%"=="0" set SCU=OEM

rem �஢�ઠ PID �� HOME OEM
rem Find /I "OEM" ".\scu.txt" >nul
rem If "%ErrorLevel%"=="0" set SCU=HOMEOEM


echo "****************"
echo "⨯ ��業��� "
echo "****************"
echo "%SCU%"

pause
del .\scu.txt
