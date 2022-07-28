for /F %%i in (\\rif-serv\LOG$\tmp\comps.txt) do (
if %computername%==%%i EXIT
)
ipconfig /all >> \\RIF-SERV\LOG$\tmp\%COMPUTERNAME%