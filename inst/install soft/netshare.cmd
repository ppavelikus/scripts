rem net share Reports$=D:\bin\Everest\Reports /GRANT:Все,CHANGE
rem net share Everest$=D:\bin\Everest /GRANT:Все,READ
cd %~dp0
net share log$="%~dp0soft\log" /GRANT:Все,CHANGE /GRANT:pavelik,CHANGE /GRANT:Guest,CHANGE
net share soft$="%~dp0soft" /GRANT:Все,READ /GRAN:Guest,READ
