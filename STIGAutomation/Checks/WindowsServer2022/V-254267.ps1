function Get-V254267 {
    [CmdletBinding()]
    param()

    $local_users = Get-LocalUser | Select-Object Name, Enabled, SID

    $local_users = $local_users | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$' -and

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\WDAGUtilityAccount
        $_.SID -notmatch '-504$'
    }

    $non_default_users = @()
    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | Select-Object Name, Enabled

Output
‾‾‾‾‾‾
$(Get-LocalUser | Select-Object Name, Enabled | Out-String)
"@

    foreach ($user in $local_users.Name){
        $non_default_users += $user
    }

    if ($non_default_users -gt 0){
        return [ordered]@{
            Status = 'open'
            Comment = @"
A local user that is not a default user account has been found on $env:ComputerName.
Please validate the status of the user(s) and delete if not required.

Non-Default User Accounts
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($non_default_users | Out-String)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$pwsh_cmd
"@
            }
    }

    return [ordered]@{
        Status = 'not_applicable'
        Comment = @"
Validated there are no temporary accounts utilized on $env:ComputerName.

$pwsh_cmd
"@
    }
}