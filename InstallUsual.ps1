# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Set Chocolatey configs
choco feature enable -n=allowGlobalConfirmation

# Install Chrome-Browser
choco install googlechrome -y

# Install usual Apps.
choco install 7zip.install notepadplusplus.install vscode.install visualstudio-installer clamwin clamsentinel openvpn sysinternals windirstat microsoft-windows-terminal conemu lightshot.install mremoteng joplin ketarin windows10-media-creation-tool winscp.install sumatrapdf.install dopdf immunet securepointsslvpn git.install gitahead dependency-scanner -y

# Update all Chocolatey-Apps
choco upgrade all -y

