function Get-V254256 {
    [CmdletBinding()]
    param()

    $EnabledUsers = Get-LocalUser | 
                    Where-Object Enabled -eq $true | 
                    Select-Object Name, Enabled, LastLogon, SID

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

    $35DaysOld = (Get-Date).AddDays(-35)
    $InactiveUsers = $EnabledUsers | Where-Object {
        $null -eq $_.LastLogon -or
        $_.LastLogon -lt $35DaysOld
    }

    $pwsh_cmd = @"
NOTE: Excluded accounts are the following per the Check Text:
- Built-in administrator account (Renamed, SID ending in 500)
- Built-in guest account (Renamed, Disabled, SID ending in 501)
- Application accounts:
    - DefaultAccount (SID ending in 503)
    - WDAGUtilityAccount  (SID ending in 504)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
    Where-Object Enabled -eq $true | 
    Select-Object Name, Enabled, LastLogon

Output
‾‾‾‾‾‾‾
$(Get-LocalUser |
    Where-Object Enabled -eq $true | 
    Select-Object Name, Enabled, LastLogon | 
    Out-String)
"@

    if ($EnabledUsers.Count -eq 0){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
There are no applicable enabled local accounts to evaluate.

$pwsh_cmd
"@
        }

    }
    
    if ($InactiveUsers.Count -gt 0){
        return [ordered]@{
            Status = 'open'
            Comment = @"
Review the identified account(s) on $($env:COMPUTERNAME) and determine whether they are required. 
If the account is required, validate the account usage and supporting documentation with the ISSO.

$pwsh_cmd
"@
        }
    }
    return [ordered]@{
        Status  = 'not_a_finding'
        Comment = @"
All applicable enabled local accounts have logged on within the last 35 days.

Validate the account usage and supporting documentation with the ISSO.

$pwsh_cmd
"@
    }
}