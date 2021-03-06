. "$PSScriptRoot\..\config.ps1"

# *********************
# you can change VMSize

#****************************
# shutdown 2 nodes vm first, and then turn on, and also close this powershell session and restart a new session, wait a moment then run

DisableCredSSP

#region create AKS HCI cluster
#Jaromirk note: it would be great if I could specify HCI Cluster (like New-AksHciCluster -ComputerName)
Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {
    New-AksHciCluster -Name $using:WorkloadClusterName -linuxNodeCount 1 -linuxNodeVmSize Standard_D8s_v3 -windowsNodeCount 1 -windowsNodeVmSize Standard_D8s_v3 -controlplaneVmSize Standard_A2_v2 -EnableADAuth -loadBalancerVmSize Standard_A2_v2 #smallest possible VMs
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

#region Remove Cluster

# $ClusterNode=(Get-ClusterNode -Cluster $HciClusterName).Name | Select-Object -First 1
# Invoke-Command -ComputerName $ClusterNode -ScriptBlock {
#     Remove-AksHciCluster -Name $using:WorkloadClusterName
# }

#endregion
