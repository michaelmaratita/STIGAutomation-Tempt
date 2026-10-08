function Get-V225236 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $LegitimateProcesses = @(
        'SlMgrs'
        'fcags'
        'InstallRootService'
        'SMSvcHost'
        'WmiPrvSE'
        'wsmprovhost'
        'powershell'
        'mmc'
        'dllhost'
        'NetBanner'
    )

    $Processes = Get-Process | 
                ForEach-Object {
                    if ($_.Modules.ModuleName -contains 'mscoree.dll') {
                        $_ | Select-Object Name, Id, Path
                    }
                }

    $NeedsReview = $Processes | Where-Object {
        $_.Name -notin $LegitimateProcesses
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($Processes | 
                                                   Format-List | 
                                                   Out-String
                                                )
        

    if ($NeedsReview.Count -eq 0){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                        -replace '{NEEDSREVIEW}', $($NeedsReview | Out-String)
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }


}