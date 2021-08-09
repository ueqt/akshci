# install chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# install helm
choco feature enable -n allowGlobalConfirmation
cinst kubernetes-helm
