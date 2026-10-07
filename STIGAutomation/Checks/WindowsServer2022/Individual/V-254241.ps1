function Get-V254241 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $backup_admins = Get-LocalGroupMember `
                        -Group "Backup Operators"

    $Output = $backup_admins | Out-String

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $Output

    if ($null -eq $backup_admins){
        
        $Status = 'not_applicable'

    } else {

        $Status = 'open'
        
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}