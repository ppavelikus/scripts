rem настройка интерфейсов
setlocal
rem Флаги ... если оставить пустым, то команды выполнятся, если нет, то закоментируются
set addd=
set dell=rem

rem if "%1"=="" (
rem	@echo "выбери действие, добавить или удалить"
rem )else (


%addd% netsh interface ip add address "Подключение по локальной сети" 192.168.5.2  255.0.0.0
%addd% netsh interface ip add address "Подключение по локальной сети" 192.168.0.100  255.0.0.0
%addd% netsh interface ip add address "Подключение по локальной сети" 192.168.3.100  255.0.0.0

%dell% netsh interface ip delete address "Подключение по локальной сети" 192.168.5.2
%dell% netsh interface ip delete address "Подключение по локальной сети" 192.168.0.100
%dell% netsh interface ip delete address "Подключение по локальной сети" 192.168.3.100
endlocal