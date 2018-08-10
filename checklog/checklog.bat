@echo off
set INFILE=D:\shibata\note\%date:~0,4%%date:~5,2%%date:~8,2%.md
powershell .\CheckLog.ps1 -inFile %INFILE%
pause
