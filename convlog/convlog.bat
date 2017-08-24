@echo off
set BIN="C:\Program Files (x86)\Microsoft VS Code\Code.exe"
set INFILE=D:\shibata\note\current\%date:~0,4%%date:~5,2%%date:~8,2%.md
set OUTFILE=D:\shibata\tmp\“ú•ñ.md
powershell .\ConvertLog.ps1 -inFile %INFILE% -outFile %OUTFILE%
start %BIN% %OUTFILE%
