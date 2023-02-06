# Set these values for your needs.
$newvmlist = Get-Content C:\Users\localadmin\Documents\Scripts\VMWare\wks.txt


# Values for new vm
$VMHost = "ESXI_HOST"
$datastore = "DATASTORE"

# Which VM(s) would you like to clone? Copy from?
$template = "Template_VM"

# Get existing vms to clone based on template name.
$sourceVM = Get-VM $template

foreach ($newvm in $newvmlist) {
    New-VM -Name $newVM -VM $sourceVM -VMHost $VMHost -Datastore $datastore -DiskStorageFormat Thin -RunAsync
}