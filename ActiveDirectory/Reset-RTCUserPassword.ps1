$users = "user1","user2","user3","user4","user5","user6","user_admin1","user_admin2"

$password = ConvertTo-SecureString -AsPlainText "PASSWORD" -Force
foreach ($user in $users) { 
	$dn = (Get-ADUser $user).DistinguishedName
	Set-AdAccountPassword -Identity $dn -Reset -NewPassword $password -Confirm:$false
	Write-Host "$user password has been resetted!"
}

pause