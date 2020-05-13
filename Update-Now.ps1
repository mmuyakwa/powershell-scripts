Invoke-WUJob -Script {ipmo PSWindowsUpdate; Get-WindowsUpdate -Install -AcceptAll -AutoReboot| Out-File C:\Windows\PSWindowsUpdate.log } -Confirm:$false -Verbose –RunNow
