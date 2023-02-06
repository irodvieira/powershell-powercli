do {
    Write-Output "1 - VCenter 1"
    Write-Output "2 - VCenter 2"
    $site = Read-Host "Select a VCenter site you would like to connect"

        switch ($site) {
            '1' {Connect-VIServer -Server VCENTER_1 -Credential (get-credential -UserName vsphere.local\administrator -Message vsphere)}
            '2' {Connect-VIServer -Server VCENTER_2,VCENTER_3 -Credential (get-credential -UserName vsphere.local\administrator -Message vsphere)}
            default {"Invalid entry"}
        }
         
} while (($site -ne '1') -and ($site -ne '2'))