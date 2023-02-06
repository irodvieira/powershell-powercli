function Get-StaticMACVMs {
    param (
        [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("s")] 
        [string[]]$vmName
    )
    Get-VM $vmName| Where-Object {($_ | Get-NetworkAdapter).ExtensionData.AddressType -eq "manual"}
}

#Get-VM | Where-Object {($_ | Get-NetworkAdapter).ExtensionData.AddressType -eq "manual"}

# List VM Name and Mac Addresses
# Get-VM | Where-Object {($_ | Get-NetworkAdapter).ExtensionData.AddressType -eq "manual"} | Select-Object -Property Name, PowerState, @{"Name"="MAC";"Expression"={($_ | Get-NetworkAdapter).MacAddress}}