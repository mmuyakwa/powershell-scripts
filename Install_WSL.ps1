# Install WSL (Windows-Subsystems for Linux)

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Links with Linux-Versions: 
# https://docs.microsoft.com/de-de/windows/wsl/install-manual#downloading-distributions
Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile Debian.appx -UseBasicParsing

Add-AppxPackage .\Debian.appx

## Deinstall with:
# lxrun /uninstall /full
