On Error Resume Next
Set objArgs = WScript.Arguments
Set fso1 = WScript.CreateObject("Scripting.FileSystemObject")
'проверка на количество параметров, если меньше 3-х завершаем работу
'последний параметр, означает вложение, он не обязательный
if objArgs.Count - 1 < 2 then
    WScript.echo "введите параметры: message.vbs: <отправитель> <название темы> <текст сообщения>"
    WScript.QUIT
end if
'задаем переменную тема и текст сообщения
'от
from=objArgs(0)
'тема
tema=objArgs(1)
'текст сообщения
body=objArgs(2)
'вложение
att=objArgs(3)

Set objEmail = CreateObject("CDO.Message")
objEmail.From = from
objEmail.To = "admin@mail"
objEmail.Subject = tema
objEmail.Textbody = body
'если параметр имеет непустое значение то вставляем его в текст
'( att <> "" ) and
if fso1.FileExists(att) then
objEmail.AddAttachment(att)
end if

with objEmail.Configuration.Fields
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail"
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 ' используем basic authentication
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "username" 'имя пользователя
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "userpassword"  'пароль пользователя
end with
objEmail.Configuration.Fields.Update
objEmail.Send
