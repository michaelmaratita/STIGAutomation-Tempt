function Get-V254267 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $LocalUsers = Get-LocalUser | Select-Object Name, Enabled, SID

    $LocalUsers = $LocalUsers | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$' -and

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\WDAGUtilityAccount
        $_.SID -notmatch '-504$'
    }

    if ($LocalUsers.Count -gt 0){

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                        -replace '{NONDEFAULT}', $($LocalUsers | Out-String)

    } else {

        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable `
                    -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                    
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                           -replace '{OUTPUT}', $(
                                                    Get-LocalUser | 
                                                    Select-Object Name,
                                                                  Enabled |
                                                    Out-String
                                                )

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}