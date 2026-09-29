function Get-V254239 {
    [CmdletBinding()]
    param()

    $localadmin = Get-LocalUser | 
        Where-Object SID -like "*500" |
        Select-Object Name, Enabled, PasswordRequired, PasswordLastSet

    $PolicySetting = Get-GpResultSetting -Setting 'Password Settings' -IncludeSubSettings

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | Where-Object SID -like "*500"

Output
‾‾‾‾‾‾‾
$($localadmin | Out-String)

$($PolicySetting.Comment)
"@
    if (-not $localadmin.Enabled){
        return [ordered]@{
            Status = 'not_applicable'
            Comment = @"
$($localadmin.Name) is not Enabled on $env:ComputerName.

$pwsh_cmd
"@
        }
    } 
    
    elseif ($localadmin.PasswordLastSet -gt (Get-Date).AddDays(-60)){
            return [ordered]@{
                Status = 'not_a_finding'
                Comment = @"
$($localadmin.Name) is Enabled and Password is less than 60 days old.

$pwsh_cmd
"@
            }
    }
    
    return [ordered]@{
        Status = 'open'
        Comment = @"
$($localadmin.Name) is Enabled and Password is older than 60 days.

$pwsh_cmd
"@
    }
}