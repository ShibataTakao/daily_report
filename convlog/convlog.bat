@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\tmp\“ú•ñ.txt
powershell .\ConvertLog.ps1
rem echo “ú•ñ‚Ì•ÏŠ·‚ªŠ®—¹‚µ‚Ü‚µ‚½
rem pause
%BIN% %FILE%