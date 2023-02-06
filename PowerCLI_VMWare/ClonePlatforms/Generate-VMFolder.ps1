function Generate-VMFolder {
    param(
        [parameter(valuefrompipeline = $true,
            position = 0,
            HelpMessage = "Enter a folder name")]
        [string]$FolderName,
        [switch]$ShowHidden = $false
    )
    
    $ErrorActionPreference = 'SilentlyContinue'
    Foreach ($Folder in $FolderName) {
        $Path = $folder
        $SplitPath = $Path.split('\')
     
        $SplitPath = $SplitPath | Where { $_ -ne "DATACENTER_NAME" }
        Clear-Variable Folderpath
        Clear-Variable Parent

        Foreach ($directory in $SplitPath) {
            If ($Folderpath -ne $Null) {
                IF ($(Get-folder $directory | Where Parentid -eq $($Folderpath.id)) -eq $Null) {
                    Write-Host "Generating new folder $directory" -ForegroundColor Green -BackgroundColor Black
                    Get-Folder -id $parent | New-Folder $directory
                }
                Else {
                    Write-host "Folder $directory Exists!" -ForegroundColor Magenta -BackgroundColor Black
                    $Folderpath = Get-Folder $directory | Where Parentid -eq $($Folderpath.id)
                    $Parent = $Folderpath.Id
                }
            }
            Else {
                $FolderExist = Get-folder -Name $directory
                IF ($FolderExist -eq $Null) {
                    Write-host "Generating new folder $directory" -ForegroundColor DarkGreen -BackgroundColor Black
                    New-folder -Name $directory -Location VM
                    $Folderpath = Get-folder $directory
                }
                Else {
                    Write-host "Folder $directory Exists!" -ForegroundColor DarkMagenta -BackgroundColor Black
                    $Folderpath = Get-Folder $directory
                    $Parent = $Folderpath.Id
                }
            }
        }
    }

}