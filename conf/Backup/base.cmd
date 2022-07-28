rem ��� ��� 1�
rem � ⠪��� ��ࠬ��ࠬ� nnbackup ��娢���� ���� � ��� �஭㬥஢����� zip-䠩���
rem ������⢮ 䠫�� � ��� 10.
rem ��� 䠩� ����᪠���� 2 ࠧ� � ����, �.�. �� 2 䠩��-��娢� � ����, 5 ���� 10 䠩���.
rem
rem
rem ���᮪ ��४�਩ ����� �㦭� ��娢�஢��� ��室���� � 䠩�� list.txt
rem -log "log\%%DD%%_%%MM%%_%%hh%%�.log"
rem -log log\%%DD%%_%%MM%%_%%YYYY%%.log

setlocal

set path=%path%;%programfiles%\nnbackup\
set path=%path%;%programfiles%\winrar\

cd G:\exch

rem ����� ���筨�
set FROM=1C
rem ����� �����祭��
set DEST=G:\Backup
rem ��� 䠩�� ��᫥ �����襭�� ����஢����
SET FILENAME=%%DD%%_%%MM%%_%%YYYY%%-���1�

nnbackup ver -i %FROM% -o %DEST% -n 30 -s -v -m @list.txt -x @xmask.txt -log log.log -sdn "%FILENAME%" -rps -dira %DEST% -ra "rar a -m5 -r -s -t -df -y 01_%FILENAME%.rar 01_%FILENAME%"

rem ---------------------------------------------------------------------------
rem ��娢������ ���⭮��� �।�����
rem ����� ���筨�
set FROM2=���⭮��� �।�����
rem ����� �����祭��
set DEST2=G:\Backup
rem ��� 䠩�� ��᫥ �����襭�� ����஢����
SET FILENAME2=%%DD%%_%%MM%%_%%YYYY%%-���⭮��� �।�����

nnbackup copy -i "E:\%FROM2%" -o "%temp_backup%\%FROM2%" -x @xmask.txt -s -v
nnbackup verz -i "%temp_backup%\%FROM2%" -o "%DEST2%\%FROM2%" -v -n 10 -zl 9 -s -sdn "%FILENAME2%"

rem 㤠�塞 ����� � �ᥬ ᮤ�ন��
rmdir %temp_backup% /S /Q
rem ᮧ���� 㤠������ �����
mkdir %temp_backup%

endlocal