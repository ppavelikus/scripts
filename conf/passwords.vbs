Option Explicit
Dim objComputer ' Ёкземпл€р объекта Computer
Dim objUser ' Ёкземпл€р объекта User
Dim strComputer ' »м€ компьютера
Dim strUser ' »м€ создаваемого пользовател€
Dim strpass ' пароль пользовател€
Dim objSysInfo 'массив дл€ хранени€ свойств компьютера, считанных из AD
Dim arrFULLNAME 'служебный массив
Dim arrCN 'служебный массив

Set objSysInfo = CreateObject("ADSystemInfo")
strComputer = objSysInfo.ComputerName
arrFULLNAME = Split(strComputer, ",")
arrCN = Split(arrFULLNAME(0), "=")

strComputer=arrCN(1)

strUser = "admin"
strpass = "adminKjrfk"

Set objUser = GetObject("WinNT://" & strComputer & "/" & strUser)
objUser.Description = "ѕароль изменен при помощи скрипта"
objUser.SetPassword strpass
objUser.SetInfo