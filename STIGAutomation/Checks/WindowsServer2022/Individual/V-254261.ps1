function Get-V254261 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )
    
    $certs = Test-CertificateInstallationFiles

    if ($certs.IsFinding){

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {
        
        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                        
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                           -replace '{OUTPUT}', $($certs.Files -join "`n")

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}