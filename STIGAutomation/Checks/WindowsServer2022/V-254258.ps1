function Get-V254258 {
    [CmdletBinding()]
    param()

    $Users = Get-CimInstance -Class Win32_UserAccount `
        -Filter "PasswordExpires=False `
                and `
                LocalAccount=True `
                and `
                Disabled=False" `
        -Verbose:$false |
        Select-Object Name, 
                      SID, 
                      PasswordRequired, 
                      PasswordExpires, 
                      Disabled, 
                      LocalAccount

    # Filter out DefaultAccount and Guest Account
    $Users = $Users | Where-Object {

        # Exclude the BuiltIn\DefaultAccount 
        $_.SID -notmatch '-503$' -and

        # Exclude the BuiltIn\Guest Account
        $_.SID -notmatch '-501$'
    }

    $pwsh_cmd = @"
NOTE: Excluded accounts are Guest and DefaultAccount per the Check Text.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-CimInstance -Class Win32_UserAccount ``
        -Filter "PasswordExpires=False ``
                and ``
                LocalAccount=True ``
                and ``
                Disabled=False" |
        Select-Object Name, 
                      SID, 
                      PasswordRequired, 
                      PasswordExpires, 
                      Disabled, 
                      LocalAccount
Output
‾‾‾‾‾‾‾
$($Users | Format-List Name, LocalAccount, PasswordRequired, PasswordExpires, Disabled, SID | Out-String)
"@

    if ($Users.Count -eq 0){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
There are no local accounts that are Enabled and Password never expires.

$pwsh_cmd
"@
        }

    }
    return [ordered]@{
        Status = 'open'
        Comment = @"
Please review the local accounts on $env:COMPUTERNAME using the list below. There is an account that has a password that does not expire.

$pwsh_cmd
"@
    }
}