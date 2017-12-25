# This Script creates my daily folder for starting new projects.
# Author: Michael Muyakwa, 2016-12-24
# License: MIT
#


#Variable sets the foldername for the YEAR
$Yfolder = "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))";
#Variable sets the foldername for the MONTH
$Mfolder = "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))";
#Variable sets the foldername for the Folder I want to create
$Resultfolder = "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))\$((Get-Date).ToString('yyyy-MM-dd'))";

# If Folder with YEAR does not exist, create it
if ( -Not (Test-Path $Yfolder) ) {
    New-Item -ItemType Directory -Path $Yfolder;
}

# If Folder with MOTH does not exist, create it
if ( -Not (Test-Path $Mfolder) ) {
    New-Item -ItemType Directory -Path $Mfolder;
}

# Has the full path (YEAR\MONTH) been created? If so, create the DAY-folder ("YYYY-MM-dd")
if (Test-Path $Mfolder) {
    # Checking if the foldername for the Folder I want to create already exists
    if ( -Not (Test-Path $Resultfolder) ) {
        # CD into the created path
        Set-Location -Path "C:\Users\mmuya\Documents\Workspace\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))";
        # Create the folder "YYYY-MM-dd"
        New-Item -ItemType Directory -Path ".\$((Get-Date).ToString('yyyy-MM-dd'))";
        # Open the Folder in Explorer
        $objShell = New-Object -ComObject "Shell.Application";
        $objShell.Explore($Resultfolder);
    } else {
        # The Folder apparently already exists. Opening the Folder in Explorer
        $objShell = New-Object -ComObject "Shell.Application";
        $objShell.Explore($Resultfolder);
    }
}
