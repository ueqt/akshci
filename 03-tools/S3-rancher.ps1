helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl create namespace cattle-system

# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml

# **Important:**
# If you are running Kubernetes v1.15 or below, you
# will need to add the `--validate=false` flag to your
# kubectl apply command, or else you will receive a
# validation error relating to the
# x-kubernetes-preserve-unknown-fields field in
# cert-manager’s CustomResourceDefinition resources.
# This is a benign error and occurs due to the way kubectl
# performs resource validation.

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# taint windows node first, otherwise cert-manager will fail
#kubectl taint nodes --all type=windows:NoSchedule
#kubectl taint nodes --all type:NoSchedule-
kubectl taint nodes -l beta.kubernetes.io/os=windows type=windows:NoSchedule

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4

# if fail run helm uninstall cert-manager jetstack/cert-manager --namespace cert-manager and rerun last command

kubectl get pods --namespace cert-manager

helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org

kubectl -n cattle-system rollout status deploy/rancher

kubectl -n cattle-system get deploy rancher

# function Get-ScriptDirectory {
#     if ($psise) {
#         Split-Path $psise.CurrentFile.FullPath
#     }
#     else {
#         $global:PSScriptRoot
#     }
# }

# $path=Get-ScriptDirectory

# kubectl patch svc rancher -n cattle-system --patch "$(cat $path\rancher-svc-patch.yaml)"

kubectl patch svc rancher -n cattle-system -p '{\"spec\": {\"ports\": [{\"port\": 443,\"targetPort\": 443,\"name\": \"https\"},{\"port\": 80,\"targetPort\": 80,\"name\": \"http\"}],\"type\": \"LoadBalancer\"}}'

Start-Sleep 15

kubectl get svc -n cattle-system

# you can access https://<EXTERNAL-IP for rancher>

# helm ls -A
# helm uninstall rancher -n cattle-system
