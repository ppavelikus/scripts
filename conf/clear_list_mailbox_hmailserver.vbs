'���������� pavelik 13/03/2012
'������ ��� ������� ����� �� ���������, ����� � ������ ���� ���� ����� �� ������������
'��� ���������� � ����� ������� ��� ������
'����� ��������� ����������� ��������� ������ ����;����������� �����

Set objArgs = WScript.Arguments
Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )



if objArgs.Count - 1 < 0 then
    WScript.echo "�������������: delete_messages_in_hmailserver.vbs clear/listsize <������> <�����> <�����>"
    WScript.echo "���������:"
	WScript.echo "clear/listsize - ������� �����/�������� ������� ����:������    "
    WScript.echo "<������> -     ������� � ������� hmailserver"
    WScript.echo "<�����> -      ��� ������ �� ������� hmailserver ���� ����� ��������� ������"
    WScript.echo "<�����> -      ������� �������� �����, �������� admin ,� �� admin@mail.rif.ru ��������� ������ ��� ��������� clear"
    WScript.Quit
else
'���� ���������� ������ 1-�� �� ����������� ��������
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) ) then
    	WScript.Echo "�� ������ ������� ���� � 3-� ����������, ������ ��������� ���������"
    	WScript.Quit
    end if
    gVar = objArgs(0)
   	gPassWordServer = objArgs(1)
	GlobalDomain = objArgs(2)
	'��������� �����������, ���� ������� �� ���� ��� email
	if gVar = "clear" then
		gAddress = objArgs(3)
	end if


end if

Select Case gVar
		Case "clear"
			ClearMailBox gAddress
		Case "listsize"
			ListSize
		Case else
			WSCript.Echo "������� �� �� ��� �����, ������ ����� �� ��������� �������� ������ �������"
			WScript.Quit
End Select


'������� ����������� ������ �� �����
'� �������� ��������� ��������� �����, ������ ����� ���������� �������
Sub ClearMailBox(ByVal Address)
 Dim obApp
 Set obApp = CreateObject("hMailServer.Application")
 ' Authenticate. Without doing this, we won't have permission
 ' to change any server settings or add any objects to the
 ' installation.
 Call obApp.Authenticate("Administrator", gPassWordServer)
 ' Locate the domain we want to add the account to
 Dim obDomain
 WScript.Echo GlobalDomain

 Set obDomain = obApp.Domains.ItemByName(GlobalDomain)

 Dim obAccount
 Set obAccount = obDomain.Accounts.ItemByAddress(Address & "@" & GlobalDomain)
 ' Set the password to "secret"
 obAccount.DeleteMessages()
End Sub

'
Sub ListSize ()

 Set MyFile = objFSO.CreateTextFile(objShell.CurrentDirectory & "\ListAdress.csv", True)
 MyFile.WriteLine("adress;size;maxsize")
 Dim obApp
 Set obApp = CreateObject("hMailServer.Application")
 ' Authenticate. Without doing this, we won't have permission
 ' to change any server settings or add any objects to the
 ' installation.
 Call obApp.Authenticate("Administrator", gPassWordServer)
 ' Locate the domain we want to add the account to
 Dim obDomain
 WScript.Echo GlobalDomain

 Set obDomain = obApp.Domains.ItemByName(GlobalDomain)

 for var = 0 to obDomain.Accounts.Count - 1
 	Set obAccount = obDomain.Accounts.Item(var)
    MyFile.WriteLine(obAccount.Address & ";" & obAccount.Size & ";" & obAccount.MaxSize)
 Next
 MyFile.Close
 WScript.Echo "����� ������� ������� �������� � ���� " & objShell.CurrentDirectory & "\ListAdress.csv"
End Sub