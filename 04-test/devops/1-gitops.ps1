# https://azurearcjumpstart.io/
# https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/day2/aks_stack_hci/aks_hci_gitops_basic/#deploy-gitops-configurations-and-perform-basic-gitops-flow-on-aks-on-azure-stack-hci-as-an-azure-arc-connected-cluster

Get-InstalledModule -Name Az -AllVersions | select Name,Version
az --version

Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration

Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration

Connect-AzAccount -UseDeviceAuthentication
$sp=New-AzADServicePrincipal -DisplayName "akshcigitops" -Role 'Contributor'
# $sp=Get-AzADServicePrincipal -DisplayName "akshcigitops"
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$sp
$BSTR
$UnsecureSecret

Install-Module -Name Az.Accounts -Repository PSGallery -RequiredVersion 2.2.4
Install-Module -Name Az.Resources -Repository PSGallery -RequiredVersion 3.2.0
Install-Module -Name AzureAD -Repository PSGallery -RequiredVersion 2.0.2.128
Install-Module -Name AksHci -Repository PSGallery
Import-Module Az.Accounts
Import-Module Az.Resources
Import-Module AzureAD
Import-Module AksHci
Exit

Get-Command -Module AksHci

.\az_k8sconfig_aks_hci.ps1

kubectl get pods -n prod
kubectl get pods -n cluster-mgmt
kubectl get svc -n prod
kubectl get ing -n prod