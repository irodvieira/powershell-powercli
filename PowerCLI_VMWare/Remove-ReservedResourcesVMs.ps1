function Remove-ReservedResourcesVMs {
    param (
        [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("v")] 
        [string[]]$VMName
    )
    Get-VM $VMName | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemReservationMB 0 -CpuReservationMhz 0
    Get-VM $VMName | Get-VMResourceConfiguration | Select-Object VM,MemReservationMB,CpuReservationMhz
}


# Following command returns if a series of VMs has CPU reservation enabled.
# Get-VM A_DEV21* | Get-VMResourceConfiguration | where {$_.CpuReservationMhz -ne "0"}
# Get-VM A_DEV22* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemReservationMB 0 -CpuReservationMhz 0