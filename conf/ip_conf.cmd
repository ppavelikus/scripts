rem ����ன�� ����䥩ᮢ
setlocal
rem ����� ... �᫨ ��⠢��� �����, � ������� �믮������, �᫨ ���, � ��������������
set addd=
set dell=rem

rem if "%1"=="" (
rem	@echo "�롥� ����⢨�, �������� ��� 㤠����"
rem )else (


%addd% netsh interface ip add address "������祭�� �� �����쭮� ��" 192.168.5.2  255.0.0.0
%addd% netsh interface ip add address "������祭�� �� �����쭮� ��" 192.168.0.100  255.0.0.0
%addd% netsh interface ip add address "������祭�� �� �����쭮� ��" 192.168.3.100  255.0.0.0

%dell% netsh interface ip delete address "������祭�� �� �����쭮� ��" 192.168.5.2
%dell% netsh interface ip delete address "������祭�� �� �����쭮� ��" 192.168.0.100
%dell% netsh interface ip delete address "������祭�� �� �����쭮� ��" 192.168.3.100
endlocal