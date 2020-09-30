# Source: https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server
# Update Docker on a Windows-Server

#### Update Docker on a Windows-Server
Get-Package -Name Docker -ProviderName DockerMsftProvider
Find-Package -Name Docker -ProviderName DockerMsftProvider
Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
Start-Service Docker
