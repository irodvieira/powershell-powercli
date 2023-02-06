function Set-AutomaticMACVMs {
   param (
      [Parameter(Mandatory = $true,
         ValueFromPipelineByPropertyName = $true)] 
      [ValidateNotNullOrEmpty()] 
      [Alias("v")] 
      [string[]]$VMName
   )
   $vms = Get-VM -Name $VMName
   foreach ($vm in $vms) {
      $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
      foreach ($vnic in Get-NetworkAdapter -VM $vm) {
         $nic = $vm.ExtensionData.Config.Hardware.Device | where { $_ -is [VMware.Vim.VirtualEthernetCard] -and $_.DeviceInfo.Label -eq $vnic.Name }
         $nic.AddressType = 'Generated'
         $nic.MacAddress = $null
         $devChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
         $devChange.Operation = 'edit'
         $devChange.Device += $nic
         $spec.DeviceChange += $devChange
      }
      $vm.ExtensionData.ReconfigVM($spec)
   }
}