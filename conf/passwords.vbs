Option Explicit
Dim objComputer ' ��������� ������� Computer
Dim objUser ' ��������� ������� User
Dim strComputer ' ��� ����������
Dim strUser ' ��� ������������ ������������
Dim strpass ' ������ ������������
Dim objSysInfo '������ ��� �������� ������� ����������, ��������� �� AD
Dim arrFULLNAME '��������� ������
Dim arrCN '��������� ������

Set objSysInfo = CreateObject("ADSystemInfo")
strComputer = objSysInfo.ComputerName
arrFULLNAME = Split(strComputer, ",")
arrCN = Split(arrFULLNAME(0), "=")

strComputer=arrCN(1)

strUser = "admin"
strpass = "adminKjrfk"

Set objUser = GetObject("WinNT://" & strComputer & "/" & strUser)
objUser.Description = "������ ������� ��� ������ �������"
objUser.SetPassword strpass
objUser.SetInfo