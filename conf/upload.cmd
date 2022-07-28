rem данный файл необходим для скачивания баз из веб-папки
setlocal
rem папка с базами(пробелов в имени быть не должно)
set upd=d:/update
rem url с которого надо скачивать
set url=http://internet/nod/
rem set
rem собственно сама кодманда на загрузку
rem параметры команд
rem -r  рекурсивная загрузка
rem -np не подниматься на уровень выше
rem -nH не создавать имя сайта
rem -P имя каталога в который будут копироваться базы
rem

set path=%path%;%programfiles%/GnuWin32/bin
wget -r -np -nH --cut-dirs=1 -P %upd% -t 5 %url%
endlocal