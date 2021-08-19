. "$PSScriptRoot\..\..\config.ps1"

# https://docs.microsoft.com/en-in/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster
# https://docs.microsoft.com/en-in/azure/azure-arc/kubernetes/tutorial-gitops-ci-cd

az extension add --name connectedk8s
az extension add --name k8s-configuration

az extension update --name connectedk8s
az extension update --name k8s-configuration

az k8s-configuration create `
    --name cluster-config `
    --cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName `
    --operator-instance-name cluster-config --operator-namespace cluster-config `
    --repository-url https://github.com/ueqt/arc-k8s-demo `
    --scope cluster --cluster-type connectedClusters `
    --operator-params="--git-poll-interval 3s"

az k8s-configuration show --name cluster-config --cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters

# az k8s-configuration show --resource-group $HciResourceGroupName --cluster-name $WorkloadClusterName --name cluster-config --cluster-type connectedClusters --query 'repositoryPublicKey' 

kubectl get ns --show-labels

kubectl -n cluster-config get deploy -o wide

kubectl -n team-a get cm -o yaml
kubectl -n itops get all

kubectl get pod
kubectl get svc
# kubectl port-forward arc-k8s-demo-55db94955-snnlj 8080:8080

# az k8s-configuration delete --name cluster-config --cluster-name $WorkloadClusterName --resource-group $HciResourceGroupName --cluster-type connectedClusters

# flux check --pre
