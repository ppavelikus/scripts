rem Бэкап баз 1С
rem С такими параметрами nnbackup архивирует базы в стэк пронумерованных zip-файлов
rem количество фалов в стэке 10.
rem этот файл запускается 2 раза в день, т.е. по 2 файла-архива в день, 5 дней 10 файлов.
rem
rem
rem Список директорий которые нужно архивировать находится в файле list.txt
rem -log "log\%%DD%%_%%MM%%_%%hh%%ч.log"
rem -log log\%%DD%%_%%MM%%_%%YYYY%%.log

setlocal

set path=%path%;%programfiles%\nnbackup\
set path=%path%;%programfiles%\winrar\

cd G:\exch

rem папка источник
set FROM=1C
rem папка назначения
set DEST=G:\Backup
rem имя файла после завершения копирования
SET FILENAME=%%DD%%_%%MM%%_%%YYYY%%-Бэкап1С

nnbackup ver -i %FROM% -o %DEST% -n 30 -s -v -m @list.txt -x @xmask.txt -log log.log -sdn "%FILENAME%" -rps -dira %DEST% -ra "rar a -m5 -r -s -t -df -y 01_%FILENAME%.rar 01_%FILENAME%"

rem ---------------------------------------------------------------------------
rem архивируется Отчетность предприятия
rem папка источник
set FROM2=Отчетность предприятия
rem папка назначения
set DEST2=G:\Backup
rem имя файла после завершения копирования
SET FILENAME2=%%DD%%_%%MM%%_%%YYYY%%-Отчетность Предприятия

nnbackup copy -i "E:\%FROM2%" -o "%temp_backup%\%FROM2%" -x @xmask.txt -s -v
nnbackup verz -i "%temp_backup%\%FROM2%" -o "%DEST2%\%FROM2%" -v -n 10 -zl 9 -s -sdn "%FILENAME2%"

rem удаляем папку со всем содержимым
rmdir %temp_backup% /S /Q
rem создаем удаленную папку
mkdir %temp_backup%

endlocal