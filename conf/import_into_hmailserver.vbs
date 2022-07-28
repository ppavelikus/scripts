'���������� pavelik 2/06/2011
'������ ��� ������� ����� � ��� �������� hMailServer�� ���������� ����� csv
'����������:
'��� ���������� ������ ���������� ��������� LogParser 2, ��� COM - ������ ���������� ��� �������� csv �����
'������������ � ����� ������ ���� ������� ����� �� ���������
'���� ������ ���� ���� ���,login,passwd

'On error Resume Next ' � ������ ����� ���� ������ "����" ������

Dim CSVInputFormat
Dim oLogQuery
Dim strQuery
Dim oRecordSet
Dim oRecord
Dim strClientIp
Dim gFileNAme '��� ����� � ��������
Dim PassWordServer '������ ��� ������� � ������� hMailServer
Dim GlobalDomain ' ��� ������ �� ������� hMailServer
Dim DistributionListAdress '��� ������ ��������
Dim gVar '������ �������� ��� ���� ����� ���������� ����� �������� �������, �������� ������ ��� �������� � ������
Dim MyFile
Set oLogQuery = CreateObject("MSUtil.LogQuery")

Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )

Set MyFile = objFSO.CreateTextFile(objShell.CurrentDirectory & "\errfile_distrlist.log", True)

Set objArgs = WScript.Arguments

'�������� �� ���������� ����������, ���� ������ 1-�� ��������� ������
'WScript.Echo "���������� ���������� " & objArgs.Count

if objArgs.Count - 1 < 0 then
    WScript.echo "�������������: import.vbs: <��������> <��� �����> <������> <�����>"
    WScript.echo "���������:"
	WScript.echo "<AddAdr/AddToList> - �������� ������ / �������� ������ � ��� ��������� ������ ��������"
    WScript.echo "<��� �����> -  ��������� ���� csv, ����������� ������������ ������� ���� �������, "
    WScript.echo "               � ���� ������ �������� �� 3-� ����� ���,�����,������ ����� ������ �� ���������"
    WScript.echo "<������> -     ������� � ������� hmailserver"
    WScript.echo "<�����> -      ��� ������ �� ������� hmailserver ���� ����� ��������� ������"
	WScript.echo "<Distribution list Name> -      ��� ������ ������ � ������� ����� ��������� ��������"
    WScript.Quit
else
'���� ���������� ������ 1-�� �� ����������� ��������
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) ) then
    	WScript.Echo "�� ������ ������� ���� � 3-� ����������, ������ ��������� ���������"
    	WScript.Quit
    end if
    gVar = LCase(objArgs(0))
	gFileNAme = objArgs(1)
	PassWordServer = objArgs(2)
	GlobalDomain = objArgs(3)
	'�������� �� ���������, ���� ��������� � ���� �� ��������� ��������
	if gVar = "addtolist" then
		DistributionListAdress = objArgs(4)
	end if
end if

' Create Input Format object
Set CSVInputFormat = CreateObject("MSUtil.LogQuery.CSVInputFormat")
CSVInputFormat.headerRow = OFF
' Create query text
strQuery = "SELECT * FROM " & "'" & gFileNAme & "'"

'WScript.Echo strQuery
' Execute query and receive a LogRecordSet
Set oRecordSet = oLogQuery.Execute ( strQuery, CSVInputFormat )

MyFile.WriteLine("�������� ....")
' Visit all records
DO WHILE NOT oRecordSet.atEnd

	' Get a record
	Set oRecord = oRecordSet.getRecord

	'�������� �������� ������
	strClient = oRecord.getValue ( 3 )
	'�������� �������� ������
	strClient2 = oRecord.getValue ( 4 )

	' �������� ��������� ������ ������������
	Select Case gVar
		Case "addadr"
			CreateLogin strClient, strClient2, GlobalDomain
		Case "addtolist"
			AddToList strClient, GlobalDomain, DistributionListAdress
		Case else
			WSCript.Echo "������� �� �����-�� ����� �� ��� �����, ������ ����� �� �������� �������� ������ �������"
			WScript.Quit
	End Select
	'����� � ��� ������������� ��������� �� �������
'	MyFile.WriteLine(strClient & "@" & strClient2 & ",Error #" & CStr(Err.Number) & "," & Err.Description)
	' Advance LogRecordSet to next record
	oRecordSet.moveNext

LOOP
MyFile.WriteLine("����� .... ")
' Close RecordSet
MyFile.Close
oRecordSet.close

' ��������� ����������,
'fLogin - ����� �����
'������ �����
'����� �����

Sub CreateLogin(ByVal fLogin, ByVal fPasswd, ByVal fDomain)
Dim obApp
Dim obAccount
Dim obDomain

Set obApp = CreateObject("hMailServer.Application")
Call obApp.Authenticate("Administrator", PassWordServer)
Set obDomain = obApp.Domains.ItemByName(fDomain)

'�������� �� ������������ ������ � ������, ���� ���� �� �� �������
if NOT isNull(obDomain.Accounts.ItemByAddress(fLogin & "@" & fDomain)) then
	'WScript.Echo "������������� ������ " & obDomain.Accounts.ItemByAddress(fLogin & "@" & fDomain).ID
	MyFile.WriteLine("������ " & fLogin & "@" & fDomain & " ��� ������� � ������")
	Exit Sub
end if
'WScript.Echo "��� � ����� ������ �����"
Set obAccount = obDomain.Accounts.Add
obAccount.Address = fLogin & "@" & fDomain
obAccount.Password = fPasswd
obAccount.Active = True
obAccount.MaxSize = 50 ' ��������� 50 �� � �����
obAccount.Save
MyFile.WriteLine("������ " & fLogin & "@" & fDomain & " ��������")
End Sub

'��������� ���������� ������� � ������ ��������
'fLogin - ������ �����
'fDomain - ��� ������ � ������� ���� ������
'fDistributionListAdress - ��� ������ ��������

Sub AddToList(ByVal fLogin, ByVal fDomain, ByVal fDistributionListAdress)
Dim obApp
Dim obAccount
Dim obDomain
Dim obList
Dim var

Set obApp = CreateObject("hMailServer.Application")
Call obApp.Authenticate("Administrator", PassWordServer)
Set obDomain = obApp.Domains.ItemByName(fDomain)


Set obAccount = obDomain.DistributionLists.ItemByAddress(fDistributionListAdress)
'�������� �� ������������ ������ � ������, ���� ���� �� �� �������
for var = 0 to obAccount.Recipients.Count - 1
	if obAccount.Recipients.Item(var).RecipientAddress = fLogin & "@" & fDomain then
	    ' ����������� � �����
		MyFile.WriteLine("������ " & fLogin & "@" & fDomain & " ��� ������� � ������")
		Exit Sub
	end if
Next

Set obList = obAccount.Recipients.Add

obList.RecipientAddress = fLogin & "@" & fDomain
obList.Save
' ����������� � �����
MyFile.WriteLine("������ " & fLogin & "@" & fDomain & " ��������")
End Sub
