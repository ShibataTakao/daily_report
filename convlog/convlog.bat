@echo off
set BIN="C:\Program Files (x86)\Microsoft VS Code\Code.exe"
set FILE=D:\shibata\tmp\“ú•ñ.md
powershell .\ConvertLog.ps1
start %BIN% %FILE%
