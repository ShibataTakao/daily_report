@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\note\current\%date:~0,4%%date:~5,2%%date:~8,2%.md
powershell .\MakeLog.ps1
%BIN% %FILE%
