@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\tmp\日報.txt
powershell .\ConvertLog.ps1
rem echo 日報の変換が完了しました
rem pause
%BIN% %FILE%