rem dsget group "CN=otdel201,ou=work,dc=rif,dc=local" -members -s rif-serv
rem ⠪ ����� ��ᬠ���� 童��� ��㯯� 201-�� �⤥��
rem dsquery group domainroot -name *200 | dsget group -members
rem ⠪ ����� ���� ���짮��⥫� �� ��� �����, �筥� ��� ���न���� � AD
dsquery user domainroot -name sychev
rem ��� ����� �������� ���� ���짮��⥫� �� ��� ������
dsquery user domainroot -upn s*
rem ᯨ᮪ ������஢ �� ����� OU 200
rem dsquery computer ou=200,ou=ComputersGPO,dc=rif,dc=local -o rdn