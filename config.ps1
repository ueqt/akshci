$Domain="Corp"
$DomainAdminUser="LabAdmin"
$DomainAdminPassword="LS1setup!"
$HciClusterName="AzSHCI-Cluster"
$HciServers="AzSHCI1","AzSHCI2" # $HciServers=(Get-ClusterNode -Cluster $HciClusterName).Name
# $ClusterNode=(Get-ClusterNode -Cluster $HciClusterName).Name | Select-Object -First 1
$HciResourceGroupName="$HciClusterName-rg"
$WorkloadClusterName="demo"

function Blue {
    process { Write-Host $_ -ForegroundColor Blue }
}

function Red {
    process { Write-Host $_ -ForegroundColor Red }
}

function Green {
    process { Write-Host $_ -ForegroundColor Green }
}

function Yellow {
    process { Write-Host $_ -ForegroundColor Yellow }
}

# warn: domain in yaml need set manually
Write-Output "Domain: $Domain" | Yellow
Write-Output "DomainAdminUser: $DomainAdminUser" | Yellow
Write-Output "DomainAdminPassword: $DomainAdminPassword" | Yellow
Write-Output "HciClusterName: $HciClusterName" | Yellow
Write-Output "HciServers: $HciServers" | Yellow
Write-Output "HciResourceGroupName: $HciResourceGroupName" | Yellow
Write-Output "WorkloadClusterName: $WorkloadClusterName" | Yellow

function HciRunAll([scriptblock]$block) {
    Invoke-Command -ComputerName $HciServers -ScriptBlock {
        param([string]$RBlock, $args)        
        function Green {
            process { Write-Host $_ -ForegroundColor Green }
        }
        Write-Output " ===== $env:COMPUTERNAME start ===== " | Green
        [Scriptblock]::Create($RBlock).Invoke()
        Write-Output " ===== $env:COMPUTERNAME end ===== " | Green
    } -ArgumentList $block.ToString()
}

function HciRunOne([scriptblock]$block) {
    Invoke-Command -ComputerName $HciServers[0] -ScriptBlock {
        param([string]$RBlock)        
        function Green {
            process { Write-Host $_ -ForegroundColor Green }
        }
        Write-Output " ===== $env:COMPUTERNAME start ===== " | Green
        [Scriptblock]::Create($RBlock).Invoke()
        Write-Output " ===== $env:COMPUTERNAME end ===== " | Green
    } -ArgumentList $block.ToString()
}

# HciRunAll {
#     Write-Output "aaa"
# }

function EnableCredSSP {
    # Enable CredSSP
    # Temporarily enable CredSSP delegation to avoid double-hop issue
    foreach ($Server in $HciServers){
        Enable-WSManCredSSP -Role "Client" -DelegateComputer $Server -Force
    }
    Invoke-Command -ComputerName $HciServers -ScriptBlock { Enable-WSManCredSSP Server -Force }
}

function DisableCredSSP {
    # Disable CredSSP
    Disable-WSManCredSSP -Role Client
    Invoke-Command -ComputerName $HciServers -ScriptBlock { Disable-WSManCredSSP Server }
}

# add kubectl alias
If (Test-Path Alias:k) { Remove-Item Alias:k }
Set-Alias -Name k -Value kubectl
function kg {
    kubectl get $args
}
function kd {
    kubectl describe $args
}
