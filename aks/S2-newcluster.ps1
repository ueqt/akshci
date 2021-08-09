$Servers="AzSHCI1","AzSHCI2"
$ClusterName="AzSHCI-Cluster"

# create vSwitch
Invoke-Command -ComputerName $Servers -ScriptBlock {New-VMSwitch -Name vSwitch -EnableEmbeddedTeaming $TRUE -NetAdapterName (Get-NetIPAddress -IPAddress 10.* ).InterfaceAlias}

#create cluster
New-Cluster -Name $ClusterName -Node $Servers
Start-Sleep 5
Clear-DNSClientCache

# add file share witness
# Create new directory
$WitnessName=$ClusterName+"Witness"
Invoke-Command -ComputerName DC -ScriptBlock {new-item -Path c:\Shares -Name $using:WitnessName -ItemType Directory}
$accounts=@()
$accounts+="corp\$($ClusterName)$"
$accounts+="corp\Domain Admins"
New-SmbShare -Name $WitnessName -Path "c:\Shares\$WitnessName" -FullAccess $accounts -CimSession DC
# Set NTFS permissions
Invoke-Command -ComputerName DC -ScriptBlock {(Get-SmbShare $using:WitnessName).PresetPathAcl | Set-Acl}
# Set Quorum
Set-ClusterQuorum -Cluster $ClusterName -FileShareWitness "\\DC\$WitnessName"

#Enable S2D
Enable-ClusterS2D -CimSession $ClusterName -Verbose -Confirm:0