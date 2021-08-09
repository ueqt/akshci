# https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
# download kubectl and install

# Start-BitsTransfer -Source "https://dl.k8s.io/release/v1.22.0/bin/windows/amd64/kubectl.exe" -Destination "$env:USERPROFILE\Downloads\kubectl.exe"

choco install kubernetes-cli

kubectl version --client
cd ~
mkdir .kube
cd .kube
# New-Item config -type file

# Enable CredSSP
# Temporarily enable CredSSP delegation to avoid double-hop issue
foreach ($Server in $Servers){
    Enable-WSManCredSSP -Role "Client" -DelegateComputer $Server -Force
}
Invoke-Command -ComputerName $Servers -ScriptBlock { Enable-WSManCredSSP Server -Force }

$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $ClusterName).Name
$password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("CORP\LabAdmin", $password)

Invoke-Command -ComputerName $Servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Get-AksHciCredential -Name demo  #demo is akscluster's name
    #Copy kubeconfig to other/local computer
    Copy-Item -Path "$env:userprofile\.kube" -Destination "\\Mgmt\c$\Users\labadmin\.kube" -Recurse -Force
}

