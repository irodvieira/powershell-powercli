# get-uuid.ps1
#
# Takes either a VMHost or VM object from the pipeline, returns the corresponding UUID.
Begin {
    $VMHost_UUID = @{
        Name = "VMHost_UUID"
        Expression = { $_.Summary.Hardware.Uuid }
    }
    $VM_UUID = @{
        Name = "VM_UUID"
        Expression = { $_.Config.Uuid }
    }
}

Process {
    $InputTypeName = $_.GetType().Name
    if ( $InputTypeName -eq "VMHostImpl" ) {
        $_ | Get-View | Select-Object $VMHost_UUID
    } elseif ( $InputTypeName -eq "VirtualMachineImpl" ) {
        $_ | get-view | Select-Object $VM_UUID
    } else {
        Write-Host "`nPlease pass this script either a VMHost or VM object on the pipeline.`n"
    }
}