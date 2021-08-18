. "$PSScriptRoot\..\..\config.ps1"

# https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters
# https://github.com/microsoft/MSLab/blob/master/Scenarios/AzSHCI%20and%20Kubernetes/Scenario.ps1

# 1. install Azure CLI
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
rm .\AzureCLI.msi

# 2. connect cluster to azure arc

az upgrade
az login --use-device-code

az extension add --name connectedk8s
az extension add --name k8s-extension

az extension update --name connectedk8s
az extension update --name k8s-extension

Install-Module -Name Az.ConnectedKubernetes

Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Register-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation

Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Get-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation

# Enable Azure Arc

# $connaks = Get-AzConnectedKubernetes -ResourceGroupName $HciResourceGroupName -Name 4aed5ba2-e641-4c61-9a9b-a3d75ccce070
# Remove-AzConnectedKubernetes -InputObject $connaks

# Remove-AzConnectedKubernetes -ClusterName $HciClusterName -ResourceGroupName $HciResourceGroupName
# New-AzConnectedKubernetes -ClusterName $HciClusterName -ResourceGroupName $HciResourceGroupName -Location eastus

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ExtendedLocation

az provider show -n Microsoft.Kubernetes -o table
az provider show -n Microsoft.KubernetesConfiguration -o table
az provider show -n Microsoft.ExtendedLocation -o table

az connectedk8s connect --name $HciClusterName --resource-group $HciResourceGroupName
az connectedk8s list --resource-group $HciResourceGroupName --output table

kubectl get deployments,pods -n azure-arc
Get-AzConnectedKubernetes -ResourceGroupName $HciResourceGroupName

# 3. Create Azure Monitor Extension
# 服务无法将敏感信息保留 48 小时以上。 如果已启用 Azure Arc 的 Kubernetes 代理保持网络连接的时间不超过 48 小时，且无法确定是否要在群集上创建扩展，则扩展会转换为 Failed 状态。 一旦进入 Failed 状态，你就需要再次运行 k8s-extension create 以创建全新的扩展 Azure 资源。
# 用于容器的 Azure Monitor 是单一实例扩展（在每个群集上只需要一个）。 需要清理所有以前的用于容器的 Azure Monitor（不带扩展）Helm 图表安装，才能通过扩展安装同一组件。 请按照运行 az k8s-extension create 之前删除 Helm 图表中的说明操作。
az k8s-extension create --name azuremonitor-containers  --extension-type Microsoft.AzureMonitor.Containers --scope cluster --cluster-name $HciClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters
az k8s-extension show --name azuremonitor-containers --cluster-name $HciClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters
az k8s-extension list --cluster-name $HciClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters
# az k8s-extension delete --name azuremonitor-containers --cluster-name $HciClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters