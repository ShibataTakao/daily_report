@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=D:\shibata\tmp\search.md
set SEARCH_DIR=D:\shibata\note\search
powershell .\SearchLog.ps1
for %%f in (2016 2015 2014) do (
    type %SEARCH_DIR%\%%f.md >> %FILE%
)
%BIN% %FILE%
