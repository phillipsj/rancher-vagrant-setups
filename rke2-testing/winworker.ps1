Stop-Service docker
Set-MpPreference -DisableRealtimeMonitoring $true -DisableScriptScanning $true -DisableArchiveScanning $true -ExclusionPath c:\var\lib\rancher\rke2\bin,c:\usr\local\bin
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Write-Host "Downloading RKE2 installer for Windows..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/phillipsj/rke2/bugfix/windows-installer/install.ps1 -Outfile install.ps1

Write-Host "Creating RKE2 configuration..."
$token = Get-Content C:/sync/token
$server = Get-Content C:/sync/server

New-Item -Type Directory C:/etc/rancher/rke2 -Force
Set-Content -Path C:/etc/rancher/rke2/config.yaml -Value @"
server: https://$($server):9345
token: $($token)
kube-proxy-arg: "feature-gates=IPv6DualStack=false"
"@

Write-Host "Creating RKE2 environment variables..."
$env:PATH+=";C:\var\lib\rancher\rke2\bin;c:\usr\local\bin"
[Environment]::SetEnvironmentVariable("Path",
        [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\var\lib\rancher\rke2\bin;c:\usr\local\bin",
        [EnvironmentVariableTarget]::Machine)

Write-Host "Installing RKE2 as an agent..."
./install.ps1 -Channel testing

Write-Host "Starting RKE2 Windows Service..."
Push-Location c:\usr\local\bin
rke2.exe agent service --add
exit 0
