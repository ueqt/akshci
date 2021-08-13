$ClusterName="AzSHCI-Cluster"

$Servers=(Get-ClusterNode -Cluster $ClusterName).Name
Invoke-Command -ComputerName $Servers -ScriptBlock {
    Install-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.1.0 -AcceptLicense -Force
}

Install-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.1.0 -AcceptLicense -Force
