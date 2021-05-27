@echo off

md "C:\image"
Powershell.exe -Command "Invoke-WebRequest 'https://github.com/mmuyakwa/powershell-scripts/raw/master/FirstRun.ps1' -OutFile 'C:\image\FirstRun.ps1';"
PowerShell.exe -ExecutionPolicy Unrestricted -Command "C:\image\FirstRun.ps1"
