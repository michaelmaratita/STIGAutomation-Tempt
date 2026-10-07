function Get-V254256 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $EnabledUsers = Get-LocalUser | 
                    Where-Object Enabled -eq $true | 
                    Select-Object Name, Enabled, LastLogon, SID

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

    $35DaysOld = (Get-Date).AddDays(-35)
    $InactiveUsers = $EnabledUsers | Where-Object {
        $null -eq $_.LastLogon -or
        $_.LastLogon -lt $35DaysOld
    }

    if ($EnabledUsers.Count -eq 0){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding.CountEqZero `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } elseif ($InactiveUsers.Count -gt 0){

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding.CountGtZero
        
    }

    $CommentText = $CommentText + $Comment.Note + `
                                    $Comment.PowerShellCommand `
                                       -replace '{OUTPUT}', $(
                                                            Get-LocalUser | 
                                                            Where-Object Enabled -eq `$true | 
                                                            Select-Object Name, 
                                                                        Enabled, 
                                                                        LastLogon |
                                                            Out-String
                                                            )

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText
    }
}