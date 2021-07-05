# Firstrun - 2021-05-11
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force


# Install Chrome-Browser
$Path = $env:TEMP; $Installer = "chrome_installer.exe"; 
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; 
Remove-Item $Path\$Installer

# Disable EventTracker
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\ServerManager") -ne $true) {  New-Item "HKCU:\Software\Microsoft\ServerManager" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability' -Name 'ShutdownReasonOn' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\ServerManager' -Name 'DoNotOpenServerManagerAtLogon' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\ServerManager' -Name 'CheckedUnattendLaunchSetting' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;

# Disable IE Enhanced Security
function Disable-ieESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
Disable-ieESC

# Set TimeZone to Berlin
Set-TimeZone -Id 'W. Europe Standard Time'

# Show FileExtensions
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;

# Install needed Apps
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation
choco install 7zip.install notepadplusplus.install vscode.install clamwin clamsentinel sysinternals microsoft-windows-terminal windirstat winscp.install git.install greenshot dependency-scanner dotnetfx vcredist140 -y
choco upgrade all -y

# Windows-Updates
Install-Module -Name PSWindowsUpdate -Force
Get-Package -Name PSWindowsUpdate
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force
Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose
Get-WUList
Get-WUlist -MicrosoftUpdate
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false
#Get-WindowsUpdate -AcceptAll -Download -Install -Confirm:$false
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -Install -Confirm:$false  | Out-File "C:\Windows\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -force
# Generate Scheduled-Task for Updates (No AutoReboot!)
Invoke-WUJob -Script {ipmo PSWindowsUpdate; Get-WindowsUpdate -Install -AcceptAll -AutoReboot:$false -Confirm:$false | Out-File C:\Windows\PSWindowsUpdate.log } -Confirm:$false -Verbose -RunNow:$false
