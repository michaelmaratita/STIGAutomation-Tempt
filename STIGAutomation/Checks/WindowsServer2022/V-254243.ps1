function Get-V254243 {
    [CmdletBinding()]
    param()

    $DataPath         = "$PSScriptRoot\..\..\Data\ServiceAccounts.psd1"
    $Data             = Import-PowerShellDataFile -Path $DataPath

    # Array
    $ServiceAccounts = $Data[$env:COMPUTERNAME]

    $pwsh_cmd = @"
PowerShell Cmd for AD User
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADUser `
    -Identity {SamAccountName} `
    -Properties pwdLastSet | 
    Select-Object Name, 
                    Enabled, 
                    SamAccountName, 
                    pwdLastSet

Cmd to Convert pwdLastSet
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
[DateTime]::FromFileTime({pwdLastSet})

"@
    $Comment = @"
$($env:COMPUTERNAME) has the following service account(s) associated with it. These accounts are manually managed and their passwords are reviewed and updated annually. Additionally, when an administrator with knowledge of a service account password leaves the organization, the password is changed after the administrator's access has been revoked.
"@

    $AccountInfo = ""
    $Users_ExpiredPasswords = @()

    foreach ($Account in $ServiceAccounts){
        $User = Get-ADUser `
                -Identity $Account `
                -Properties pwdLastSet | 
                Select-Object Name, 
                              Enabled, 
                              SamAccountName, 
                              pwdLastSet
        
        $ConvertpwdLastSet = [DateTime]::FromFileTime($User.pwdLastSet)
        
        if ($ConvertpwdLastSet -lt (Get-Date).AddDays(-365)){
            $Users_ExpiredPasswords += $Account
        }

        $AccountInfo += @"
$($User | Format-List | Out-String)Converted pwdLastSet for $($User.SamAccountName): $ConvertpwdLastSet
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
"@
    }

    if ($Users_ExpiredPasswords.Count -eq 0){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
$Comment

Service Accounts
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($ServiceAccounts -join "`r`n")

$pwsh_cmd

$AccountInfo
"@
        }
    }
    return [ordered]@{
        Status = 'open'
        Comment = @"
($($Users_ExpiredPasswords.Count)) account(s) have passwords that are older than 365 days. Please review the accounts and reset the passwords as soon as possible.

Accounts with Passwords Older than 365 days
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($Users_ExpiredPasswords -join "`r`n")

Service Accounts
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($ServiceAccounts -join "`r`n")

$AccountInfo
"@
    }

}