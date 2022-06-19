# $pw = (Get-Credential wejustneedthepassword).Password
$pw = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$pw

New-DbaLogin -SqlInstance . -Password $pw -Login WWI_ReadOnly
New-DbaLogin -SqlInstance . -Password $pw -Login WWI_ReadWrite
New-DbaLogin -SqlInstance . -Password $pw -Login WWI_Owner

# Create database users
New-DbaDbUser -SqlInstance . -Login WWI_ReadOnly -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance . -Login WWI_ReadWrite -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance . -Login WWI_Owner -Database WideWorldImporters -Confirm:$false

# Add database role members
Add-DbaDbRoleMember -SqlInstance . -Database WideWorldImporters -User WWI_Readonly -Role db_datareader -Confirm
Add-DbaDbRoleMember -SqlInstance . -Database WideWorldImporters -User WWI_ReadWrite -Role db_datawriter -Confirm
Add-DbaDbRoleMember -SqlInstance . -Database WideWorldImporters -User WWI_Owner -Role db_owner

# Create some SQL Server Agent jobs
$job = New-DbaAgentJob -SqlInstance . -Job 'dbatools lab job'  -Description 'Creating a test job for our lab' 
New-DbaAgentJobStep -SqlInstance . -Job $Job.Name  -StepName 'Step 1: Select statement' -Subsystem TransactSQL -Command 'Select 1'

Set-DbaSpConfigure -SqlInstance . -Name RemoteDacConnectionsEnabled -Value 1
Set-DbaSpConfigure -SqlInstance . -Name CostThresholdForParallelism -Value 10

# create a shared network
docker network create localnet

$cred = Get-Credential
# Connect to the local machine using the credential
Connect-DbaInstance -SqlInstance $Env:ComputerName -SqlCredential $cred

Get-DbaDatabase -SqlInstance . -ExcludeSystem | Select Name, Size, LastFullBackup

$query = "Select * from Databases"
Invoke-DbaQuery -SqlInstance . -Database tempdb -Query $query

Get-DbaRegServer | Invoke-DbaQuery -Query "SELECT @@VERSION"