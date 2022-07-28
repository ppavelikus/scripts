if EXIST \\RIF-SERV\LOG$\%COMPUTERNAME% (
EXIT
)
\\RIF-ADM\install\update\WindowsXP-KB957095-x86-RUS.exe /quiet /norestart  /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
\\RIF-ADM\install\update\WindowsXP-KB957097-x86-RUS.exe /quiet /norestart  /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
rem english
\\RIF-ADM\install\update\WindowsXP-KB957095-x86-ENU.exe /quiet /norestart /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
\\RIF-ADM\install\update\WindowsXP-KB957097-x86-ENU.exe /quiet /norestart /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
\\RIF-ADM\install\update\WindowsXP-KB958644-x86-ENU.exe /quiet /warnrestart:30 /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
rem end english
\\RIF-ADM\install\update\WindowsXP-KB958644-x86-RUS.exe /quiet /warnrestart:30 /log:\\RIF-SERV\LOG$\%COMPUTERNAME%
