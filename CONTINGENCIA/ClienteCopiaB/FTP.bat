cd	%4
@echo off
echo open %3 %6>ftpcmd.dat
echo user %1>> ftpcmd.dat
echo %2>> ftpcmd.dat
echo lcd %4>> ftpcmd.dat
echo put %5.zip>> ftpcmd.dat
echo quit>> ftpcmd.dat
ftp -n -s:ftpcmd.dat
del ftpcmd.dat
