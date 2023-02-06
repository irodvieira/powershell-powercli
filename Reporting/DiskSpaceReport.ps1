$reportName = "C:\DiskSpaceReport_DoNotDelete.csv"

$results = "Server1","Server2" |
foreach {Get-WmiObject Win32_LogicalDisk -ComputerName $_}

$results | Select SystemName, DeviceID, volumename, @{Name="Free Space"; Expression={[math]::round($($_.FreeSpace/1GB), 2)}},
@{Name="Total Size"; Expression={[math]::round($($_.size/1GB), 2)}},
@{Name="% Free"; Expression={[math]::round($($_.freespace/$_.size), 2)*100}},
@{Name="Date"; Expression={$(Get-Date -Format 'g')}} | Export-Csv -Path $reportName -NoTypeInformation -Append