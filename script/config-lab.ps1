$config = Import-PowerShellDataFile -Path .\Config\Config.psd1
Write-Host Convert-Path (Join-Path $config.BackupPath 'WideWorldImporters-Full.bak')
# Restore WideWorldImporters & AdventureWorks2017 to 2019 instance
Restore-DbaDatabase -SqlInstance localhost  -Path (Join-Path $config.BackupPath 'WideWorldImporters-Full.bak') 
Restore-DbaDatabase -SqlInstance . -Path (Join-Path $config.BackupPath 'AdventureWorks2019.bak')