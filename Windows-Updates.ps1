Install-Module -Name PSWindowsUpdate -Force

Get-Package -Name PSWindowsUpdate

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose

Get-WUList

Get-WindowsUpdate -AcceptAll -Download -Install

Install-WindowsUpdate -AcceptAll -Install -Force

Invoke-WUJob -Script {ipmo PSWindowsUpdate; Get-WindowsUpdate -Install -AcceptAll -AutoReboot| Out-File C:\Windows\PSWindowsUpdate.log } -Confirm:$false -Verbose -RunNow

