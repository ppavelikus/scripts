On Error Resume Next
Set objArgs = WScript.Arguments
Set fso1 = WScript.CreateObject("Scripting.FileSystemObject")
'�������� �� ���������� ����������, ���� ������ 3-� ��������� ������
'��������� ��������, �������� ��������, �� �� ������������
if objArgs.Count - 1 < 2 then
    WScript.echo "������� ���������: message.vbs: <�����������> <�������� ����> <����� ���������>"
    WScript.QUIT
end if
'������ ���������� ���� � ����� ���������
'��
from=objArgs(0)
'����
tema=objArgs(1)
'����� ���������
body=objArgs(2)
'��������
att=objArgs(3)

Set objEmail = CreateObject("CDO.Message")
objEmail.From = from
objEmail.To = "admin@mail"
objEmail.Subject = tema
objEmail.Textbody = body
'���� �������� ����� �������� �������� �� ��������� ��� � �����
'( att <> "" ) and
if fso1.FileExists(att) then
objEmail.AddAttachment(att)
end if

with objEmail.Configuration.Fields
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail"
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    .Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 ' ���������� basic authentication
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "username" '��� ������������
    .Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "userpassword"  '������ ������������
end with
objEmail.Configuration.Fields.Update
objEmail.Send
