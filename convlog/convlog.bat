@echo off
set INFILE=D:\shibata\note\current\%date:~0,4%%date:~5,2%%date:~8,2%.md
powershell .\ConvertLog.ps1 -inFile %INFILE%
pause