'Разработал pavelik 2/06/2011
'Скрипт для импорта почты в наш почтовик hMailServerиз текстового файла csv
'требования:
'для нормальной работы необходимо устновить LogParser 2, его COM - модель используем для парсинга csv файла
'разделителем в файле должна быть запятая иначе не сработает
'файл должен быть вида ФИО,login,passwd

'On error Resume Next ' в случае каких либо ошибок "едем" дальше

Dim CSVInputFormat
Dim oLogQuery
Dim strQuery
Dim oRecordSet
Dim oRecord
Dim strClientIp
Dim gFileNAme 'имя файла с паролями
Dim PassWordServer 'пароль для доступа к серваку hMailServer
Dim GlobalDomain ' имя домена на сервере hMailServer
Dim DistributionListAdress 'Имя списка рассылки
Dim gVar 'хранит значения для того чтобы определить какое действие выбрать, добавить адресс или добавить в список
Dim MyFile
Set oLogQuery = CreateObject("MSUtil.LogQuery")

Set objShell = CreateObject("WScript.Shell")
Set objFSO   = CreateObject( "Scripting.FileSystemObject" )

Set MyFile = objFSO.CreateTextFile(objShell.CurrentDirectory & "\errfile_distrlist.log", True)

Set objArgs = WScript.Arguments

'проверка на количество параметров, если меньше 1-го завершаем работу
'WScript.Echo "Количество аргументов " & objArgs.Count

if objArgs.Count - 1 < 0 then
    WScript.echo "Использование: import.vbs: <Действие> <Имя файла> <пароль> <домен>"
    WScript.echo "Параметры:"
	WScript.echo "<AddAdr/AddToList> - добавить адресс / добавить адресс в УЖЕ СОЗДАННЫЙ список рассылки"
    WScript.echo "<Имя файла> -  текстовый файл csv, обязательно разделителем должена быть запятая, "
    WScript.echo "               и файл должен состоять из 3-х полей ФИО,логин,пароль иначе скрипт не сработает"
    WScript.echo "<пароль> -     доступа к серверу hmailserver"
    WScript.echo "<домен> -      имя домена на сервере hmailserver куда будут добавлены адреса"
	WScript.echo "<Distribution list Name> -      имя адреса списка в который будем добавлять перечень"
    WScript.Quit
else
'Если аргументов больше 1-го то присваиваем значение
    if ( isNull(objArgs(0)) ) OR ( isNull(objArgs(1)) ) OR ( isNull(objArgs(2)) ) then
    	WScript.Echo "Вы забыли указать один и 3-х параметров, работа программы завершена"
    	WScript.Quit
    end if
    gVar = LCase(objArgs(0))
	gFileNAme = objArgs(1)
	PassWordServer = objArgs(2)
	GlobalDomain = objArgs(3)
	'проверка на параметры, если добавляем в лист то счытываем значение
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

MyFile.WriteLine("Началось ....")
' Visit all records
DO WHILE NOT oRecordSet.atEnd

	' Get a record
	Set oRecord = oRecordSet.getRecord

	'получаем значение логина
	strClient = oRecord.getValue ( 3 )
	'получаем значение пароля
	strClient2 = oRecord.getValue ( 4 )

	' вызываем процедуру записи пользователя
	Select Case gVar
		Case "addadr"
			CreateLogin strClient, strClient2, GlobalDomain
		Case "addtolist"
			AddToList strClient, GlobalDomain, DistributionListAdress
		Case else
			WSCript.Echo "вообщем вы какая-то херня не так ввели, скорее всего не правльно написали первый операнд"
			WScript.Quit
	End Select
	'пишем в лог перехваченные сообщения об ошибках
'	MyFile.WriteLine(strClient & "@" & strClient2 & ",Error #" & CStr(Err.Number) & "," & Err.Description)
	' Advance LogRecordSet to next record
	oRecordSet.moveNext

LOOP
MyFile.WriteLine("Конец .... ")
' Close RecordSet
MyFile.Close
oRecordSet.close

' Процедура добавления,
'fLogin - логин почты
'пароль почты
'домен почты

Sub CreateLogin(ByVal fLogin, ByVal fPasswd, ByVal fDomain)
Dim obApp
Dim obAccount
Dim obDomain

Set obApp = CreateObject("hMailServer.Application")
Call obApp.Authenticate("Administrator", PassWordServer)
Set obDomain = obApp.Domains.ItemByName(fDomain)

'проверка на существующею запись в списке, если есть то не создаем
if NOT isNull(obDomain.Accounts.ItemByAddress(fLogin & "@" & fDomain)) then
	'WScript.Echo "Идентификатор записи " & obDomain.Accounts.ItemByAddress(fLogin & "@" & fDomain).ID
	MyFile.WriteLine("Адресс " & fLogin & "@" & fDomain & " уже имеется в списке")
	Exit Sub
end if
'WScript.Echo "Это я после ошибки зашел"
Set obAccount = obDomain.Accounts.Add
obAccount.Address = fLogin & "@" & fDomain
obAccount.Password = fPasswd
obAccount.Active = True
obAccount.MaxSize = 50 ' разрешаем 50 Мб в ящике
obAccount.Save
MyFile.WriteLine("Адресс " & fLogin & "@" & fDomain & " добавлен")
End Sub

'процедура добавления адресов в список рассылки
'fLogin - адресс почты
'fDomain - имя домена в котором есть список
'fDistributionListAdress - имя адреса рассылки

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
'проверка на существующею запись в списке, если есть то не создаем
for var = 0 to obAccount.Recipients.Count - 1
	if obAccount.Recipients.Item(var).RecipientAddress = fLogin & "@" & fDomain then
	    ' зафиксируем в файле
		MyFile.WriteLine("Адресс " & fLogin & "@" & fDomain & " уже имеется в списке")
		Exit Sub
	end if
Next

Set obList = obAccount.Recipients.Add

obList.RecipientAddress = fLogin & "@" & fDomain
obList.Save
' зафиксируем в файле
MyFile.WriteLine("Адресс " & fLogin & "@" & fDomain & " добавлен")
End Sub
