function Get-V254268 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $EnabledUsers = Get-LocalUser | 
                        Where-Object {
                            ($_.Enabled -eq $true) -and
                            ($null -eq $_.AccountExpires)
                        } | 
                        Select-Object Name, Enabled, AccountExpires, SID

    # Filter out BuiltIn Accounts
    $EnabledUsers = $EnabledUsers | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$' -and

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\WDAGUtilityAccount
        $_.SID -notmatch '-504$'
    }

    if ($EnabledUsers.Count -eq 0){

        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($EnabledUsers | Out-String)
    
    return [ordered]@{
        Status = $Status
        Comment = $CommentText + $Comment.Note + $PowerShellCommand
    }
}