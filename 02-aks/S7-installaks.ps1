# Install
$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $ClusterName).Name
$password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("CORP\LabAdmin", $password)

# Enable CredSSP
# Temporarily enable CredSSP delegation to avoid double-hop issue
foreach ($Server in $Servers){
    Enable-WSManCredSSP -Role "Client" -DelegateComputer $Server -Force
}
Invoke-Command -ComputerName $Servers -ScriptBlock { Enable-WSManCredSSP Server -Force }

#***************
# WARNING: Unable to acquire token for tenant 'ad4b6bf6-6f42-418f-af5b-6a4dd200af6e' with error 'The access token expiry UTC time '8/10/2021 5:06:43 AM' is earlier than current UTC time '8/10/2021 5:13:31 AM'.'
# if upper issue, close powershell, reopen a new powershell session, and uninstall-akshci then rerun S7

Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Install-AksHci
    # if failed run next command and then rerun top command
    # Uninstall-AksHci
}
