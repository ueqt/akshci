# DC
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
#add required modules (parsing required modules from kva.psd - it also requires certain version of modules)
#JaromirK note: it would be great if this dependency was downloaded automagically or if you would be ok with latest version (or some minimumversion)
$item=Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules\Kva" -Recurse | Where-Object name -eq kva.psd1
$RequiredModules=(Import-LocalizedData -BaseDirectory $item.Directory -FileName $item.Name).RequiredModules
foreach ($RequiredModule in $RequiredModules){
    if (!(Get-InstalledModule -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.RequiredVersion -ErrorAction Ignore)){
        Install-Module -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.RequiredVersion -Force
    }
}

#endregion