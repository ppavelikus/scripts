rem
rem This file contains many commands for working with the kickidler agent
rem 
rem restart ngs
rem ..\psexec64.exe @computers_restart_ngs.lst -s -n 2 -c restart_ngs.cmd > psexec.log
rem repair TermService
rem ..\psexec64.exe @computers.lst -s -n 2 -c repair_service_termservice.cmd > psexec.log
rem Check TermService
rem ..\psexec64.exe @computers.lst -n 2 -c check_termservice.cmd > psexec.log
rem remove grabber
rem ..\psexec64.exe @computers_remove_ngs.lst -s -n 2 -c remove_grabber.cmd > psexec.log
rem Install grabber
..\psexec64.exe @computers_for_install_ngs.lst -s -n 2 -c remote_install_grabber.cmd > psexec.log