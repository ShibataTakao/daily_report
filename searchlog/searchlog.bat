@echo off
set BIN="C:\Program Files\Sublime Text 3\subl.exe"
set FILE=C:\shibata\tmp\search.md
echo 結合開始
powershell .\SearchLog.ps1
echo 結合終了
%BIN% %FILE%
