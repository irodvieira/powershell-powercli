$reportName = "C:\CPUandRAMUsageReport_DoNotDelete.csv"
$Allservers = "Server1","Server2"

$Output = @()
 
ForEach ($Server in $Allservers) 
{
    $Processor = $null
    $Memory = $null
    $RoundMemory = $null
    $Object = $null
    $Server = $Server.trim()
	$date = $null
 
    Try {
        # Processor Check
        $Processor = (Get-WmiObject -ComputerName $Server -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
 
        # Memory Check

        $Memory = Get-WmiObject -ComputerName $Server -Class win32_operatingsystem -ErrorAction Stop
        $Memory = ((($Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory)*100)/ $Memory.TotalVisibleMemorySize)
        $RoundMemory = [math]::Round($Memory, 2)
		
		$date = get-date -Format 'g'
		
        $Object = New-Object PSCustomObject
        $Object | Add-Member -MemberType NoteProperty -Name "Server name" -Value $Server
        $Object | Add-Member -MemberType NoteProperty -Name "CPU %" -Value $Processor
        $Object | Add-Member -MemberType NoteProperty -Name "Memory %" -Value $RoundMemory
		$Object | Add-Member -MemberType NoteProperty -Name "Date" -Value $date
 
        $Object
        $Output += $Object
    }
    Catch {
        Write-Host "There are errors ($Server): "$_.Exception.Message
        Continue
    }
}
 
#Exporting the result to an excel CSV file.
If ($Output) 
{ 
   
    $Output | Export-Csv -Path $reportName -NoTypeInformation -Force -Append

    }