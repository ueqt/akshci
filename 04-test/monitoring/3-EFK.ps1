# https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging#easy-steps-to-setup-logging-to-use-local-port-forward-to-access-kibana
# https://raw.githubusercontent.com/microsoft/AKS-HCI-Apps/main/Logging/Setup-es-kibana-fluent-bit.ps1

./setup-efk.ps1 -installLogging $true -kubeconfigFile C:\Users\LabAdmin\.kube\config -namespace logging
