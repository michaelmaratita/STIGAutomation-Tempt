function Get-V254281 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $BulkComment = Get-STIGComment -Type Server2022
    $RegistryComment = $BulkComment.Registry
    $PolicyComment = $BulkComment.Policy

    $RegistryOutput = Get-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\W32time\Parameters" `
        -Name "Type" `
        -Comment $RegistryComment

    $PolicySetting = Get-GpResultSetting `
                        -Setting "Configure Windows NTP Client" `
                        -Comment $PolicyComment
    
    $NTP_Source = w32tm /query /source
    
    $Type = w32tm /query /configuration |
    Select-String '^\s*Type:' |
    ForEach-Object { ($_ -split ':', 2)[1].Trim() }

    $Outputs = $Comment.Outputs `
                    -replace '{POLICYSETTING}', $PolicySetting.Comment `
                    -replace '{REGISTRYSETTING}', $RegistryOutput.Comment

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{NTPSOURCE}', $NTP_Source `
                            -replace '{TYPE}', $Type

    if ({($PolicySetting.Value).contains("Enabled") 
        -and
        ($RegistryOutput.Value).contains("NT5DS")
        }){

        $CommentText = $Comment.NotAFinding `
                        -replace '{POLICYSETTING}', $PolicySetting.Setting `
                        -replace '{POLICYVALUE}', $PolicySetting.Value `
                        -replace '{REGISTRYVALUE}', $RegistryOutput.Value

        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = $CommentText + $Outputs + $PowerShellCommand
        }

    } else {

        return [ordered]@{
            Status = 'open'
            Comment = $Outputs + $PowerShellCommand
        }

    }
}