. "$PSScriptRoot\..\config.ps1"

# https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
# download kubectl and install

# Start-BitsTransfer -Source "https://dl.k8s.io/release/v1.22.0/bin/windows/amd64/kubectl.exe" -Destination "$env:USERPROFILE\Downloads\kubectl.exe"

choco install kubernetes-cli

kubectl version --client

# New-Item config -type file

EnableCredSSP

$password = ConvertTo-SecureString "$DomainAdminPassword" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("$Domain\$DomainAdminUser", $password)

$FirstSession=New-PSSession -ComputerName ($HciServers | Select-Object -First 1)
Invoke-Command -ComputerName $HciServers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Get-AksHciCredential -Name $using:WorkloadClusterName
}
#Copy kubeconfig to local computer
Copy-Item -Path "$env:userprofile\.kube" -Destination $env:userprofile -FromSession $FirstSession -Recurse -Force

# taint windows node first, otherwise cert-manager will fail
#kubectl taint nodes --all type=windows:NoSchedule
#kubectl taint nodes --all type:NoSchedule-
kubectl taint nodes -l beta.kubernetes.io/os=windows type=windows:NoSchedule


