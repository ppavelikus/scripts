SETLOCAL
PATH="C:\Program Files\1Cv77\BIN"
ECHO ...
ECHO Запуск на переиндыксацию баз
1cv7s config /M /DF:\1SBDB /nГордеев /pakro /@G:\exch\reindex.prm
1cv7s config /M /DF:\PRBasic /nгордеев /pakro /@G:\exch\reindex.prm
rem 1cv7s config /M /D"F:\Концерн Бухгалтерия (Новая)" /@G:\exch\reindex.prm
1cv7s config /M /D"F:\Концерн Зарплата" /nГордеев /pakro /@G:\exch\reindex.prm
ENDLOCAL