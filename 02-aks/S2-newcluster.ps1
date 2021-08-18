. "$PSScriptRoot\..\config.ps1"

# create vSwitch
Invoke-Command -ComputerName $HciServers -ScriptBlock {
    New-VMSwitch -Name vSwitch -EnableEmbeddedTeaming $TRUE -NetAdapterName (Get-NetIPAddress -IPAddress 10.* ).InterfaceAlias
}

#create cluster
New-Cluster -Name $HciClusterName -Node $HciServers
Start-Sleep 5
Clear-DNSClientCache

# add file share witness
# Create new directory
$WitnessName=$HciClusterName+"Witness"
Invoke-Command -ComputerName DC -ScriptBlock { new-item -Path c:\Shares -Name $using:WitnessName -ItemType Directory }
$accounts=@()
$accounts+="$Domain\$($HciClusterName)$"
$accounts+="$Domain\Domain Admins"
New-SmbShare -Name $WitnessName -Path "c:\Shares\$WitnessName" -FullAccess $accounts -CimSession DC
# Set NTFS permissions
Invoke-Command -ComputerName DC -ScriptBlock { (Get-SmbShare $using:WitnessName).PresetPathAcl | Set-Acl }
# Set Quorum if always fail, please sign in DC first
Set-ClusterQuorum -Cluster $HciClusterName -FileShareWitness "\\DC\$WitnessName"

#Enable S2D
Enable-ClusterS2D -CimSession $HciClusterName -Verbose -Confirm:0