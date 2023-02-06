$template = "PREFIX-*"
$newNetworkName = "PREFIX"

# Exclude FW
$VMs = Get-VM $template | Where-Object { ($_.Name -notlike "*FW*") }

foreach ($vm in $vms){
    Get-VM $vm | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newNetworkName -Confirm:$false
}