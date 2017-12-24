
#Variable des Jahres-Ordner
$Yfolder = "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))";
#Variable des Monats-Ordner
$Mfolder = "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))";

#Generiere Jahres-Ordner
if ( -Not (Test-Path $Yfolder) )
{
    New-Item -ItemType Directory -Path $Yfolder;
}

#Generiere Monats-Ordner
if ( -Not (Test-Path $Mfolder) )
{
    New-Item -ItemType Directory -Path $Mfolder;
}

if (Test-Path $Mfolder) 
{
    Set-Location -Path "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))";
    New-Item -ItemType Directory -Path ".\$((Get-Date).ToString('yyyy-MM-dd'))";
}
