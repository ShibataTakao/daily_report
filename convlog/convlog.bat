@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\tmp\����.txt
powershell .\ConvertLog.ps1
rem echo ����̕ϊ����������܂���
rem pause
%BIN% %FILE%