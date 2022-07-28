Dim oShell
Dim oShortCut

set oShell = WScript.CreateObject ("WScript.Shell")
Set WshSysEnv = oShell.Environment("PROCESS")
'WScript.Echo WshSysEnv("SYSTEMDRIVE")

StartupPath = oShell.SpecialFolders("AllUsersStartup")

ProgramsPath  = WshSysEnv("SYSTEMDRIVE") & "\program files"


Set oShortCut = oShell.CreateShortcut(StartupPath & "\Miranda.lnk")

oShortCut.TargetPath = ProgramsPath & "\miranda\miranda32.exe"
oShortCut.Save()

oShortCut1.TargetPath = ProgramsPath & "\miranda\miranda32.exe"
oShortCut1.Save()

oShell.Run "miranda32.exe"
