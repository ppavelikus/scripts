'pavelik 7.06.2017
'������ ��� ��������� ��������� ������� � ������.
'������ ������ ������:
'  ������ ������ ��������� ��� ������������� ������� clear_list_mailbox_hmailserver.vbs, ����������� ���� csv
'  �������� � ��������� ���� �������� ������, � ������� ���� ��������� �����.
'

Set objArgs = WScript.Arguments
Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )

Dim gSize

if objArgs.Count - 1 < 0 then
    WScript.echo "�������������: change_size_hmailserver.vbs: <������> <��� �����> <������> <�����>"
    WScript.echo "���������:"
	WScript.echo "<������> - ������� ������ � �� (10,50,100)"
    WScript.echo "<��� �����> -  ��������� ���� txt, ���� ������ �������� �� ������� � �������"
    WScript.echo "<������> -     ������� � ������� hmailserver"
    WScript.echo "<�����> -      ��� ������ �� ������� hmailserver ���� ����� ��������� ������"
    WScript.Quit

else

'���� ���������� ������ 1-�� �� ����������� ��������
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) )  OR ( isNull(objArgs(3)) ) then
    	WScript.Echo "�� ������ ������� ���� � 3-� ����������, ������ ��������� ���������"
    	WScript.Quit
    end if
    gSize = objArgs(0)
    gFileName = objArgs(1)
   	gPassWordServer = objArgs(2)
	GlobalDomain = objArgs(3)
end if

'�������� ����� ���������� ������
Set theFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & gFileName, 1)
   Do While theFile.AtEndOfStream <> True
      ChangeSizeMailBox theFile.ReadLine
   Loop
   theFile.Close

'��������� ��������� ������� � ������ �� ����-������
Sub ChangeSizeMailBox(ByVal Address)
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
 Set obAccount = obDomain.Accounts.ItemByAddress(Address)
 ' Set the password to "secret"
 obAccount.MaxSize = gSize
 obAccount.Save
End Sub
