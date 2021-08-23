. "$PSScriptRoot\..\config.ps1"

#region setup AKS (PowerShell)

# set variables
$vSwitchName="vSwitch"
$vNetName="aksvnet"
$VolumeName="AKS"
$VIPPoolStart="10.0.0.100"
$VIPPoolEnd="10.0.0.200"

# JaromirK note: it would be great if I could simply run "Initialize-AksHciNode -ComputerName $HciClusterName". I could simply skip credssp. Same applies for AksHciConfig and AksHciRegistration

EnableCredSSP

$password = ConvertTo-SecureString "$DomainAdminPassword" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("$Domain\$DomainAdminUser", $password)

Invoke-Command -ComputerName $HciServers -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Initialize-AksHciNode
}

# ********************************
# if this error: Cannot bind argument to parameter 'Path' because it is an empty string. please manually delete volume in WAC 
# if volume exists please manually delete volume in WAC
# Create  volume for AKS
New-Volume -FriendlyName $VolumeName -CimSession $HciClusterName -Size 1TB -StoragePoolFriendlyName S2D*
# make sure failover clustering management tools are installed on nodes
Invoke-Command -ComputerName $HciServers -ScriptBlock {
    Install-WindowsFeature -Name RSAT-Clustering-PowerShell
}
# configure aks
Invoke-Command -ComputerName $HciServers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    $vnet = New-AksHciNetworkSetting -Name $using:vNetName -vSwitchName $using:vSwitchName -vippoolstart $using:vippoolstart -vippoolend $using:vippoolend
    #Set-AksHciConfig -vnet $vnet -workingDir c:\clusterstorage\$using:VolumeName\Images -imageDir c:\clusterstorage\$using:VolumeName\Images -cloudConfigLocation c:\clusterstorage\$using:VolumeName\Config -ClusterRoleName "$($using:ClusterName)_AKS" -controlPlaneVmSize 'default' # Get-AksHciVmSize
    Set-AksHciConfig -vnet $vnet -imageDir c:\clusterstorage\$using:VolumeName\Images -cloudConfigLocation c:\clusterstorage\$using:VolumeName\Config -ClusterRoleName "$($using:HciClusterName)_AKS" -controlPlaneVmSize 'default' # Get-AksHciVmSize
}

# validate config
Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {
    Get-AksHciConfig
}

# register in Azure
if (-not (Get-AzContext)){
    Connect-AzAccount -UseDeviceAuthentication
}
$subscription=Get-AzSubscription
if (($subscription).count -gt 1){
    $subscription | Out-GridView -OutputMode Single | Set-AzContext
}
$subscriptionID=(Get-AzContext).Subscription.id

# make sure Kubernetes resource providers are registered
if (!(Get-InstalledModule -Name Az.Resources -ErrorAction Ignore)){
    Install-Module -Name Az.Resources -Force
}
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration

# wait until resource providers are registered
$Providers="Microsoft.Kubernetes","Microsoft.KubernetesConfiguration"
foreach ($Provider in $Providers){
    do {
        $Status=Get-AzResourceProvider -ProviderNamespace $Provider
        Write-Output "Registration Status - $Provider : $(($Status.RegistrationState -match 'Registered').Count)/$($Status.Count)"
        Start-Sleep 1
    } while (($Status.RegistrationState -match "Registered").Count -ne ($Status.Count))
}

# Register AZSHCi without prompting for creds
$armTokenItemResource = "https://management.core.windows.net/"
$graphTokenItemResource = "https://graph.windows.net/"
$azContext = Get-AzContext
$authFactory = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory
$graphToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $graphTokenItemResource).AccessToken
$armToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $armTokenItemResource).AccessToken
$id = $azContext.Account.Id

Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {
    Set-AksHciRegistration -SubscriptionID $using:subscriptionID -GraphAccessToken $using:graphToken -ArmAccessToken $using:armToken -AccountId $using:id -ResourceGroupName $using:HciResourceGroupName
}

#endregion