rem Файл для бэкапа Общих документов
rem Инкрементное копирование в стэк папок, после процесса копирования запускается архиватор rar
rem который создает архив с максимальным сжатием и удаляет временные файлы
rem ------------------------------------------------------------------------------
rem Ключи nnbackup
rem ------------------------------------------------------------------------------
rem -sa			-учитывать права доступа
rem -rps 		-выполнить приложение, указанное в опции -ra, только в случае успешного завершения основного процесса
rem -nozip 		-не сжимать создаваемые дампы по алгоритму zip
rem -s 			-учитывать вложенные каталоги при копировании
rem -v			-отображать пути копируемых файлов
rem -x "mask"     	-запрещающая маска
rem -dn "name" 		-имя создаваемого дампа
rem -dira "path"	-установить текущий каталог для приложения, указанного в опции -ra
rem -ra	"command"	-выполнить приложение сразу по окончании основного процесса
rem ------------------------------------------------------------------------------
rem Ключи rar
rem ------------------------------------------------------------------------------
rem -m5		-степень сжатия 1..5
rem -r		-рекурсивно
rem -s		-непрерывный архив
rem -t		-тест на наличие ошибок
rem -df		-удаление исходны файлов
rem -EP1	-исключить базовую папку из пути
rem -y		-на все запросыотвечать "yes"
rem ------------------------------------------------------------------------------
setlocal
set path=%path%;%programfiles%\nnbackup\
set path=%path%;%programfiles%\winrar\


rem cd G:\exch

rem папка источник
set FROM="E:\Мои документы"
rem папка назначения
set DEST="C:\Backup"
rem имя файла после завершения копирования
SET FILENAME=%%DumpLevel @%%_%%DD%%-%%MM%%-%%YYYY%%_документы_157-srv
SET LOG=log.log

rem nnbackup dump %1 -i %FROM% -o %DEST% -p -s -sa -m @list.txt -x @xmask.txt -dn "%FILENAME%" -log log -extzip RAR
nnbackup dump %1 -i %FROM% -o %DEST% -m @list.txt -x @xmask.txt -rps -s -sa -v -log %LOG% -nozip -dn "%FILENAME%" -dira %DEST% -ra "rar a -m5 -r -s -t -df -y %FILENAME%.rar %FILENAME%"
rem -m @Llist.txt -x @xmask.txt
rem если ошибка при выполнении то отправляем письмо админу
IF %ERRORLEVEL% NEQ 0 (
call message.vbs "nnBackup@mail" "157-srv Ошибка" "Ошибка - %ERRORLEVEL% при выполнении архивирования программой nnBackup на сервере 157-srv." "c:\\tls\%LOG%"
del %LOG% >nul
) ELSE (
call message.vbs "nnBackup@mail" "157-srv Успех" "Выполнен дамп на сервере программой nnBackup. Создан %DEST%%FILENAME%" "c:\\tls\%LOG%"
del %LOG% >nul
)

endlocal
