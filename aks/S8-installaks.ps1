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

Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Install-AksHci
}

# if failed run next command and then rerun top command
#Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
#     Uninstall-AksHci
# }
