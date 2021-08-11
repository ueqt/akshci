#region Install required modules for AKSHCI https://docs.microsoft.com/en-us/azure-stack/aks-hci/kubernetes-walkthrough-powershell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck
Update-Module -Name PowerShellGet
#Install-Module -Name Az.Accounts -Repository PSGallery -RequiredVersion 2.2.4 -Force
#Install-Module -Name Az.Resources -Repository PSGallery -RequiredVersion 3.2.0 -Force
#Install-Module -Name AzureAD -Repository PSGallery -RequiredVersion 2.0.2.128 -Force
#to be able to install AKSHCI, powershellget 2.2.5 needs to be used - to this posh restart is needed
Start-Process -FilePath PowerShell -ArgumentList {
    Install-Module -Name AksHci -Repository PSGallery -Force -AcceptLicense
}
#endregion