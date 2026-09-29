function Get-V254241 {
    [CmdletBinding()]
    param()

    $backup_admins = Get-LocalGroupMember `
        -Group "Backup Operators"

    if ($null -eq $backup_admins){
        $Status = 'not_applicable'
        $Comment = 'Validated Backup Operators does not have any users assigned.'
    }
    else {
        $Status = 'not_reviewed'
        $Comment = 'Validated Backup Operators has users assigned.'
    }
    return [ordered]@{
        Status = $Status
        Comment = @"
$Comment

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalGroupMember ``
    -Group 'Backup Operators'
    
Output
‾‾‾‾‾‾
$($backup_admins | Out-String)
"@
    }
}