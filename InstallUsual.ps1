Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Set Chocolatey configs
choco feature enable -n=allowGlobalConfirmation

# Install Chrome-Browser
choco install googlechrome -y

# Install usual Apps.
choco install 7zip.install notepadplusplus.install vscode.install visualstudio-installer clamwin clamsentinel openvpn sysinternals microsoft-windows-terminal irfanview xnviewmp sql-server-management-studio windirstat conemu cmder mremoteng joplin ketarin windows10-media-creation-tool winscp.install sumatrapdf.install dopdf immunet securepointsslvpn git.install gitahead greenshot dependency-scanner dotnetfx vcredist140 -y

# Update all Chocolatey-Apps
choco upgrade all -y

