function Get-V254238 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $user_info = Get-ADUser `
                    -Identity $env:USERNAME |
                    Select-Object `
                        GivenName, 
                        Surname

    $GivenName = $user_info.GivenName
    $SurName = $user_info.Surname
    
    $ExampleUser = Get-ADUser `
                    -Filter "GivenName -eq '$($GivenName)' -and Surname -eq '$($SurName)'" `
                    -Properties MemberOf |
                    Select-Object GivenName,
                                  Surname,
                                  SamAccountName,
                                  UserPrincipalName,
                                  SID,
                                  MemberOf

    $Output = $ExampleUser | Format-List | Out-String

    $PowerShellCommand = $Comment.PowerShellCommand `
                          -replace "{GIVEN}", $GivenName `
                          -replace "{SURNAME}", $SurName `
                          -replace "{OUTPUT}", $Output

    if ($ExampleUser.Count -ge 2){
        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace "{GIVEN}", $GivenName `
                        -replace "{SURNAME}", $SurName `
                        -replace "{COMPUTERNAME}", $env:COMPUTERNAME
    } else {
        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{GIVEN}', $user_info.GivenName `
                        -replace '{SURNAME}', $user_info.Surname `
                        -replace '{USERDNSDOMAIN}', $env:USERDNSDOMAIN
    }
    
    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}