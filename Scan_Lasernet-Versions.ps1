############
<#
.SYNOPSIS
This script checks the version of the "Lasernet-Service" and "Lasernet-Client" executables in the "c:\Program Files\Formpipe Software\Lasernet 10\" directory.

.DESCRIPTION
The script retrieves the path of the "c:\Program Files\" directory and then searches for all Lasernet folders within the "Formpipe Software" subdirectory. It iterates through each Lasernet folder and retrieves the version information of the specified executables: "LnService.exe" and "LnClient.exe". The script displays the version information for each executable.

.PARAMETER None
This script does not accept any parameters.

.EXAMPLE
.\Scan_Lasernet-Versions.ps1
Runs the script and displays the version information of the Lasernet executables.

.NOTES
- This script requires administrative privileges to access the "c:\Program Files\" directory.
- Uncomment the "Set-ExecutionPolicy" line if the script fails due to execution policy restrictions.
- The script assumes that the Lasernet executables are located in the "c:\Program Files\Formpipe Software\Lasernet 10\" directory.
#>

############
# 2024-03-01 MM - "secion GmbH"
# Check the "Lasernet-Service"- and "Lasernet-Client"- Version in "c:\Program Files\Formpipe Software\Lasernet 10\"

# Sets Execution Policy for Script to run. Uncomment only if everything else fails.
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

# Er mittle den Pfad des "c:\Program Files\"-Ordners
$ProgramFilesPath = [System.Environment]::GetFolderPath("ProgramFiles")

# Findet alle Lasernet-Ordner im ProgramFilesPath (ungeachtet welche Lasernet Version)
$Paths = Get-ChildItem -Path "$ProgramFilesPath\Formpipe Software" -Directory -Depth 1 | Where-Object { $_.Name -match "Lasernet \d+" }

foreach ($path in $Paths) # Loop through folders
{
    $Executeables = @(
        "LnService.exe",
        "LnClient.exe"#,
        "LnConfig.exe",
        "LnPrintService.exe"
    )
    foreach ($executeable in $Executeables) # Loop through folders
    {
        $LNVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$path\$executeable").FileVersion
        Write-Host "$executeable version:`t$LNVersion"
        #$LNVersion
    }
}
