'pavelik 7.06.2017
'Скрипт для массового изменение размера в ящиках.
'Откуда список ящиков:
'  Список ящиков получеаем при использовании скрипта clear_list_mailbox_hmailserver.vbs, анализируем файл csv
'  копируем в текстовый файл названия ящиков, в которых надо увеличить объем.
'

Set objArgs = WScript.Arguments
Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )

Dim gSize

if objArgs.Count - 1 < 0 then
    WScript.echo "Использование: change_size_hmailserver.vbs: <Размер> <Имя файла> <пароль> <домен>"
    WScript.echo "Параметры:"
	WScript.echo "<Размер> - указать размер в МБ (10,50,100)"
    WScript.echo "<Имя файла> -  текстовый файл txt, файл должен состоять из адресов в столбик"
    WScript.echo "<пароль> -     доступа к серверу hmailserver"
    WScript.echo "<домен> -      имя домена на сервере hmailserver куда будут добавлены адреса"
    WScript.Quit

else

'Если аргументов больше 1-го то присваиваем значение
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) )  OR ( isNull(objArgs(3)) ) then
    	WScript.Echo "Вы забыли указать один и 3-х параметров, работа программы завершена"
    	WScript.Quit
    end if
    gSize = objArgs(0)
    gFileName = objArgs(1)
   	gPassWordServer = objArgs(2)
	GlobalDomain = objArgs(3)
end if

'открытие файла построчное чтение
Set theFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & gFileName, 1)
   Do While theFile.AtEndOfStream <> True
      ChangeSizeMailBox theFile.ReadLine
   Loop
   theFile.Close

'процедура изменения размера в ящиках из файл-списка
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
