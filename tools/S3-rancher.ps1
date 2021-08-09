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

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4

kubectl get pods --namespace cert-manager

helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.my.org

kubectl -n cattle-system rollout status deploy/rancher

kubectl -n cattle-system get deploy rancher