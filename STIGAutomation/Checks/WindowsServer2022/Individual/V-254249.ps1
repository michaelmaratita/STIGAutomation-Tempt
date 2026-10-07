function Get-V254249 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $ThreatPrevent= Get-Process mfetp `
                    -ErrorAction SilentlyContinue | 
                    Select-Object Product, 
                                  ProductVersion, 
                                  ProcessName, 
                                  Id

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $(Get-Process mfetp `
                                                    -ErrorAction SilentlyContinue | 
                                                    Select-Object Product, 
                                                                  ProductVersion, 
                                                                  ProcessName, 
                                                                  Id | 
                                                    Format-List | 
                                                    Out-String
                                                )

    if ($ThreatPrevent){

        $Status  = 'not_a_finding'
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