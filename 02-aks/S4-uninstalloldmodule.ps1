. "$PSScriptRoot\..\config.ps1"

#region Install required modules for AKSHCI https://docs.microsoft.com/en-us/azure-stack/aks-hci/kubernetes-walkthrough-powershell

Invoke-Command -ComputerName $HciServers -ScriptBlock {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    Install-PackageProvider -Name NuGet -Force 
    Install-Module -Name PowershellGet -Force

    Uninstall-Module -Name AksHci -AllVersions -Force -ErrorAction:SilentlyContinue 
    Uninstall-Module -Name Kva -AllVersions -Force -ErrorAction:SilentlyContinue 
    Uninstall-Module -Name Moc -AllVersions -Force -ErrorAction:SilentlyContinue 
    Uninstall-Module -Name MSK8SDownloadAgent -AllVersions -Force -ErrorAction:SilentlyContinue 
    Unregister-PSRepository -Name WSSDRepo -ErrorAction:SilentlyContinue 
    Unregister-PSRepository -Name AksHciPSGallery -ErrorAction:SilentlyContinue 
    Unregister-PSRepository -Name AksHciPSGalleryPreview -ErrorAction:SilentlyContinue
    [Environment]::Exit(1)
    Exit
}


Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -Force 
Install-Module -Name PowershellGet -Force

Uninstall-Module -Name AksHci -AllVersions -Force -ErrorAction:SilentlyContinue 
Uninstall-Module -Name Kva -AllVersions -Force -ErrorAction:SilentlyContinue 
Uninstall-Module -Name Moc -AllVersions -Force -ErrorAction:SilentlyContinue 
Uninstall-Module -Name MSK8SDownloadAgent -AllVersions -Force -ErrorAction:SilentlyContinue 
Unregister-PSRepository -Name WSSDRepo -ErrorAction:SilentlyContinue 
Unregister-PSRepository -Name AksHciPSGallery -ErrorAction:SilentlyContinue 
Unregister-PSRepository -Name AksHciPSGalleryPreview -ErrorAction:SilentlyContinue

[Environment]::Exit(1)
Exit

Write-Output "Please close your powershell and reopen" | Blue

#endregion