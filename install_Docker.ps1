# Source: https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server
# Install Docker on a Windows-Server


# Install Dcker on a Windows-Server
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-Package -Name docker -ProviderName DockerMsftProvider

Restart-Computer -Force

#### Update Docker on a Windows-Server
# Get-Package -Name Docker -ProviderName DockerMsftProvider
# Find-Package -Name Docker -ProviderName DockerMsftProvider
# Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
# Start-Service Docker
