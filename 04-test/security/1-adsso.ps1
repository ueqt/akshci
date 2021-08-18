. "$PSScriptRoot\..\..\config.ps1"

# https://docs.microsoft.com/en-us/azure-stack/aks-hci/ad-sso
# https://docs.microsoft.com/zh-cn/azure-stack/aks-hci/ad-sso
# https://techcommunity.microsoft.com/t5/azure-stack-blog/aks-hci-now-supports-strong-authentication-using-active/ba-p/2121246
# https://www.drware.com/aks-hci-now-supports-strong-authentication-using-active-directory-credentials/

# run at AzSHCI1

# Create the API server AD Account and the keytab file
Add-WindowsFeature RSAT-AD-PowerShell
Get-WindowsFeature -Name RSAT-AD-PowerShell
# New-ADUser -Name apiserver -ServicePrincipalNames k8s/apiserver -AccountPassword (ConvertTo-SecureString "$DomainAdminPassword" -AsPlainText -Force) -KerberosEncryptionType AES128 -Enabled 1
Get-ADUser -Filter *
# Remove-ADUser -Identity "CN=apiserver,CN=Users,DC=$Domain,DC=contoso,DC=com"

# ktpass /out current.keytab /princ k8s/apiserver@$(Domain) /mapuser $Domain\apiserver /crypto all /pass $DomainAdminPassword /ptype KRB5_NT_PRINCIPAL

ktpass /out current.keytab /princ k8s/apiserver@$(Domain) /mapuser $Domain\$DomainAdminUser /crypto all /pass $DomainAdminPassword /ptype KRB5_NT_PRINCIPAL

whoami /user

# (New-Object System.Security.Principal.NTAccount($Domain\apiserver)).Translate([System.Security.Principal.SecurityIdentifier]).value

# kubectl logs ad-auth-webhook-xxx

# Step 2: Install AD authentication
Install-AksHciAdAuth -name demo -keytab .\current.keytab -SPN k8s/apiserver@$(Domain) -adminUser $Domain\$DomainAdminUser
# Uninstall-AksHciAdAuth -name demo

# Step 3: Test the AD webhook and keytab file
Get-AksHciCredential -name demo

kubectl get pods -n=kube-system
# check ad-auth-webhook-xxxx exists

kubectl get secrets -n=kube-system
# check keytab exists

# Step 4: Create the AD kubeconfig file
Get-AksHciCredential -name demo -configPath .\AdKubeconfig -adAuth

# Step 5: Copy kubeconfig and other files to the client machine

# 将在上一步中创建的 AD kubeconfig 文件复制到 $env:USERPROFILE.kube\config。

# 创建文件夹路径 c:\adsso，并将以下文件从 Azure Stack HCI 群集复制到客户端计算机。

# 将 $env:ProgramFiles\AksHci 下的 Kubectl.exe 复制到 c:\adsso
# 将 $env:ProgramFiles\AksHci 下的 Kubectl-adsso.exe 复制到 c:\adsso

# add c:\adsso to environment $PATH

# **** Currently, AD SSO connectivity is only supported for workload clusters