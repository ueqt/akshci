. "$PSScriptRoot\..\config.ps1"

#region Create 2 node cluster (just simple. Not for prod - follow hyperconverged scenario for real clusters https://github.com/microsoft/WSLab/tree/master/Scenarios/S2D%20Hyperconverged)

# Install features for management on server
Install-WindowsFeature -Name RSAT-Clustering,RSAT-Clustering-Mgmt,RSAT-Clustering-PowerShell,RSAT-Hyper-V-Tools

# Update servers
Invoke-Command -ComputerName $HciServers -ScriptBlock {
    # Grab updates
    $SearchCriteria = "IsInstalled=0"
    # $SearchCriteria = "IsInstalled=0 and DeploymentAction='OptionalInstallation'" #does not work, not sure why
    $ScanResult=Invoke-CimMethod -Namespace "root/Microsoft/Windows/WindowsUpdate" -ClassName "MSFT_WUOperations" -MethodName ScanForUpdates -Arguments @{SearchCriteria=$SearchCriteria}
    # apply updates (if not empty)
    if ($ScanResult.Updates){
        Invoke-CimMethod -Namespace "root/Microsoft/Windows/WindowsUpdate" -ClassName "MSFT_WUOperations" -MethodName InstallUpdates -Arguments @{Updates=$ScanResult.Updates}
    }

    # Install features on servers
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online -NoRestart 
    Install-WindowsFeature -Name "Failover-Clustering","RSAT-Clustering-Powershell","Hyper-V-PowerShell"
}

# restart servers
Restart-Computer -ComputerName $HciServers -Protocol WSMan -Wait -For PowerShell
# failsafe - sometimes it evaluates, that servers completed restart after first restart (hyper-v needs 2)
Start-sleep 20

#endregion