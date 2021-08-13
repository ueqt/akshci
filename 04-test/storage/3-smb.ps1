# https://blog.engineer-memo.com/2021/07/15/aks-on-azure-stack-hci-%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E3%81%AE%E3%83%A1%E3%83%A2/amp/#i-5

# first create a share folder on this pc
# 共享名
$ShareName = 'share'
# 共享路径
$Path = 'c:\share'

New-Item -Force -ItemType directory -Path $Path
New-SmbShare -Name $ShareName -Path $Path -FullAccess everyone

# https://docs.microsoft.com/en-us/azure-stack/aks-hci/container-storage-interface-files

$ClusterName="AzSHCI-Cluster"
$ClusterNode=(Get-ClusterNode -Cluster $Clustername).Name | Select-Object -First 1
Invoke-Command -ComputerName $ClusterNode -ScriptBlock {
    Install-AksHciCsiSmb -clusterName demo
    #Uninstall-AksHciCsiSMB -clusterName demo
}

# https://github.com/kubernetes-csi/csi-driver-smb/blob/master/docs/csi-debug.md
# kubectl -n kube-system get pod -o wide --watch -l app=csi-smb-controller
# kubectl -n kube-system get pod -o wide --watch -l app=csi-smb-node

kubectl create secret generic smbcreds --from-literal username="LabAdmin" --from-literal password="LS1setup!" --from-literal domain="CORP"

kubectl get CSIDriver -A

#kubectl get pod -n kube-system
#kubectl logs csi-smb-node-cw4hc -c smb -n kube-system
#kubectl logs csi-smb-node-cw4hc -c node-driver-registrar -n kube-system


# $User = "CORP\LabAdmin"
# $PWord = ConvertTo-SecureString -String "LS1setup!" -AsPlainText -Force
# $Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $Pword
# New-SmbGlobalMapping -LocalPath x: -RemotePath \\mgmt\share -Credential $Credential
# Get-SmbGlobalMapping
# cd x:
# dir