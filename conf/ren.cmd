rem ��������� ���� ���ᠭ�� �������� � ����� ��������, ࠡ�⠥� ⮫쪮 ��᫥ ��१���㧪�
rem ��� ���짮��⥫�
set name=���������
rem ��� ��������
set comp=158-BORODKIN
rem ����� ��� ��������
set newname=108-1

REG ADD \\%comp%\HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters /v "srvcomment" /t REG_SZ /d "%name%" /f
netdom renamecomputer %comp% /newname:%newname% /userD:rif\pavelik /passwordd:Ukjrfz819 /usero:rif\pavelik /passwordo:Ukjrfz819 /force /reboot:0
