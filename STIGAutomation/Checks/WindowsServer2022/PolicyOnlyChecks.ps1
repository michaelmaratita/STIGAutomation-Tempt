function Invoke-PolicyChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )

    $DataPath = "$PSScriptRoot\..\..\Data\PolicyOnlyChecks.psd1"
    $DataFile = Import-PowerShellDataFile -Path $DataPath

    foreach ($VulNum in $VulNums) {
        $Data = $DataFile[$VulNum]

        $ExpectedSetting = foreach ($Setting in @($Data.ExpectedSetting)) {
            $Setting `
                -replace '\{USERDOMAIN\}', $env:USERDOMAIN `
                -replace '\{USERDNSDOMAIN\}', $env:USERDNSDOMAIN
        }

        $PolicySetting = if ($Data.LogSettings -and $Data.SubSettings) {
            Get-GpResultSetting `
                -Setting $Data.PolicySetting `
                -LogName $Data.LogName `
                -IncludeSubSettings
        }
        elseif ($Data.LogSettings) {
            Get-GpResultSetting `
                -Setting $Data.PolicySetting `
                -LogName $Data.LogName
        }
        elseif ($Data.SubSettings) {
            Get-GpResultSetting `
                -Setting $Data.PolicySetting `
                -IncludeSubSettings
        }
        else {
            Get-GpResultSetting `
                -Setting $Data.PolicySetting
        }

        $Comment = @"
$($PolicySetting.Comment)
"@

        if ($Data.Comparison -eq 'Groups' -or
            $Data.Comparison -eq 'Contains') {

            $ConfiguredGroups = $PolicySetting.Value -split ',' |
                ForEach-Object {
                    $_.Trim()
                }

            $MissingGroups = $ExpectedSetting | Where-Object {
                $_ -notin $ConfiguredGroups
            }

            if ($MissingGroups.Count -eq 0) {
                $Results[$VulNum] = [ordered]@{
                    Status = 'not_a_finding'
                    Comment = @"
Validated '$($Data.PolicySetting)' has the proper configured Groups assigned.

$Comment
"@
                }
            }
            else {
                $Results[$VulNum] = [ordered]@{
                    Status = 'open'
                    Comment = @"
The following required groups are missing from '$($Data.PolicySetting)':
$($MissingGroups -join "`n")

$Comment
"@
                }
            }
        }
        else {

            if ($PolicySetting.Value -contains $ExpectedSetting) {
                $Results[$VulNum] = [ordered]@{
                    Status = 'not_a_finding'
                    Comment = @"
Validated $env:COMPUTERNAME is configured properly per the Check Text. Evaluations Below:

$Comment
"@
                }
            }
            else {
                $Results[$VulNum] = [ordered]@{
                    Status = 'open'
                    Comment = @"
Validated $env:COMPUTERNAME is NOT configured properly per the Check Text. Evaluations Below:

$Comment
"@
                }
            }
        }
    }

    return $Results
}