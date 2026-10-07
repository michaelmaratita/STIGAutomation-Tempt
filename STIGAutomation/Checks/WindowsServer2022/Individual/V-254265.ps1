function Get-V254265 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $Firewall = @{
        Trellix  = Get-Service mfefire -ErrorAction SilentlyContinue
        Defender = Get-Service mpssvc -ErrorAction SilentlyContinue
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{TRELLIXFW}', $(
                                                      Get-Service mfefire `
                                                      -ErrorAction SilentlyContinue | 
                                                      Format-List | 
                                                      Out-String
                                                    ) `
                            -replace '{DEFENDER}', $(
                                                      Get-Service mpssvc `
                                                      -ErrorAction SilentlyContinue | 
                                                      Format-List | 
                                                      Out-String
                                                    )

    if (
        {$Firewall.Trellix.Status -eq 'Running' `
        -or `
        $Firewall.Defender.Status -eq 'Running'}
        ){

        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

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