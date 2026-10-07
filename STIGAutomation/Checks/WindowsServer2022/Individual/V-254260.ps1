function Get-V254260 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )
    
    $AllowedShares = @(
        'ADMIN$'
        'C$'
        'D$'
        'IPC$'
    )

    $Shares = @(Get-SmbShare)

    # Identify non-system-created shares
    $NonSystemShares = @(
        $Shares | Where-Object {
            $_.Name -notin $AllowedShares
        }
    )

    if ($NonSystemShares.Count -eq 0) {

        $Status = 'not_applicable'

        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        # Nonsystem-created shares exist and require permission validation
        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                        
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                          -replace '{OUTPUT}', $(
                                                Get-SmbShare | 
                                                Select-Object Name | 
                                                Out-String
                                                )

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}