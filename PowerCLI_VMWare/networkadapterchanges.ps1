$vms = Get-VM VM_NAME | Where-Object -FilterScript {$_.PowerState -eq "PoweredOff"}
$network_name = "VM Network"

# Foreach VM in the vms variable, remove and add a new network card with the same type of vmnic.
# If the vm has 3 nics, the script will remove 3 and add 3 new of same type.

foreach ($vm in $vms) {  
    $vmnics = $vm | Get-NetworkAdapter 
    foreach ($vmnic in $vmnics) { 
        If ($vmnic.Type -eq "Vmxnet3") {
            Remove-NetworkAdapter -NetworkAdapter $vmnic -Confirm:$false
            New-NetworkAdapter -VM $vm -StartConnected -Type Vmxnet3 -NetworkName $network_name -Confirm:$false
        }
        elseif ($vmnic.Type -eq "e1000e") {            
            Remove-NetworkAdapter -NetworkAdapter $vmnic -Confirm:$false
            New-NetworkAdapter -VM $vm -StartConnected -Type e1000e -NetworkName $network_name -Confirm:$false
        }
        elseif ($vmnic.Type -eq "e1000") {
            Remove-NetworkAdapter -NetworkAdapter $vmnic -Confirm:$false
            New-NetworkAdapter -VM $vm -StartConnected -Type e1000 -NetworkName $network_name -Confirm:$false
        }
        else {
            write-error -message "The network card type for $vm is different than expected! Please, check $vm"
        }
    }
}