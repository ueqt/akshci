# DC
#region setup AKS (PowerShell)
    #set variables
    $ClusterName="AzSHCI-Cluster"
    $vSwitchName="vSwitch"
    $vNetName="aksvnet"
    $VolumeName="AKS"
    $Servers=(Get-ClusterNode -Cluster $ClusterName).Name
    $VIPPoolStart="10.0.0.100"
    $VIPPoolEnd="10.0.0.200"
    $resourcegroupname="$ClusterName-rg"

    #JaromirK note: it would be great if I could simply run "Initialize-AksHciNode -ComputerName $ClusterName". I could simply skip credssp. Same applies for AksHciConfig and AksHciRegistration

    #Enable CredSSP
    # Temporarily enable CredSSP delegation to avoid double-hop issue
    foreach ($Server in $servers){
        Enable-WSManCredSSP -Role "Client" -DelegateComputer $Server -Force
    }
    Invoke-Command -ComputerName $servers -ScriptBlock { Enable-WSManCredSSP Server -Force }

    $password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
    $Credentials = New-Object System.Management.Automation.PSCredential ("CORP\LabAdmin", $password)

    Invoke-Command -ComputerName $servers -Credential $Credentials -Authentication Credssp -ScriptBlock {
        Initialize-AksHciNode
    }

    #Create  volume for AKS
    New-Volume -FriendlyName $VolumeName -CimSession $ClusterName -Size 1TB -StoragePoolFriendlyName S2D*
    #make sure failover clustering management tools are installed on nodes
    Invoke-Command -ComputerName $servers -ScriptBlock {
        Install-WindowsFeature -Name RSAT-Clustering-PowerShell
    }
    #configure aks
    Invoke-Command -ComputerName $servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
        $vnet = New-AksHciNetworkSetting -Name $using:vNetName -vSwitchName $using:vSwitchName -vippoolstart $using:vippoolstart -vippoolend $using:vippoolend
        #Set-AksHciConfig -vnet $vnet -workingDir c:\clusterstorage\$using:VolumeName\Images -imageDir c:\clusterstorage\$using:VolumeName\Images -cloudConfigLocation c:\clusterstorage\$using:VolumeName\Config -ClusterRoleName "$($using:ClusterName)_AKS" -controlPlaneVmSize 'default' # Get-AksHciVmSize
        Set-AksHciConfig -vnet $vnet -imageDir c:\clusterstorage\$using:VolumeName\Images -cloudConfigLocation c:\clusterstorage\$using:VolumeName\Config -ClusterRoleName "$($using:ClusterName)_AKS" -controlPlaneVmSize 'default' # Get-AksHciVmSize
    }

    #validate config
    Invoke-Command -ComputerName $servers[0] -ScriptBlock {
        Get-AksHciConfig
    }

    #register in Azure
    if (-not (Get-AzContext)){
        Connect-AzAccount -UseDeviceAuthentication
    }
    $subscription=Get-AzSubscription
    if (($subscription).count -gt 1){
        $subscription | Out-GridView -OutputMode Single | Set-AzContext
    }
    $subscriptionID=(Get-AzContext).Subscription.id

    #make sure Kubernetes resource providers are registered
    if (!(Get-InstalledModule -Name Az.Resources -ErrorAction Ignore)){
        Install-Module -Name Az.Resources -Force
    }
    Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
    Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration

    #wait until resource providers are registered
    $Providers="Microsoft.Kubernetes","Microsoft.KubernetesConfiguration"
    foreach ($Provider in $Providers){
        do {
            $Status=Get-AzResourceProvider -ProviderNamespace $Provider
            Write-Output "Registration Status - $Provider : $(($status.RegistrationState -match 'Registered').Count)/$($Status.Count)"
            Start-Sleep 1
        } while (($status.RegistrationState -match "Registered").Count -ne ($Status.Count))
    }

    #Register AZSHCi without prompting for creds
    $armTokenItemResource = "https://management.core.windows.net/"
    $graphTokenItemResource = "https://graph.windows.net/"
    $azContext = Get-AzContext
    $authFactory = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory
    $graphToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $graphTokenItemResource).AccessToken
    $armToken = $authFactory.Authenticate($azContext.Account, $azContext.Environment, $azContext.Tenant.Id, $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $armTokenItemResource).AccessToken
    $id = $azContext.Account.Id

    Invoke-Command -computername $servers[0] -ScriptBlock {
        Set-AksHciRegistration -SubscriptionID $using:subscriptionID -GraphAccessToken $using:graphToken -ArmAccessToken $using:armToken -AccountId $using:id -ResourceGroupName $using:resourcegroupname
    }

    #or with Device Authentication
    <#
    Invoke-Command -computername $servers[0] -ScriptBlock {
        Set-AksHciRegistration -SubscriptionID $using:subscriptionID -ResourceGroupName $using:resourcegroupname -UseDeviceAuthentication
    }
    #>

    #Install
    Invoke-Command -ComputerName $servers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
        Install-AksHci
    }

    # Disable CredSSP
    Disable-WSManCredSSP -Role Client
    Invoke-Command -ComputerName $servers -ScriptBlock { Disable-WSManCredSSP Server }
#endregion