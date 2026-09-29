function Get-V254238 {
    [CmdletBinding()]
    param()

    $user_info = Get-ADUser -Identity $env:USERNAME | Select-Object GivenName, Surname
    $ExampleUser = Get-ADUser `
    -Filter "GivenName -eq '$($user_info.GivenName)' -and Surname -eq '$($user_info.Surname)'" `
    -Properties MemberOf |
    Select-Object GivenName,
                  Surname,
                  SamAccountName,
                  UserPrincipalName,
                  SID,
                  MemberOf

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADUser `
        -Filter "GivenName -eq '$($user_info.GivenName)' -and Surname -eq '$($user_info.GivenName)'" `
        -Properties MemberOf | 
        Select-Object GivenName, 
                      SurName, 
                      SamAccountName, 
                      UserPrincipalName,
                      SID, 
                      MemberOf

Output
‾‾‾‾‾‾‾
$($ExampleUser | Out-String)
"@

    if ($ExampleUser.Count -ge 2){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated there are separate accounts for $($user_info.GivenName) $($user_info.SurName). 
SA accounts are specifically used for System Administration tasks on $env:ComputerName. Normal user accounts (non-SA)
do not have login/admin access to Windows Servers.

$pwsh_cmd
"@
        }
    }


    return [ordered]@{
        Status = 'open'
        Comment = @"
Please validate the status for this STIG check.

$($user_info.GivenName) $($user_info.SurName) has $($ExampleUser.Count) accounts
associated with the $env:USERDNSDOMAIN.

$pwsh_cmd
"@
    }

}