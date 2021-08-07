# DC
# IMPORTANT: need use self azure account for AAD, corp azure account is not valid

#region Register Azure Stack HCI to Azure - if not registered, VMs are not added as cluster resources = AKS script will fail
$ClusterName="AzSHCI-Cluster"

#download Azure module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
if (!(Get-InstalledModule -Name Az.StackHCI -ErrorAction Ignore)){
    Install-Module -Name Az.StackHCI -Force
}

#login to azure
#download Azure module
if (!(Get-InstalledModule -Name az.accounts -ErrorAction Ignore)){
    Install-Module -Name Az.Accounts -Force
}
Connect-AzAccount -UseDeviceAuthentication

#select subscription if more available
$subscription=Get-AzSubscription
if (($subscription).count -gt 1){
    $subscription | Out-GridView -OutputMode Single | Set-AzContext
}

#grab subscription ID
$subscriptionID=(Get-AzContext).Subscription.id

#Register AZSHCi without prompting for creds
$armTokenItemResource = "https://management.core.windows.net/"
$graphTokenItemResource = "https://graph.windows.net/"
$azContext = Get-AzContext
$authFactory = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory
$graphToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $graphTokenItemResource).AccessToken
$armToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $armTokenItemResource).AccessToken
$id = $azContext.Account.Id
Register-AzStackHCI -SubscriptionID $subscriptionID -ComputerName $ClusterName -GraphAccessToken $graphToken -ArmAccessToken $armToken -AccountId $id

#Install Azure Stack HCI RSAT Tools to all nodes
$Servers=(Get-ClusterNode -Cluster $ClusterName).Name
Invoke-Command -ComputerName $Servers -ScriptBlock {
    Install-WindowsFeature -Name RSAT-Azure-Stack-HCI
}

#Validate registration (query on just one node is needed)
Invoke-Command -ComputerName $ClusterName -ScriptBlock {
    Get-AzureStackHCI
}
#endregion#region Register Azure Stack HCI to Azure - if not registered, VMs are not added as cluster resources = AKS script will fail
