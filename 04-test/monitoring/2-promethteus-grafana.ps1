# https://docs.microsoft.com/zh-cn/azure-stack/aks-hci/monitor-logging
# https://docs.microsoft.com/zh-cn/azure/azure-monitor/containers/container-insights-prometheus-integration

# 1. Prometheus

# on AzSHCI1

Install-AksHciMonitoring -Name demo -storageSizeGB 100 -retentionTimeHours 240

# Uninstall-AksHciMonitoring -Name demo

kubectl get svc -n monitoring

kubectl patch svc akshci-monitoring-prometheus-svc -n monitoring -p '{\"spec\": {\"ports\": [{\"port\": 9090,\"targetPort\": 9090,\"name\": \"http\"}],\"type\": \"LoadBalancer\"}}'

kubectl get svc -n monitoring

# http://akshci-monitoring-prometheus-svc.monitorinsg:9090

# 2. Grafana
# https://github.com/microsoft/AKS-HCI-Apps/blob/main/Monitoring/Grafana.md

kubectl apply -f https://raw.githubusercontent.com/microsoft/AKS-HCI-Apps/main/Monitoring/data-source.yaml
kubectl apply -f https://raw.githubusercontent.com/microsoft/AKS-HCI-Apps/main/Monitoring/dashboards.yaml

# kubectl delete -f https://raw.githubusercontent.com/microsoft/AKS-HCI-Apps/main/Monitoring/data-source.yaml
# kubectl delete -f https://raw.githubusercontent.com/microsoft/AKS-HCI-Apps/main/Monitoring/dashboards.yaml

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --version 6.11.0 --set nodeSelector."kubernetes\.io/os"=linux --set sidecar.dashboards.enabled=true --set sidecar.datasources.enabled=true -n monitoring

$encodedpassword=kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}"
$password=[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($encodedpassword))
$password
$POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl get svc -n monitoring
kubectl --namespace monitoring port-forward $POD_NAME 3000

# http://localhost:3000
# user: admin
# password: $password
