function Get-V254282 {
    [CmdletBinding()]
    param()

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
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
No unresolved SIDs were identified in the User Rights Assignment section of the effective Group Policy.

GPResult:
$($script:STIGAutomation.GPResultPath)
"@
        }
    }

    return [ordered]@{
        Status = 'open'
        Comment = @"
The following unresolved SIDs were identified in the User Rights Assignment section of the effective Group Policy:

$($UnresolvedSIDs -join "`r`n")

Review each unresolved SID to determine whether it belongs to a currently valid account or group. If an unresolved SID is not for a currently valid account or group, this is a finding.

GPResult:
$($script:STIGAutomation.GPResultPath)
"@
    }
}