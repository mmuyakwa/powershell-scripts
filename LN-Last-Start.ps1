<#
.SYNOPSIS
This script searches for a specific string ("Service Starting!") in Lasernet log files and displays the last lines that contain the search string.

.DESCRIPTION
The script reads all the Lasernet log files in the specified folder and searches for a given search string ("Service Starting!"). It then displays the last lines that contain the search string for each log file.

.PARAMETER LogFileFolder
The folder path where the Lasernet log files are located.

.PARAMETER SearchString
The string to search for in the log files.

.EXAMPLE
.\LN-Last-Start.ps1 -LogFileFolder "C:\Lasernet\Log" -SearchString "Service Starting!"

This example searches for the string "Service Starting!" in the Lasernet log files located in the "C:\Lasernet\Log" folder.

#>

$LogFileFolder = "C:\Lasernet\Log"
$SearchString = "Service Starting!"

# Finde alle *.lnlog Dateien im Ordner $LogFileFolder
$LogFiles = Get-ChildItem -Path $LogFileFolder -Filter *.lnlog

#Stelle sicher das die Ausgabe der Log-Dateien in dieser Reihenfolge erfolgt:
#Lasernet.lnlog
#Lasernet.1.lnlog
#Lasernet.2.lnlog

# Sortiere die Log-Dateien nach Name
$LogFiles = $LogFiles | Sort-Object -Property @{Expression = {if ($_.Name -match '\d+') {[int]$matches[0]} else {0}}; Ascending = $true}, @{Expression = {if ($_.Name -match '\d+') {$null} else {$_.Name}}; Ascending = $true}
#write-host "LogFiles: $LogFiles"

# Gehe durch jede Log-Datei und suche nach dem Suchstring von unten nach oben in der Datei
# Gebe die letzten $AnzahlStartsZeigen Zeilen der Log-Datei aus, die den Suchstring enthalten
# Gebe den Dateinamen und den Inhalt der Zeile aus
foreach ($LogFile in $LogFiles) {
    # Lese den Inhalt der Log-Datei
    $LogContent = Get-Content -Path $LogFile.FullName
    # Suche nach dem Suchstring
    $LogContent = $LogContent | Where-Object {$_ -match $SearchString}
    # Kehre die Reihenfolge der Zeilen um. Neuste gefundene Einträge zuerst
    $LogContent = $LogContent[$LogContent.Length..0]
    # Gebe den Dateinamen und den zutreffenden Inhalt aus
    if ($LogContent) {
        write-host "LogFile: $($LogFile.Name)"
        $LogContent
    }
}
