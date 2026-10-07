function Get-V254282 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $UserRightsSection= Get-GpUserRightsAssignment

    $UnresolvedSIDs = [regex]::Matches(
        $UserRightsSection,
        '\*S-1-[0-9-]+'
    ) |
    ForEach-Object {
        $_.Value
    } |
    Sort-Object -Unique

    if ($UnresolvedSIDs.Count -eq 0) {

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{GPRESULTPATH}', $script:STIGAutomation.GPResultPath

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{UNRESOLVEDSIDS}', $($UnresolvedSIDs -join "`r`n") `
                        -replace '{GPRESULTPATH}', $script:STIGAutomation.GPResultPath

    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText 
    }
}