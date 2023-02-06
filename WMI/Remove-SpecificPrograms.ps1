$apps = Get-WmiObject -Class Win32_Product | where {$_.Vendor -like "Specific*"}
foreach ($app in $apps) {
    $app.Uninstall()
}