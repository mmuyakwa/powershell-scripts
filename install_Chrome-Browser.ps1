# Source: https://medium.com/@uqualio/how-to-install-chrome-on-windows-with-powershell-290e7346271
# Install Chrome-Browser

###!!!!!!!!!!!!! Untested yet!!!!!!!!!!!

$Path = $env:TEMP; $Installer = "chrome_installer.exe"; 
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$Installer
