# Reg2CI https://reg2ps.azurewebsites.net/

#Windows Registry Editor Version 5.00

#[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability]
#"ShutdownReasonOn"=dword:00000000

#[HKEY_CURRENT_USER\Software\Microsoft\ServerManager]
#"DoNotOpenServerManagerAtLogon"=dword:00000001
#"CheckedUnattendLaunchSetting"=dword:00000000


if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\ServerManager") -ne $true) {  New-Item "HKCU:\Software\Microsoft\ServerManager" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability' -Name 'ShutdownReasonOn' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\ServerManager' -Name 'DoNotOpenServerManagerAtLogon' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\ServerManager' -Name 'CheckedUnattendLaunchSetting' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;

