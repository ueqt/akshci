. "$PSScriptRoot\..\..\config.ps1"
. "$PSScriptRoot\config.ps1"

# Login to Azure & get AKS on HCI credentials
Write-Host "Log in to Azure with Service Principal"
az login --service-principal --username $appId --password $password --tenant $tenantId
az account set --subscription $subscriptionId
# Write-Host "Getting AKS on HCI credentials (kubeconfig)"
# Get-AksHciCredential -Name $HciClusterName

# Deleting GitOps Configurations from Azure Arc Kubernetes cluster
Write-Host "Deleting GitOps Configurations from Azure Arc Kubernetes cluster"
az k8s-configuration delete --name hello-arc --cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters -y
az k8s-configuration delete --name nginx-ingress --cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters -y

# Cleaning Kubernetes cluster
Write-Host "Cleaning Kubernetes cluster. You can safely ignore non-exist resources"
kubectl delete ns prod
kubectl delete ns cluster-mgmt

kubectl delete clusterrole cluster-mgmt-helm-cluster-mgmt-helm-operator
kubectl delete clusterrole hello-arc-helm-prod-helm-operator-crd
kubectl delete clusterrole nginx-ingress

kubectl delete clusterrolebinding cluster-mgmt-helm-cluster-mgmt-helm-operator
kubectl delete clusterrolebinding hello-arc-helm-prod-helm-operator
kubectl delete clusterrolebinding nginx-ingress

kubectl delete secret sh.helm.release.v1.azure-arc.v1 -n default