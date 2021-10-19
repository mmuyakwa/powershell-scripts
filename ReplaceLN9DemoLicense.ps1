# Secion - MM 2021-10-15
# Ablaufdatum der Lasernet 9 Demo-Lizenz auslesen und austauschen, wenn diese in 6 Tagen abläuft.
cls # Clean Screen

# LN9 Variablen - Hier den Pfad zur neuen Lizenz hinterlegen.
$NewLN9License = "C:\Users\Administrator\Downloads\Lasernet9.license"

### !!!Ab hier nicht editieren!!! ###

# Standard-Pfade zum Developer die dynamisch gesetzt werden.
$ProgData_Dev_LN9 = "$($env:ProgramData)\Formpipe Software\Lasernet 9\Developer"
$ProgData_Dev_LN9_license = "$ProgData_Dev_LN9\Lasernet.license"

# Developer-Lizenz tauschen.
CheckLicense -LicenseFile $ProgData_Dev_LN9_license # Rufe Funktion auf

# Lasernet-Instanzen Lizenzen austauschen. (Funktioniert auch wenn mehrere Instanzen installiert sind.)
$ProgData_SRV_LN9 = "$($env:ProgramData)\Formpipe Software\Lasernet 9\Service\"
$ProgData_SRV_LN9_Instances = get-childitem "$($env:ProgramData)\Formpipe Software\Lasernet 9\Service\"

# Schleife die jede Instanz durchlooped.
foreach ($LN_Instance in $ProgData_SRV_LN9_Instances){
    Write-Host "Instanz: $LN_Instance"
    $InstanceLicenseFile = "$ProgData_SRV_LN9\$LN_Instance\Lasernet.license"
    if (Test-Path "$InstanceLicenseFile" -PathType Leaf)
    {
        Write-Host $InstanceLicenseFile
        CheckLicense -LicenseFile $InstanceLicenseFile # Rufe Funktion auf
    }
}

# Funktion übernimmt den Pfad zur Lizenzdatei und tausch die aus, wenn die in 7 Tagen abläuft.
# z.B.: "CheckLicense -LicenseFile $InstanceLicenseFile"
function CheckLicense {
    param (
        $LicenseFile
    )

    if (Test-Path "$LicenseFile" -PathType Leaf)
    {
        Write-Host "Demo-Lizenz ist vorhanden."
        Write-Host "$LicenseFile"

        # Lese Ablaufdatum der Demo-Lizenz aus der XML aus.
        [xml]$ovf = Get-Content -Path "$LicenseFile"

        $LicenseExpirationDate_XML = $ovf.LaserNetLicense.Licenses.License.ExpiresOn[0]
        $LicenseExpirationDate = [datetime]::ParseExact($LicenseExpirationDate_XML,'yyyyMMdd',$null)
        Write-Host $LicenseExpirationDate_XML

        $today = (get-date).AddDays(+7) # 7 Tage. Tauscht die Demo-Lizenz vorsorglich aus, wenn die Lizenz in 7 Tagen ablaufen wird.

        if($today -ge $LicenseExpirationDate){
            Write-Output "Demo-Lizenz wird ausgetauscht."
            if (Test-Path "$NewLN9License" -PathType Leaf) {
                # Setze die Berechtigung, damit die Datei editiert werden kann.
                $acl = Get-Acl "$LicenseFile"
                $rules = $acl.Access | where IsInherited -eq $false
                $targetrule = $rules | where IdentityReference -eq "BUILTIN\Administrators"
                $acl.RemoveAccessRule($targetrule)
                $targetrule = $rules | where IdentityReference -eq "BUILTIN\Users"
                $acl.RemoveAccessRule($targetrule)
                $acl | Set-Acl -Path "$LicenseFile"
                # Lizenz wird ausgetauscht.
                Copy-Item "$NewLN9License" "$LicenseFile" -Force
            }
        }else{
            Write-Output "Die Demo-Lizenz ist mindestens noch 7 Tage gültig."
        }
    }
}