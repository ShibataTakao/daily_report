@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=D:\shibata\tmp\����.md
powershell .\ConvertLog.ps1
%BIN% %FILE%
