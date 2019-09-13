@echo off

set BIN="code"
set FILE_DAILY=D:\shibata\dailyreport\%date:~0,4%%date:~5,2%%date:~8,2%.md
set TEMPLATE=D:\shibata\src\daily_report\makelog\template.md

IF NOT EXIST %FILE_DAILY% (
	copy %TEMPLATE% %FILE_DAILY%
)

start %BIN% %FILE_DAILY%
