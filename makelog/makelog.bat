@echo off

set BIN="C:\Program Files (x86)\Microsoft VS Code\Code.exe"
set FILE_DAILY=D:\shibata\note\current\%date:~0,4%%date:~5,2%%date:~8,2%.md
set FILE_NOTE=D:\shibata\note\note.md
set TEMPLATE=D:\shibata\src\script\logging\makelog\template.md

IF NOT EXIST %FILE_DAILY% (
	copy %TEMPLATE% %FILE_DAILY%
)

%BIN% %FILE_NOTE%
%BIN% %FILE_DAILY%
