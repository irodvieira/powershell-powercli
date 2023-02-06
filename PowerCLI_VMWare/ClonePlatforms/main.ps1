. C:\Users\localadmin\Documents\Scripts\dci-powershell\PowerCLI\ClonePlatforms\Get-FolderPath.ps1
. C:\Users\localadmin\Documents\Scripts\dci-powershell\PowerCLI\ClonePlatforms\Generate-VMFolder.ps1

$settings = Import-Csv -Delimiter "," -Path "C:\Users\localadmin\Documents\Scripts\dci-powershell\PowerCLI\ClonePlatforms\settings.csv"

$template = $settings.template
$destination = $settings.destination

#Generate-VMFolder -FolderName $folderName

$newFolderID = (Get-Folder -Name $destination).Id

<#
$vds = Get-VDSwitch "VMware HCIA Distributed Switch"

$refPortGroup = Get-VDPortgroup -Name "Template_LAN"

If ($vds | Get-VirtualPortGroup $destination) {
    Write-Warning -Message "$destination Virtual Port Group already exists! Skipping this part."
    $vds | Get-VDPortgroup -Name $destination | Select name, numports, portbinding, vlanconfiguration
} else {
    New-VDPortgroup -Name $destination -ReferencePortgroup $refPortGroup.Name -VDSwitch $vds
    Write-Host "New portgroup $desination created. Now confirming settings" -ForegroundColor Cyan
    $vds | Get-VDPortgroup -Name $destination | Select name, numports, portbinding, vlanconfiguration
    Write-Host "Setting new distributed port groups vlanID to $vlanID"
    Set-VDVlanConfiguration -VDPortgroup (Get-VDPortGroup -Name $destination) -VlanId $vlanID -Confirm:$false
}

#>

$VMHost = "ESXI_HOST.dc.local"
$datastore = "COMPLETE_DATASTORE_NAME"

# COMMENT OUT NEXT LINE IF YOU WANT TO CLONE TEMPLATE WITH PFSENSE
# $sourceVMs = Get-VM $template*

# # COMMENT OUT NEXT LINE IF YOU WANT TO CLONE TEMPLATE WITHOUT PFSENSE
$sourceVMs = Get-VM $template* | Where-Object { ($_.Name -notlike "*FW*") }

foreach ($sourceVM in $sourceVMs) {
    $newVMName = $sourceVM.Name -replace $template,$destination
    New-VM -Name $newVMName -VM $sourceVM -VMHost $VMHost -Datastore $datastore -DiskStorageFormat Thin -RunAsync -Location (Get-Folder -Id $newFolderID) #-NetworkName $destination
}