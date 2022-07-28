set DIR_BACKUP=C:\\backupMSSQL_%date%
set NAME_PC=<Èìÿ ÏÊ>

md %DIR_BACKUP%

osql -S %NAME_PC% -E -Q "BACKUP DATABASE wind TO DISK = '%DIR_BACKUP%\wind.bak' with init"
osql -S %NAME_PC% -E -Q "BACKUP DATABASE master TO DISK = '%DIR_BACKUP%\master.bak' with init"
osql -S %NAME_PC% -E -Q "BACKUP DATABASE model TO DISK = '%DIR_BACKUP%\model.bak' with init"
osql -S %NAME_PC% -E -Q "BACKUP DATABASE msdb TO DISK = '%DIR_BACKUP%\msdb.bak' with init"