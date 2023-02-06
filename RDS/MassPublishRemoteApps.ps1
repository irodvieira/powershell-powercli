$list = Get-ChildItem D:\VHD\FOLDER
$folderName = "FOLDER_NAME"


foreach ($i in $list) {
    New-RDRemoteApp -CollectionName QuickSessionCollection -Alias $i.BaseName -DisplayName $i.BaseName -FilePath C:\Windows\system32\mstsc.exe -FileVirtualPath "%SYSTEMDRIVE%\Windows\system32\mstsc.exe" -ShowInWebAccess:$true -FolderName $folderName -RequiredCommandLine $i.FullName -CommandLineSetting Require
    }