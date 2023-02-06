$rtcAccounts = "user1","user2","user3","user4","user5","user6","user_admin1","user_admin2"

foreach ($rtcAccount in $rtcAccounts) {
    If ((Get-ADUser -Identity $rtcAccount -Properties LockedOut).LockedOut -eq $True){
        Unlock-ADAccount -Identity $rtcAccount -Confirm:$False
        Write-Output "$rtcAccount is unlocked now!"
    }

}