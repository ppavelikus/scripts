rem ���� ��� ���� ���� ���㬥�⮢
rem ���६��⭮� ����஢���� � ��� �����, ��᫥ ����� ����஢���� ����᪠���� ��娢��� rar
rem ����� ᮧ���� ��娢 � ���ᨬ���� ᦠ⨥� � 㤠��� �६���� 䠩��
rem ------------------------------------------------------------------------------
rem ���� nnbackup
rem ------------------------------------------------------------------------------
rem -sa			-���뢠�� �ࠢ� ����㯠
rem -rps 		-�믮����� �ਫ������, 㪠������ � ��樨 -ra, ⮫쪮 � ��砥 �ᯥ譮�� �����襭�� �᭮����� �����
rem -nozip 		-�� ᦨ���� ᮧ������� ����� �� ������� zip
rem -s 			-���뢠�� �������� ��⠫��� �� ����஢����
rem -v			-�⮡ࠦ��� ��� �����㥬�� 䠩���
rem -x "mask"     	-�������� ��᪠
rem -dn "name" 		-��� ᮧ��������� �����
rem -dira "path"	-��⠭����� ⥪�騩 ��⠫�� ��� �ਫ������, 㪠������� � ��樨 -ra
rem -ra	"command"	-�믮����� �ਫ������ �ࠧ� �� ����砭�� �᭮����� �����
rem ------------------------------------------------------------------------------
rem ���� rar
rem ------------------------------------------------------------------------------
rem -m5		-�⥯��� ᦠ�� 1..5
rem -r		-४��ᨢ��
rem -s		-�����뢭� ��娢
rem -t		-��� �� ����稥 �訡��
rem -df		-㤠����� ��室�� 䠩���
rem -EP1	-�᪫���� ������� ����� �� ���
rem -y		-�� �� ������⢥��� "yes"
rem ------------------------------------------------------------------------------
setlocal
set path=%path%;%programfiles%\nnbackup\
set path=%path%;%programfiles%\winrar\


rem cd G:\exch

rem ����� ���筨�
set FROM="E:\��� ���㬥���"
rem ����� �����祭��
set DEST="C:\Backup"
rem ��� 䠩�� ��᫥ �����襭�� ����஢����
SET FILENAME=%%DumpLevel @%%_%%DD%%-%%MM%%-%%YYYY%%_���㬥���_157-srv
SET LOG=log.log

rem nnbackup dump %1 -i %FROM% -o %DEST% -p -s -sa -m @list.txt -x @xmask.txt -dn "%FILENAME%" -log log -extzip RAR
nnbackup dump %1 -i %FROM% -o %DEST% -m @list.txt -x @xmask.txt -rps -s -sa -v -log %LOG% -nozip -dn "%FILENAME%" -dira %DEST% -ra "rar a -m5 -r -s -t -df -y %FILENAME%.rar %FILENAME%"
rem -m @Llist.txt -x @xmask.txt
rem �᫨ �訡�� �� �믮������ � ��ࠢ�塞 ���쬮 ������
IF %ERRORLEVEL% NEQ 0 (
call message.vbs "nnBackup@mail" "157-srv �訡��" "�訡�� - %ERRORLEVEL% �� �믮������ ��娢�஢���� �ணࠬ��� nnBackup �� �ࢥ� 157-srv." "c:\\tls\%LOG%"
del %LOG% >nul
) ELSE (
call message.vbs "nnBackup@mail" "157-srv �ᯥ�" "�믮���� ���� �� �ࢥ� �ணࠬ��� nnBackup. ������ %DEST%%FILENAME%" "c:\\tls\%LOG%"
del %LOG% >nul
)

endlocal
