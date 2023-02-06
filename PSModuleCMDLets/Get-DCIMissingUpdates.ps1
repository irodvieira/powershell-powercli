function Get-DCIMissingUpdates {

Param(
    [parameter(mandatory)]
    [string]$CabPath,

    [parameter(mandatory)]
    [string]$ReportPath
)




$DataFolder = "$env:ProgramData\WSUS Offline Catalog"
$CabPath = "$DataFolder\wsusscn2.cab"

Write-Verbose "Creating Windows Update session"
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateServiceManager  = New-Object -ComObject Microsoft.Update.ServiceManager 

$UpdateService = $UpdateServiceManager.AddScanPackageService("Offline Sync Service", $CabPath, 1) 

Write-Verbose "Creating Windows Update Searcher"
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()  
$UpdateSearcher.ServerSelection = 3
$UpdateSearcher.ServiceID = $UpdateService.ServiceID.ToString()
 
Write-Verbose "Searching for missing updates"
$SearchResult = $UpdateSearcher.Search("IsInstalled=0")

$Updates = $SearchResult.Updates

$UpdateSummary = [PSCustomObject]@{

    ComputerName = $env:COMPUTERNAME    
    MissingUpdatesCount = $Updates.Count
    Vulnerabilities = $Updates | Foreach {
        $_.CveIDs
    }
    MissingUpdates = $Updates | Select Title, MsrcSeverity, @{Name="KBArticleIDs";Expression={$_.KBArticleIDs}}
}
$UpdateSummary | Export-CSV -Path ($ReportPath + "\Update_Report.csv")
Return $UpdateSummary

}