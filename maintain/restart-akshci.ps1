# restart akshci
# https://docs.microsoft.com/en-us/azure-stack/aks-hci/restart-cluster
$ClusterName="AzSHCI-Cluster"
$ClusterNode=(Get-ClusterNode -Cluster $Clustername).Name | Select-Object -First 1
Invoke-Command -ComputerName $ClusterNode -ScriptBlock {
    Restart-AksHci
}