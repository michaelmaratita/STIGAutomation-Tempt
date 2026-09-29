function Get-V254268 {
    [CmdletBinding()]
    param()

    $EnabledUsers = Get-LocalUser | 
                        Where-Object {
                            ($_.Enabled -eq $true) -and
                            ($null -eq $_.AccountExpires)
                        } | 
                        Select-Object Name, Enabled, AccountExpires, SID

    # Filter out BuiltIn Accounts
    $EnabledUsers = $EnabledUsers | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$' -and

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\WDAGUtilityAccount
        $_.SID -notmatch '-504$'
    }

    $pwsh_cmd = @"
NOTE: Excluding the following accounts as they are not designed for Emergency Access:
- Built-in administrator account (Renamed, SID ending in 500)
- Built-in guest account (Renamed, Disabled, SID ending in 501)
- Application accounts:
    - DefaultAccount (SID ending in 503)
    - WDAGUtilityAccount  (SID ending in 504)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
    Where-Object {
        ($_.Enabled -eq $true) -and
        ($null -eq $_.AccountExpires)
    } | 
    Select-Object Name, Enabled, AccountExpires

Output
‾‾‾‾‾‾
$($EnabledUsers | Out-String)
"@
    if ($EnabledUsers.Count -eq 0){
        return [ordered]@{
        Status = 'not_applicable'
        Comment = @"
$env:COMPUTERNAME does not utilize Emergency Accounts. Only the built-in accounts exist on the server.

$pwsh_cmd
"@
        }
    }
    
    return [ordered]@{
        Status = 'open'
        Comment = @"
A local user that is not a default user account has been found on $env:ComputerName.
Please validate the status of the user(s) and delete if not required.

$pwsh_cmd
"@
    }
}