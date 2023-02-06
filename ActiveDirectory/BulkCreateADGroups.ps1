#Requires -Modules ActiveDirectory

Import-Module ActiveDirectory

$GlobalGroupPath = "OU=Global Security Groups,OU=OU Groups,DC=DC,DC=local"
$DomainLocalGroupPath = "OU=Domain Local Security Groups,OU=OU Groups,DC=DC,DC=local"

$GlobalGroups = Get-ADGroup -SearchBase $GlobalGroupPath -Properties * -Filter *
$GlobalGroupNames = ($GlobalGroups | Select Name).Name

foreach ($GlobalGroup in $GlobalGroupNames) {
    $newDomainLocalGroupName = $GlobalGroup.replace("G_","DL_")
    New-ADGroup -Name $newDomainLocalGroupName -GroupCategory Security -GroupScope DomainLocal -DisplayName $newDomainLocalGroupName -Path $DomainLocalGroupPath
    Add-ADGroupMember -Identity $newDomainLocalGroupName -Members $GlobalGroup
}