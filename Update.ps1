#Install-Module -Name PSWindowsUpdate –Force

#Get-Package -Name PSWindowsUpdate

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

Set-WUSettings -AcceptTrustedPublisherCerts -AutoInstallMinorUpdates -DetectionFrequencyEnabled -IncludeRecommendedUpdates -NoAutoRebootWithLoggedOnUsers -ScheduledInstallDay "Every Day"

Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose

Get-WUList

Get-WindowsUpdate -AcceptAll -Download -Install

