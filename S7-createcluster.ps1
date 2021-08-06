#region create AKS HCI cluster
#Jaromirk note: it would be great if I could specify HCI Cluster (like New-AksHciCluster -ComputerName)
$ClusterName="AzSHCI-Cluster"
$ClusterNode=(Get-ClusterNode -Cluster $clustername).Name | Select-Object -First 1
Invoke-Command -ComputerName $ClusterNode -ScriptBlock {
    New-AksHciCluster -Name demo -linuxNodeCount 1 -linuxNodeVmSize Standard_D16s_v3 -windowsNodeCount 1 -windowsNodeVmSize Standard_D16s_v3 -controlplaneVmSize Standard_A2_v2 -EnableADAuth -loadBalancerVmSize Standard_A2_v2 #smallest possible VMs
}

#distribute kubeconfig to other nodes (just to make it symmetric)
#Jaromirk note: I think this would be useful to do with new-akshcicluster
$ClusterNodes=(Get-ClusterNode -Cluster $clustername).Name
$FirstSession=New-PSSession -ComputerName ($ClusterNodes | Select-Object -First 1)
$OtherSessions=New-PSSession -ComputerName ($ClusterNodes | Select-Object -Skip 1)
#copy kube locally
Copy-Item -Path "$env:userprofile\.kube" -Destination "$env:userprofile\Downloads" -FromSession $FirstSession -Recurse -Force
#copy kube to other nodes
Foreach ($OtherSession in $OtherSessions){
    Copy-Item -Path "$env:userprofile\Downloads\.kube" -Destination $env:userprofile -ToSession $OtherSession -Recurse -Force
}

#VM Sizes
<#
Get-AksHciVmSize

          VmSize CPU MemoryGB
          ------ --- --------
         Default 4   4
  Standard_A2_v2 2   4
  Standard_A4_v2 4   8
 Standard_D2s_v3 2   8
 Standard_D4s_v3 4   16
 Standard_D8s_v3 8   32
Standard_D16s_v3 16  64
Standard_D32s_v3 32  128
 Standard_DS2_v2 2   7
 Standard_DS3_v2 2   14
 Standard_DS4_v2 8   28
 Standard_DS5_v2 16  56
Standard_DS13_v2 8   56
 Standard_K8S_v1 4   2
Standard_K8S2_v1 2   2
Standard_K8S3_v1 4   6

#>
#endregion