@echo off

set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE_DAILY=D:\shibata\note\current\%date:~0,4%%date:~5,2%%date:~8,2%.md
set FILE_TASKS=D:\shibata\note\tasks.md
set TEMPLATE=D:\shibata\src\script\logging\makelog\template.md

IF NOT EXIST %FILE_DAILY% (
	copy %TEMPLATE% %FILE_DAILY%
)

%BIN% %FILE_TASKS%
%BIN% %FILE_DAILY%
