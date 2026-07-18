@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0orca.ps1" %*
exit /b %ERRORLEVEL%
