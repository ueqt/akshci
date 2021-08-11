# add required modules (parsing required modules from kva.psd - it also requires certain version of modules)
# JaromirK note: it would be great if this dependency was downloaded automagically or if you would be ok with latest version (or some minimumversion)
$item=Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules\Kva" -Recurse | Where-Object name -eq kva.psd1
$RequiredModules=(Import-LocalizedData -BaseDirectory $item.Directory -FileName $item.Name).RequiredModules
foreach ($RequiredModule in $RequiredModules){
    if (!(Get-InstalledModule -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.RequiredVersion -ErrorAction Ignore)){
        Install-Module -Name $RequiredModule.ModuleName -RequiredVersion $RequiredModule.RequiredVersion -Force
    }
}