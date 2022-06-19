$config = Import-PowerShellDataFile -Path .\Config\Config.psd1
Write-Host $config.InstallMediaPath


if(!(Test-Path $config.BackupPath)) {
    New-Item -Path $config.BackupPath -Type Directory
}
$wrSplat = @{
    uri     = 'https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak'
    OutFile = (Join-Path $config.BackupPath 'WideWorldImporters-Full.bak')
}
Invoke-WebRequest @wrSplat

if(!(Test-Path $config.BackupPath)) {
    New-Item -Path $config.BackupPath -Type Directory
}
$wrSplat = @{
    uri     = 'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak'
    OutFile = (Join-Path $config.BackupPath 'AdventureWorks2017-Full.bak')
}
Invoke-WebRequest @wrSplat

# Add permissions for service accounts to backup folder
    # Both SQL Server Engine service accounts need to have access to the backup folder
    # You can find the service account names with the following once you've installed the instances:
Get-DbaService -ComputerName DESKTOP-U5M4LHA -Type Engine