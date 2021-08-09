
#distribute kubeconfig to other nodes (just to make it symmetric)
#Jaromirk note: I think this would be useful to do with new-akshcicluster
$ClusterNodes=(Get-ClusterNode -Cluster $Clustername).Name
$FirstSession=New-PSSession -ComputerName ($ClusterNodes | Select-Object -First 1)
$OtherSessions=New-PSSession -ComputerName ($ClusterNodes | Select-Object -Skip 1)
#copy kube locally
Copy-Item -Path "$env:userprofile\.kube" -Destination "$env:userprofile\Downloads" -FromSession $FirstSession -Recurse -Force
#copy kube to other nodes
Foreach ($OtherSession in $OtherSessions){
    Copy-Item -Path "$env:userprofile\Downloads\.kube" -Destination $env:userprofile -ToSession $OtherSession -Recurse -Force
}
