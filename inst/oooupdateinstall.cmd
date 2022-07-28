rem —крипт выполн€ет инстал€цию пакетов расширени€ дл€ OOO версии 3.2.1
rem с помощью комманды unopkg.com поставл€емой вместе с пакетом openOffice
setlocal
set path=%path%;%programfiles%\OpenOffice.org 3\program\
unopkg.com add --shared T:\Office\OpenOffice\ADDONS\dict_ru_ru-0.6.oxt --log-file \\rif-serv\log$\%COMPUTERNAME%.LOG
unopkg.com add --shared T:\Office\OpenOffice\ADDONS\languagetool-1.0.0.oxt --log-file \\rif-serv\log$\%COMPUTERNAME%.LOG
endlocal