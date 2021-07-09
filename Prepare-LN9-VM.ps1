# Firstrun with LN-Prepare - 2021-07-09
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

# Set Variables

﻿[Cmdletbinding]
Param(
    [string]$Computername = "localhost"
)
cls
$PysicalMemory = Get-WmiObject -class "win32_physicalmemory" -namespace "root\CIMV2" -ComputerName $Computername

$install = $true
$admin = $false
$netframework = "4.8"

# Verify that user running script is an administrator

$IsAdmin=[Security.Principal.WindowsIdentity]::GetCurrent()

If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE)
{
    Write-Host "`nERROR: You are NOT a local administrator.  Run this script after logging on with a local administrator account." -ForegroundColor White -BackgroundColor Red
} else {
    $admin = $true
}

# FUNCTION #### START ####

function GetAndInstallPackage($packageId, $netver)
{
  $nver=$netver.replace(".","")
  $InstallerPath="$Env:TEMP\ndp$nver-devpack-enu.exe"  
  
  Write-Host "Downloading installer to '$InstallerPath' ..."

  $progressPreference = 'silentlyContinue'
  Invoke-WebRequest -Uri "http://go.microsoft.com/fwlink/?linkid=$packageId" -OutFile "$InstallerPath"
  $progressPreference = 'Continue'

  if ([System.IO.File]::Exists($InstallerPath))
  {
    Write-Host "Installer downloaded"
    Write-Host "Launching installer, it might take some time, please wait..."
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    & "$InstallerPath" /q /norestart | Out-null
    $elapsed = $stopwatch.Elapsed.TotalSeconds
    Write-Host "Installer ran for $elapsed seconds."
    $stopwatch.Stop()
    $_ok=$true
    switch ($lastexitcode)
    {
        0       { Write-Host "Installation completed successfully."; break; }
        1602    { Write-Host "The user canceled installation." -ForegroundColor red; $_ok=$false; break; }
        1603    { Write-Host "A fatal error occurred during installation." -ForegroundColor red;  $_ok=$false; break; }
        1641    { Write-Host "A restart is required to complete the installation.";
                  Write-Host "This message indicates success.";     break; }
        3010    { Write-Host "A restart is required to complete the installation.";
                  Write-Host "This message indicates success.";     break; }
        5100    { Write-Hosts "The user's computer does not meet system requirements." -ForegroundColor red;$_ok=$false; break; }
        default {Write-Host "Error! Unknown error ($lastexitcode)" -ForegroundColor red; $_ok=$false; break; }
    }
    Remove-Item $InstallerPath
    return $_ok
  }
  else
  {
    Write-Host "Error! Cannot download .NET Framework installer" -ForegroundColor red
    return 1
  }
}

# Check if .Net 3.5 is installed.
function Net35Installed {
    if (( (Get-ItemProperty "HKLM:SOFTWARE\WOW6432Node\Microsoft\NET Framework Setup\NDP\v3.5" -EA SilentlyContinue).Install -eq 1)) {
        return $true
    } else {
        return $false
    }
}

# Check if .Net 4.8 is installed.
function Net48Installed {
    if (( (Get-ItemProperty "HKLM:SOFTWARE\WOW6432Node\Microsoft\NET Framework Setup\NDP\v4\Full" -EA SilentlyContinue).Release -ge 528040 )) {
        return $true
    } else {
        return $false
    }
}

# FUNCTION #### STOP ####


# MAIN!

# "Check available CPU-Cores"
Write-Host "This System has $((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) CPU-Core(s)."
if ((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors -ge 2) {
    Write-Host "You have enough CPU-Cores to run a Lasernet-Server." -ForegroundColor Blue -BackgroundColor Green
} else {
    Write-Host "Insufficient number of CPU-Cores. You need at least 2 CPU-Cores." -ForegroundColor White -BackgroundColor Red
}

# "Check available RAM"
Write-Host "This System has $((($PysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB)GB of RAM."
if (((($PysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB) -ge 8) {
    Write-Host "You have enough RAM to run a Lasernet-Server." -ForegroundColor Blue -BackgroundColor Green
} else {
    Write-Host "Insufficient amount of RAM. You need at least 8GB of RAM." -ForegroundColor White -BackgroundColor Red
}

# Check if .Net 3.5 is installed.
if (Net35Installed) {
    Write-Host ".Net 3.5 is installed." -ForegroundColor Blue -BackgroundColor Green
} else {
    $install = $false
    Write-Host ".NET 3.5 installation required" -ForegroundColor White -BackgroundColor Red
    if ($admin) { # Try to install .Net 3.5 with via DISM
        Write-Host "`Installing .NET Framework v3.5 ..." -ForegroundColor Red -BackgroundColor Yellow
        Dism /online /enable-feature /featurename:NetFX3 /All
        # Check AGAIN if .Net 3.5 is installed.
        if (Net35Installed) {
            $install = $true
            Write-Host ".Net 3.5 is installed." -ForegroundColor Blue -BackgroundColor Green
        } else {
            $install = $false
            Write-Host "Dependencies .Net 3.5 is missing!!" -ForegroundColor White -BackgroundColor Red
        }
    }
}

# Check if .Net 4.8 is installed.
if (Net48Installed) {
    Write-Host ".Net 4.8 ist installiert." -ForegroundColor Blue -BackgroundColor Green
} else {
    $install = $false
    Write-Host ".NET 4.8 installation required" -ForegroundColor White -BackgroundColor Red
    if ($admin) { # Try to install .Net 4.8 via Function "GetAndInstallPackage"
        $Package=2088517
        Write-Host "Installing .NET Framework v$netframework ..." -ForegroundColor Red -BackgroundColor Yellow
        $_res=(GetAndInstallPackage -packageId $Package -netver $netframework)
        if ($_res)
        {
            Write-Host "Done." -ForegroundColor Blue -BackgroundColor Green
            Write-Host "Reeboot needed!" -ForegroundColor Red -BackgroundColor Yellow
        } else {
            Write-Host "Error." -ForegroundColor White -BackgroundColor Red
        }
    }
}

# Check AGAIN if .Net 4.8 ist installed.
#if (Net48Installed) {
#    $install = $true
#    Write-Host ".Net 4.8 is installed." -ForegroundColor Blue -BackgroundColor Green
#} else {
#    $install = $false
#    Write-Host "Dependencies .Net 4.8 is missing!!" -ForegroundColor White -BackgroundColor Red
#}

if ($install) {
    Write-Host "All dependencies for Lasernet 9 are set. Lasernet 9 can now be installed." -ForegroundColor Blue -BackgroundColor Green
} else {
    Write-Host "Dependencies for Lasernet 9 are missing!! Lasernet 9 can NOT be installed!!" -ForegroundColor White -BackgroundColor Red
    # Check AGAIN if .Net 4.8 ist installed.
    if (!(Net48Installed)) {
        Write-Host "If .Net 4.8 was just installed, you need to REBOOT first!!" -ForegroundColor White -BackgroundColor Red
    }
}

# Generate Lasernet-Folders
md C:\Lasernet\Archive
md C:\Lasernet\File_Out
md C:\Lasernet\Grab
md C:\Lasernet\Log
md C:\Lasernet\Preview
md C:\Lasernet\RunTimeData
md C:\Lasernet\XML_Archive
md C:\Lasernet\XML_IN


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