rem dsget group "CN=otdel201,ou=work,dc=rif,dc=local" -members -s rif-serv
rem так можно просматреть членов группы 201-го отдела
rem dsquery group domainroot -name *200 | dsget group -members
rem так можно найти пользователя по его имени, точнее его координаты в AD
dsquery user domainroot -name sychev
rem этот запрос позволяет найти пользователя по его логину
dsquery user domainroot -upn s*
rem список компутеров из папки OU 200
rem dsquery computer ou=200,ou=ComputersGPO,dc=rif,dc=local -o rdn