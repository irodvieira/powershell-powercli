# This script is created for DCI teams internal use only to easly and automatically cerate RDP files for new Platforms and publish them.

Clear-Host

# Get new values from users.
# New IP will be used to create new RDP files.
$newIP = Read-Host "Enter your new PFSense IP"

# This will be used to create new Folder on RDP, RDS and RDP files.
$newPTName = Read-Host "Enter your new PT Name (Ex: Mini-INT8)"

# Use this template folder to copy RDP files from! If this path doesn't exist, the script can't work!
$rdps = Get-ChildItem "D:\VHD\Template\"


# Validate if the template folder is there. If not, exit script.
If ( ! ($rdps) ) {
    Write-Error -Message "D:\VHD\Template folder doesn't exist! Script will stop now."
    Write-Error -Message "Without the $rdps folder and content, the scipt cannot continue!"
    Pause
    Exit
}

# Create a new folder in the RDS server for the new platform
Write-Output "Creating the new folder for $newPTName under D:\VHD"
$newPath = "D:\VHD\" + $newPTName

If (! (Get-Item $newPath -ErrorAction SilentlyContinue) ) {
    New-Item -Path $newPath -ItemType Directory
    Write-Output "$newPath has been created."
}
# If the path exists already, stop the operation as it can modify existing RDP files
else {
    Write-Warning "$newPath already exists!"
    Write-Warning "Please make sure $newPath doesn't exist before you run this script!"
    Write-Warning "Stopping Now!"
    Pause
    Exit
}

# Get each RDP file from the template, copy it to the new PATH and set the new IP for new PT.
foreach ($rdp in $rdps) {
    $newFullPath = $rdp.FullName.Replace("Template", $newPTName)
    Copy-Item -Path $rdp.FullName -Destination $newFullPath
    $newContent = (Get-Content $rdp.FullName).Replace("0.0.0.0", $newIP)
    Set-Content -Value $newContent -Path $newFullPath
    Write-Output "$newFullPath has been updated with the new $newIP IP"
}

# Ask user if they want to publish the new RDP files into RDS Web ?
$confirmation = Read-Host "Would you like to publish new Platform RDP Entries in RDS as well? (y)es / (n)o"
if ($confirmation -eq 'y') {
    Write-Output "Creating the new RDS entries..."
    Pause
    $apps = Get-ChildItem $newPath
	write-host $newPath
    ForEach ($i in $apps) {
        New-RDRemoteApp -CollectionName QuickSessionCollection -Alias $i.BaseName -DisplayName $i.BaseName -FilePath C:\Windows\system32\mstsc.exe -FileVirtualPath "%SYSTEMDRIVE%\Windows\system32\mstsc.exe" -ShowInWebAccess:$true -FolderName $newPTName -RequiredCommandLine $i.FullName -CommandLineSetting Require
    }
}
else {
    Write-Output "ALL DONE!"
    Pause
}