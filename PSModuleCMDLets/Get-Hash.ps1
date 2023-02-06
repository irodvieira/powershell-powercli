Function Get-Hash($Path){
    
    $Stream = New-Object System.IO.FileStream($Path,[System.IO.FileMode]::Open) 
    
    $StringBuilder = New-Object System.Text.StringBuilder 
    $HashCreate = [System.Security.Cryptography.HashAlgorithm]::Create("SHA256").ComputeHash($Stream)
    $HashCreate | Foreach {
        $StringBuilder.Append($_.ToString("x2")) | Out-Null
    }
    $Stream.Close() 
    $StringBuilder.ToString() 
}