Install-Module -Name PSWindowsUpdate

Install-Module -Name PSWindowsUpdate –Force

Get-Package -Name PSWindowsUpdate

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose

Get-WUList


