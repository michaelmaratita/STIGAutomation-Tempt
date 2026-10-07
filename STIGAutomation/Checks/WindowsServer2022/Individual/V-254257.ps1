function Get-V254257 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $Users = Get-CimInstance -Class Win32_UserAccount `
        -Filter "PasswordRequired=False `
                and `
                LocalAccount=True `
                and `
                Disabled=False" `
        -Verbose:$false |
        Select-Object Name, 
                      SID, 
                      PasswordRequired, 
                      PasswordExpires, 
                      Disabled, 
                      LocalAccount

    # Filter out DefaultAccount and Guest Account
    $Users = $Users | Where-Object {

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$'
    }

    if ($Users.Count -eq 0){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open`
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $(
                                                    $Users | 
                                                    Format-List Name, 
                                                                LocalAccount, 
                                                                PasswordRequired, 
                                                                PasswordExpires, 
                                                                Disabled, 
                                                                SID | 
                                                    Out-String
                                                    )

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}