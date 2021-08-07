# DC
#Install
$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $ClusterName).Name

Invoke-Command -ComputerName $servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Install-AksHci
}

# if failed run next command and delete volume AKS in WAC and rerun S4-S7 then rerun top command
# Invoke-Command -ComputerName $servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
#     Uninstall-AksHci
# }
