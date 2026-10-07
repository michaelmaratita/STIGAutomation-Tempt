function Get-V254443 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $interoperability_certs = Get-ChildItem `
        -Path Cert:Localmachine\disallowed | 
        Where-Object {
            $_.Issuer -Like "*DoD Interoperability*" `
            -and `
            $_.Subject -Like "*DoD*"
        }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($interoperability_certs | 
                                                    Format-List Issuer, 
                                                                Subject, 
                                                                NotAfter | 
                                                    Out-String
                                                )

    if (($interoperability_certs).Count -gt 0){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}