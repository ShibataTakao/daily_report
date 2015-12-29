@echo off
set YYYYMM=%date:~0,4%%date:~5,2%
powershell .\GatherLog.ps1 %YYYYMM%
echo ‹Î‘Ó‚Ìì¬‚ªŠ®—¹‚µ‚Ü‚µ‚½
pause