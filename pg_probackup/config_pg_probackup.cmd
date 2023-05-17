@echo off
rem в этом файле опишу по порядку команды которые я использовал для настроийки этого ПО.
setlocal 
rem ENABLEEXTENSIONS
rem IF ERRORLEVEL 1 echo Не удается включить расширенную обработку
set path=%path%;C:\Program Files\PostgresPro\pg_probackup\common-13\bin\
set datadir_copy="F:\BACKUP\pg_probackup"
set PGPASSWORD=backup
set LC_MESSAGES=en
rem инициализация папки
rem pg_probackup.exe init -B %datadir_copy%
rem добавить базу, у меня это D:\KickidlerDatabase\data
rem pg_probackup add-instance -B %datadir_copy% -D "D:\KickidlerDatabase\data"  --instance kickidler
rem настроить проверку целостности в каждой базе, у меня это kickidler_node
rem psql -U postgres -h "127.0.0.1" -p "5432" -d "kickidler_node" -c "CREATE EXTENSION amcheck;"
rem psql -U "postgres" -h "127.0.0.1" -p "5432" -d "kickidler_node" -f "grand_rules_for_backup.sql"
rem show configuration
rem pg_probackup show-config -B %datadir_copy% --instance kickidler
rem set configuration
rem pg_probackup set-config -B %datadir_copy% --instance kickidler -U "backup" -h "127.0.0.1" -p "5432" -d "backup" --retention-window=7 --retention-redundancy=2
IF "%1" == "delta" (
echo "inputed DELTA" 
rem run DELTA backup
rem 
pg_probackup backup -B %datadir_copy% --instance kickidler -b DELTA -j2 --stream --temp-slot --delete-expired --progress --compress
exit 0
)
IF "%1" == "full" (
echo "inputed FULL"
rem run FULL backup
pg_probackup backup -B %datadir_copy% --instance kickidler -b FULL -j2 --stream --temp-slot --delete-expired --progress --compress
exit 0
)
IF "%1" == "show" (
rem show contains backup
pg_probackup show -B %datadir_copy% --instance kickidler
exit 0
)

echo "you must use parameter:"
echo "		config_pg_probackup.cmd delta - run increment backup"
echo "		config_pg_probackup.cmd full - run full backup"
echo "		config_pg_probackup.cmd show - show backups in storage %datadir_copy%"
endlocal