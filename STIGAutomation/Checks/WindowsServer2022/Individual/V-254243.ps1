function Get-V254243 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $DataPath         = "$PSScriptRoot\..\..\..\Data\ServiceAccounts.psd1"
    $Data             = Import-PowerShellDataFile -Path $DataPath

    # Array
    $ServiceAccounts = $Data[$env:COMPUTERNAME]

    # Initialize Blank vars
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
    
        $AccountInfo += $Comment.Info `
                            -replace '{USER}', $($User | Format-List | Out-String) `
                            -replace '{SAMACCOUNTNAME}', $User.SamAccountName `
                            -replace '{CONVERTEDPW}', $ConvertpwdLastSet

    }

    if ($Users_ExpiredPasswords.Count -eq 0){
        
        $Status = 'not_a_finding'
        $CommentText = (
                        $Comment.NotAFinding `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                        ) + (
                            $Comment.ServiceAccounts `
                                -replace '{SERVICEACCOUNTS}', $($ServiceAccounts -join "`n")
                            ) + $Comment.PowerShellCommand + $AccountInfo

    } else {

        $Status = 'open'
        $CommentText = (
                        $Comment.Open `
                            -replace '{EXPIREDCOUNT}', $Users_ExpiredPasswords.Count `
                            -replace '{USEREXPIREDPW}', $Users_ExpiredPasswords -join "`r`n"
                        ) + (
                            $Comment.ServiceAccounts `
                                -replace '{SERVICEACCOUNTS}', $ServiceAccounts -join "`r`n"
                            ) + $Comment.PowerShellCommand + $AccountInfo
                            
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText
    }
}