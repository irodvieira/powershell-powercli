# Set these values for your needs.

# Values for new vm
$VMHost = "ESXI_HOST"
$datastore = "DATASTORE_LUN"

# Which VM(s) would you like to clone? Copy from?
$template = "TEMPLATE_VMS-*"

# If you want the vms to be in a specific folder, just type the folder name.
$VMFolderName = "NEW_FOLDER"

# Get existing vms to clone based on template name.
$sourceVMs = Get-VM $template

foreach ($sourceVM in $sourceVMs) {
    # Change the new vm name based on original vm. Replace number 3 in vm name with number 2 in this example!
    $newVMName = $sourceVM.Name -replace "TEMPLATE_VMS","NEW_VMS"
    # Clone the vms. If you need to change the datastore or the host, make sure the values are ok.
    New-VM -Name $newVMName -VM $sourceVM -VMHost $VMHost -Datastore $datastore -DiskStorageFormat Thin -Location $VMFolderName -RunAsync
}

Get-VM -Location $VMFolderName