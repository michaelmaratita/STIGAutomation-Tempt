function Get-V254239 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $localadmin = Get-LocalUser | 
                    Where-Object SID -like "*500" |
                    Select-Object Name, 
                                Enabled, 
                                PasswordRequired, 
                                PasswordLastSet

    $PolicyComment = Get-STIGComment -Type 'Server2022'

    $PolicySetting = Get-GpResultSetting `
                        -Setting 'Password Settings' `
                        -IncludeSubSettings `
                        -Comment $PolicyComment.Policy

    $Output = $localadmin.Name + "`n`n" + $PolicySetting.Comment

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $Output

    if (-not $localadmin.Enabled){
        
        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable `
                        -replace '{LOCALADMIN}', $localadmin `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
    
    } elseif ($localadmin.PasswordLastSet -gt (Get-Date).AddDays(-60)){
        
        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{LOCALADMIN}', $localadmin.Name
    
    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{LOCALADMIN}', $localadmin.Name
                        
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}