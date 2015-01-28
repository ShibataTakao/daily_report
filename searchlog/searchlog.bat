@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\tmp\search.md
powershell .\SearchLog.ps1
%BIN% %FILE%
