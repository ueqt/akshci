. "$PSScriptRoot\..\config.ps1"

# Install
$password = ConvertTo-SecureString "$DomainAdminPassword" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ("$Domain\$DomainAdminUser", $password)

EnableCredSSP

#***************
# WARNING: Unable to acquire token for tenant 'ad4b6bf6-6f42-418f-af5b-6a4dd200af6e' with error 'The access token expiry UTC time '8/10/2021 5:06:43 AM' is earlier than current UTC time '8/10/2021 5:13:31 AM'.'
# if upper issue, close powershell, reopen a new powershell session, and uninstall-akshci then rerun S7

Invoke-Command -ComputerName $HciServers[0] -Credential $Credentials -Authentication Credssp -ScriptBlock {
    Install-AksHci
    # if failed run next command and then rerun top command
    # Uninstall-AksHci
}
