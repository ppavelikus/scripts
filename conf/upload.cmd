rem ����� 䠩� ����室�� ��� ᪠稢���� ��� �� ���-�����
setlocal
rem ����� � ������(�஡���� � ����� ���� �� ������)
set upd=d:/update
rem url � ���ண� ���� ᪠稢���
set url=http://internet/nod/
rem set
rem ᮡ�⢥��� ᠬ� �������� �� ����㧪�
rem ��ࠬ���� ������
rem -r  ४��ᨢ��� ����㧪�
rem -np �� ����������� �� �஢��� ���
rem -nH �� ᮧ������ ��� ᠩ�
rem -P ��� ��⠫��� � ����� ���� ����஢����� ����
rem

set path=%path%;%programfiles%/GnuWin32/bin
wget -r -np -nH --cut-dirs=1 -P %upd% -t 5 %url%
endlocal