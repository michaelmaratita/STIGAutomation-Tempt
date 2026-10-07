function Get-V254284 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $(Confirm-SecureBootUEFI | Out-String)

    if (Confirm-SecureBootUEFI){

        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace  '{COMPUTERNAME}', $env:COMPUTERNAME `
                        -replace '{FIRMWARETYPE}', $env:firmware_type

    } else {

        $Status  = 'open'
        $CommentText = $Comment.Open `
                    -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}