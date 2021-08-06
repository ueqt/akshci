# akshci
aks-hci

## instal HCI

```bash
# download MSLab for install aks on hci
git clone https://github.com/microsoft/MSLab.git
cd /MSLab/Scripts
# in PowerShell(Admin)
./0_Shared.ps1
./1_Prereq.ps1
# Prapare en_windows_server_2019_updated_may_2021_x64_dvd_b153c852.iso from my.visualstudio.com
./Tools/DownloadLatestCUs.ps1 # download server 2019 CU
./2_CreateParentDisks.ps1 # select 2019 iso and CU
# Copy ParentDisks for quick install
# Copy LabConfig.ps1 to /MSLab/Scripts
./3_Deploy.ps1
```

use windows server 2019 as manager is better than win10

```bash
# after 2 done, you can backup LAB folder
# if need redeploy, just delete all vm, and then copy delete LAB, and copy LAB backup, then you can rerun 3_deploy.ps1
```

## install AKS

```bash
# Pay attention to run machines.
MSLab\Scenarios\AzSHCI and Kubernetes\Scenario.ps1

# first run last scope for install edge and WAC
# WAC need install manually
# you can use edge access https://localhost to access WAC
# in WAC, Cluster Manager add AzSHci-Cluster
# update plugins

# second run scope Run from DC
# run region one by one, if fail rerun
# region 2 need use self azure account for AAD, corp azure account is not valid
# region 5 can change VM size
New-AksHciCluster -Name demo -linuxNodeCount 1 -linuxNodeVmSize Standard_D8s_v3  -windowsNodeCount 1 -windowsNodeVmSize Standard_D2s_v3 -controlplaneVmSize Standard_A2_v2 -EnableADAuth -loadBalancerVmSize Standard_A2_v2
# install one linux and one windows node
# in region Install required modules for AKSHCI if copy failed, manually copy C:\Program Files\WindowsPowerShell\Modules to \\azshci1\c$\Program Files\WindowsPowerShell\Modules and \\azshci2\c$\Program Files\WindowsPowerShell\Modules
# before region 4 run Connect-AzAccount first
```

https://docs.microsoft.com/en-us/azure-stack/aks-hci/troubleshoot-known-issues

```bash
# Copy-Item fail solution
# https://serverfault.com/questions/1020068/settings-to-upload-large-file-via-winrm-and-copy-item-powershell
# get remote MaxEnvelopeSizekb
$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $Clustername).Name
$PSSessions=New-PSSession -ComputerName $Servers
Foreach ($PSSession in $PSSessions){
   Invoke-Command -Session $PSSessions -ScriptBlock {  get-WSManInstance -ResourceURI winrm/config | Select-Object MaxEnvelopeSizekb }
}
# get self MaxEnvelopeSizekb
get-WSManInstance -ResourceURI winrm/config | Select-Object MaxEnvelopeSizekb
# if value not same then fail
set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = "256000" }
Invoke-Command -Session $ses -ScriptBlock {  set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = "256000" }}
```

Windows Administrator Tools -> Failover Cluster Manager


## install helm & rancher
