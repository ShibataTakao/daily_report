@echo off
set YYYYMM=%date:~0,4%%date:~5,2%
powershell .\GatherLog.ps1 %YYYYMM%
echo �Αӂ̍쐬���������܂���
pause