function Get-ReservedResourcesVMs {
    param (
        [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("v")] 
        [string[]]$VMName
    )
    
    Get-VM $VMName | Get-VMResourceConfiguration | Where-Object {($_.MemReservationMB -ne "0") -and ($_.CpuReservationMhz -ne "0")} | Select-Object VM,MemReservationMB,CpuReservationMhz
}