set path=%path%;D:\bin\sysint\Pstools
rem Запуск сетевого приложения, причем формируется файл лог wer.log
psexec.exe -u rif\pavelik -p Ukjrfz819 \\* \\RIF-ADM\install\info.cmd 2>> wer.log
