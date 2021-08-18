. "$PSScriptRoot\..\..\config.ps1"
. "$PSScriptRoot\config.ps1"

# https://github.com/microsoft/azure_arc/blob/main/azure_arc_k8s_jumpstart/aks_stack_hci/gitops/basic/az_k8sconfig_aks_hci.ps1
# <--- Change the following environment variables according to your Azure service principal name --->

# Connect to Azure
Write-Host "Log in to Azure with Service Principal & Getting AKS credentials (kubeconfig)"
az login --service-principal --username $appId --password $password --tenant $tenant
az account set --subscription $subscriptionId

#Configure Extension install
az config set extension.use_dynamic_install=yes_without_prompt

# #Get AKS on Azure Stack HCI cluster credentials
# Get-AksHciCredential -Name $WorkloadClusterName -Confirm:$false

# # Create a namespace for your ingress resources
kubectl create ns cluster-mgmt

# # Helm Install 

# choco install kubernetes-helm

# # Add the official stable repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# # Use Helm to deploy an NGINX ingress controller
helm install nginx ingress-nginx/ingress-nginx -n cluster-mgmt

az k8s-configuration create `
--name hello-arc `
--cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName `
--operator-instance-name hello-arc --operator-namespace prod `
--enable-helm-operator `
--helm-operator-params='--set helm.versions=v3' `
--repository-url $appClonedRepo `
--scope namespace --cluster-type connectedClusters `
--operator-params="--git-poll-interval 3s --git-readonly --git-path=releases/prod"