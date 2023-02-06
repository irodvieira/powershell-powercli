$AllServers = "Server1","Server2"
$allprocess = "PROCESS_NAME1","PROCESS_NAME2"
$reportName = "C:\MemoryUsagebyProcessReport_DoNotDelete.csv"

$Output = @()

foreach ($server in $AllServers) {
    $procname = $null
    $machineName = $null
    $procID = $null
    $procmem = $null
	$date = $null

    try {
        $prcs = Get-Process -ComputerName $server -Name $allprocess -ErrorAction SilentlyContinue
    }

    Catch {
        Write-Host "There are errors ($Server): "$_.Exception.Message
        Continue
    }

    foreach ($p in $prcs){

    $procname = $p.Name
    $machineName = $p.MachineName
    $procID = $p.Id
    $date = get-date -Format 'g'
    $procmem = ($p | Measure-Object WorkingSet64 -Sum).Sum / 1MB

    $Object = New-Object PSCustomObject
    $Object | Add-Member -MemberType NoteProperty -Name "Machine Name" -Value $machineName
    $Object | Add-Member -MemberType NoteProperty -Name "Process Name" -Value $procname
    $Object | Add-Member -MemberType NoteProperty -Name "Process ID" -Value $procID
    $Object | Add-Member -MemberType NoteProperty -Name "Memory in MB" -Value $procmem
    $Object | Add-Member -MemberType NoteProperty -Name "Date" -Value $date

    $Object
    $Output += $Object
    }
    
}

$Output | export-csv -Path $reportName -Append -NotypeInformation -Force