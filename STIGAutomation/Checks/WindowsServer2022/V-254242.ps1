function Get-V254242 {
    [CmdletBinding()]
    param()

    $default_pw_policy = Get-ADDefaultDomainPasswordPolicy
    

    if ($default_pw_policy.MinPasswordLength -ge 14){
        return [ordered]@{
        Status = 'not_a_finding'
        Comment = @"
DHA has a default password policy for manually managed application/service accounts that
require at least $($default_pw_policy.MinPasswordLength) characters in length and meet complexity rules.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADDefaultDomainPasswordPolicy

Output
‾‾‾‾‾‾‾
$default_pw_policy
"@
        }
    }

    return [ordered]@{
        Status = 'open'
        Comment = @"
The domain does not have a default password policy that requires 14 characters in length.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADDefaultDomainPasswordPolicy

Output
‾‾‾‾‾‾‾ 
$($default_pw_policy | Out-String)
"@
    }
}