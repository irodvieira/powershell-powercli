# While connected to vcenter, find all vms with this IP address;

$IP = "192.168.0.100"
Get-VM | Where-Object -FilterScript { $_.Guest.Nics.IPAddress -contains $IP }