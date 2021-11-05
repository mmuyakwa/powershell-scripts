# Run as Admin
cls
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Get path of this script
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Host $scriptPath

# Get Exe-File for Lasernet.
$Lasernet_EXE = Get-ChildItem $scriptPath -recurse | where {$_.extension -eq ".exe"}

# Start installation of Lasernet.
Write-Host Running Lasernet-Setup
start "$Lasernet_EXE"

# Fetch all MSI-Files
$Lasernet_MSIs = Get-ChildItem $scriptPath -recurse | where {$_.extension -eq ".msi"}

foreach ($Lasernet_MSI in $Lasernet_MSIs)
{
    #Install Client/WebClient/PrinterService
    if (($Lasernet_MSI -notlike "*OCR*") -and ($Lasernet_MSI -notlike "*Meta*")) {
        Write-Host "Installing: $Lasernet_MSI"
        msiexec.exe /i "$scriptPath\$Lasernet_MSI" /QN /L*V "$scriptPath\$Lasernet_MSI.log"
    }

    # Uninstall OCR and Meta
    #if (($Lasernet_MSI -like "*OCR*") -or ($Lasernet_MSI -like "*Meta*")) {
    #    Write-Host "UnInstalling: $Lasernet_MSI"
    #    msiexec.exe /x "$scriptPath\$Lasernet_MSI" /QN /L*V "$scriptPath\$Lasernet_MSI.log"
    #}
}


#msiexec.exe /x {09502EB8-F697-4A87-8F99-1CACD7E59CD9}
#msiexec.exe /x "c:\filename.msi"