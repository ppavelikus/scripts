'Разработал pavelik 13/03/2012
'скрипт для очистки ящика от сообщений, нужен в случае если ящик давно не используется
'или переполнен и нужно удалить все письма
'Также добавлена возможность получения списка Ящик;Заполненный объем

Set objArgs = WScript.Arguments
Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )



if objArgs.Count - 1 < 0 then
    WScript.echo "Использование: delete_messages_in_hmailserver.vbs clear/listsize <пароль> <домен> <адрес>"
    WScript.echo "Параметры:"
	WScript.echo "clear/listsize - очистка ящика/создание перечня ящик:размер    "
    WScript.echo "<пароль> -     доступа к серверу hmailserver"
    WScript.echo "<домен> -      имя домена на сервере hmailserver куда будут добавлены адреса"
    WScript.echo "<адрес> -      коротко почтовый адрес, например admin ,а не admin@mail.rif.ru ТРЕБУЕТСЯ только при параметре clear"
    WScript.Quit
else
'Если аргументов больше 1-го то присваиваем значение
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) ) then
    	WScript.Echo "Вы забыли указать один и 3-х параметров, работа программы завершена"
    	WScript.Quit
    end if
    gVar = objArgs(0)
   	gPassWordServer = objArgs(1)
	GlobalDomain = objArgs(2)
	'проверяем зависимость, если очистка то ждем еще email
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
			WSCript.Echo "Вообщем вы не так ввели, скорее всего не правильно написали первый операнд"
			WScript.Quit
End Select


'Очистка введеннного адреса от писем
'в качестве параметра принимает логин, полный адрес передавать ненужно
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
 WScript.Echo "Вывод перечня адресов сохранен в файл " & objShell.CurrentDirectory & "\ListAdress.csv"
End Sub