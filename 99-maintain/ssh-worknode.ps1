# https://docs.microsoft.com/en-us/azure-stack/aks-hci/ssh-connection

# find ip
kubectl get nodes -o wide

# in AzSHCI1 or AzSHCI2

# windows
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa administrator@10.0.0.14
powershell # enter powershell

# linux
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa clouduser@10.0.0.21

# change password
net user administrator *

ssh -i C:\ClusterStorage\AKS\AksHCI\.ssh\akshci_rsa clouduser@10.0.0.103