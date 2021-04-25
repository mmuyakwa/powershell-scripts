# Reg2CI https://reg2ps.azurewebsites.net/

#Windows Registry Editor Version 5.00
#[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
#"HideFileExt"=dword:00000000
#"Hidden"=dword:00000001
#"ShowSuperHidden"=dword:00000001


if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;

