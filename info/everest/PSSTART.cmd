set path=%path%;D:\bin\sysint\Pstools

rem set ever=\\rif-adm\EVEREST$\everest.exe
set report=\\rif-adm\reports$\$HOSTNAME
rem psexec.exe -u rif\pavelik -p Ukjrfz819 @\\RIF-ADM\everest$\filess \\rif-adm\EVEREST$\everest.exe /R "%report%" /MHTML /HW /SILENT /SAFE

rem ------------------------------------------------------------------------------
rem BD
rem ------------------------------------------------------------------------------
rem psexec.exe -s \\200-SHERTSINGER \\rif-adm\EVEREST$\everest.exe /R "%report%" /DATABASE /HW /SILENT /SAFE
rem psexec.exe -u rif\sv -p Ukjrfz819 @\\RIF-ADM\everest$\filess \\rif-adm\EVEREST$\everest.exe /R "%report%" /MHTML /CUSTOM \\rif-adm\EVEREST$\profile.rpf /SILENT /SAFE
rem psexec.exe -u rif\sv -p Ukjrfz819 @\\RIF-ADM\everest$\filess \\rif-adm\EVEREST$\everest.exe /R "%report%" /DATABASE /CUSTOM \\rif-adm\EVEREST$\profile.rpf /SILENT /SAFE
psexec.exe -s -u rif\pavelik -p Ukjrfz819 \\157-pischugin \\rif-adm\EVEREST$\everest.exe /R "%report%" /MHTML /HW /SILENT /SAFE /SAFEST
rem http://homelesschild.ru/nod_upd/