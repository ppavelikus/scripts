rem net share Reports$=D:\bin\Everest\Reports /GRANT:��,CHANGE
rem net share Everest$=D:\bin\Everest /GRANT:��,READ
cd %~dp0
net share log$="%~dp0soft\log" /GRANT:��,CHANGE /GRANT:pavelik,CHANGE /GRANT:Guest,CHANGE
net share soft$="%~dp0soft" /GRANT:��,READ /GRAN:Guest,READ
