xcopy /Y /I \\rif-adm\soft$\rserv34ru.msi %systemroot%\temp\
xcopy /Y /I \\rif-adm\soft$\Parameters.reg %systemroot%\temp\
cd %systemroot%\temp\
rserv34ru.msi /qn /norestart /log \\rif-adm\log$\%COMPUTERNAME%
regedit /s Parameters.reg
rem shutdown -r -t 10