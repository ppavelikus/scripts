rem ------------------------------------------------------------------------------
rem �믮������ �� 㤠������(��) ��������� ������� start.cmd
rem ���祭� ��ࠡ��뢠���� �������஢ �࠭��� � 䠩�� filess
rem ���४⭠� ࠡ�� �ਯ� ��࠭�஢��� �� windws server 2003
rem ���� � ⮬ �� � Windows XP ������� net share �� �����ন���� ��ࠬ��� GRANT
rem ��⠭�������騩 �ࠢ� ����㯠 � ��⠫����
rem ------------------------------------------------------------------------------

rem set path=%path%;D:\bin\sysint\Pstools
cd %~dp0

call netshare.cmd

set log=\\%COMPUTERNAME%\log$\LOG.LOG

psexec.exe -u rif\pavelik -p Ukjrfz819 -s @filess \\%computername%\soft$\start.cmd


call delshare.cmd
