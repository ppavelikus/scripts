set bin=%programfiles%\Support Tools
cscript.exe "%bin%\search.vbs" "LDAP://ou=work,dc=rif,dc=local" /S:subtree /Q /C:ObjectCategory=group