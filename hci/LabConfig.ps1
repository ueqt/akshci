$LabConfig=@{ DomainAdminName='LabAdmin'; AdminPassword='LS1setup!' ; Prefix = 'MSLab-' ; DCEdition='4'; Internet=$true ; TelemetryLevel='Full' ; TelemetryNickname='' ; AdditionalNetworksConfig=@(); VMs=@()}

#2 nodes for AzSHCI Cluster
1..2 | ForEach-Object {$VMNames="AzSHCI" ; $LABConfig.VMs += @{ VMName = "$VMNames$_" ; Configuration = 'S2D' ; ParentVHD = 'AzSHCI20H2_G2.vhdx' ; HDDNumber = 4 ; HDDSize= 4TB ; MemoryStartupBytes= 70GB; VMProcessorCount=8 ; NestedVirt=$true}}

#Windows 10 management machine (for Windows Admin Center)
#$LabConfig.VMs += @{ VMName = 'Win10'; ParentVHD = 'Win1020H1_G2.vhdx' ; MemoryStartupBytes= 24GB; VMProcessorCount=4 ; AddToolsVHD = $True ; MGMTNICs=1 }

#Windows Admin Center gateway
$LabConfig.VMs += @{ VMName = 'Mgmt' ; ParentVHD = 'Win2019_G2.vhdx' ; VMProcessorCount=4 ; MGMTNICs=1 }