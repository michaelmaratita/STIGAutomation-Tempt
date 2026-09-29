function Invoke-PolicyAndRegistryChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )

    $DataPath = "$PSScriptRoot\..\..\Data\PolicyAndRegistryChecks.psd1"
    $DataFile = Import-PowerShellDataFile -Path $DataPath

    $DefaultOperator = $DataFile.DefaultOperator
    $PolicyAndRegistryChecks = $DataFile.Checks

    foreach ($VulNum in $VulNums){
        $Data = $PolicyAndRegistryChecks[$VulNum]

        $Operator = if ($Data.ContainsKey('Operator')) {
                $Data.Operator
            }
            else {
                $DefaultOperator
            }
        
        $RegistryOutput = Get-RegistryValue `
            -Path $Data.RegistryPath `
            -Name $Data.RegistryName

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

        
        $RegistryMatch = & $Operator `
            $RegistryOutput.Value `
            $Data.ExpectedValue


        $Comment = @"
$($PolicySetting.Comment)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($RegistryOutput.Comment)
"@

        if ($RegistryMatch -and
            $PolicySetting.Value -contains $Data.ExpectedSetting
        ){
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
Validated $env:COMPUTERNAME is NOT configured properly per the Check Text. Evalutaions Below:

$Comment
"@
            }
        }
    }

    return $Results
}