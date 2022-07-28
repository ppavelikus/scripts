rem ------------------------------------------------------------------------------
rem выполнение на удаленном(ых) компьютерах команды start.cmd
rem перечень обрабатываемых компьютеров хранить в файле filess
rem корректная работа скрипта гарантирована на windws server 2003
rem дело в том что в Windows XP команда net share не поддерживает параметр GRANT
rem устанавливающий права доступа к каталогам
rem ------------------------------------------------------------------------------

rem set path=%path%;D:\bin\sysint\Pstools
cd %~dp0

call netshare.cmd

set log=\\%COMPUTERNAME%\log$\LOG.LOG

psexec.exe -u rif\pavelik -p Ukjrfz819 -s @filess \\%computername%\soft$\start.cmd


call delshare.cmd
