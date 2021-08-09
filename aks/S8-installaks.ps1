# Install
$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $ClusterName).Name
$password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("CORP\LabAdmin", $password)

Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Install-AksHci
}

# if failed run next command and then rerun top command
# Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
#     Uninstall-AksHci
# }
