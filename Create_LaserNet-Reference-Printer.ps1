## MM - Secion
## 2021-11-30
## If the "LaserNet Reference Printer" does not exist under LN10, this script will generate it.
## Needed especially when working with "input-printers"-modules.

cls
$PrinterName = "LaserNet Reference Printer"

# Check if printer exists
if (Get-Printer -Name $PrinterName) 
{
    Write-Host "$PrinterName - already exists:"  -ForegroundColor Blue -BackgroundColor Green
    Get-Printer -Name $PrinterName | Format-List
    #$Port = Get-Printer -Name $PrinterName | Select-Object -Property PortName
    #Get-PrinterPort -Name $Port.PortName | Format-List
}
else 
{
    Write-Host "!Creating! $PrinterName" -ForegroundColor White -BackgroundColor Red
    Add-Printer -Name $PrinterName -DriverName "Lasernet EMF" -PortName "LPT1:"
}
