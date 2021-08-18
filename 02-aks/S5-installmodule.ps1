. "$PSScriptRoot\..\config.ps1"

Invoke-Command -ComputerName $HciServers -ScriptBlock {
    Install-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.1.0 -AcceptLicense -Force
}

Install-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.1.0 -AcceptLicense -Force
