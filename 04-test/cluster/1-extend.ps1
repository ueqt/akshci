. "$PSScriptRoot\..\..\config.ps1"

Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {
    Get-AksHciNodePool -clusterName $using:WorkloadClusterName
}

Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {  
    $nodename="demo-linux"
    Set-AksHciNodePool -clusterName $using:WorkloadClusterName -name $nodename -count 2
}