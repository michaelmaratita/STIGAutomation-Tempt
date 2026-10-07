function Get-V254442 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $root_certs = Get-ChildItem `
        -Path Cert:Localmachine\root | 
        Where-Object Subject -Like "*DoD*"

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($root_certs | 
                                                    Format-List Subject, 
                                                                NotAfter | 
                                                    Out-String
                                                )

    if (($root_certs).Count -gt 0){
        
        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }
    
    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}