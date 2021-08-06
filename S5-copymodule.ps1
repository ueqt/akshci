#DC
#distribute modules to cluster nodes
$ClusterName="AzSHCI-Cluster"
$Servers=(Get-ClusterNode -Cluster $Clustername).Name
$ModuleNames="AksHci","Moc","Kva","TraceProvider"
$PSSessions=New-PSSession -ComputerName $Servers
Foreach ($PSSession in $PSSessions){
    Foreach ($ModuleName in $ModuleNames){
        Copy-Item -Path $env:ProgramFiles\windowspowershell\modules\$ModuleName -Destination $env:ProgramFiles\windowspowershell\modules -ToSession $PSSession -Recurse -Force
    }
    Foreach ($ModuleName in $RequiredModules.ModuleName){
        Copy-Item -Path $env:ProgramFiles\windowspowershell\modules\$ModuleName -Destination $env:ProgramFiles\windowspowershell\modules -ToSession $PSSession -Recurse -Force
    }
}