function Invoke-PolicyAndRegistryChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $DataPath = "$PSScriptRoot\..\Data\PolicyAndRegistryChecks.psd1"
    $DataFile = Import-PowerShellDataFile -Path $DataPath

    $DefaultOperator = $DataFile.DefaultOperator
    $PolicyAndRegistryChecks = $DataFile.Checks

    foreach ($VulNum in $VulNums){
        
        $Data = $PolicyAndRegistryChecks[$VulNum]

        $Result = Get-PolicyAndRegistryValues `
                    -Data $Data `
                    -DefaultOperator $DefaultOperator `
                    -Comment $Comment

        if ($Result.RegistryMatch -and
            $Result.PolicySetting.Value -contains $Data.ExpectedSetting
        ){
            $Results[$VulNum] = [ordered]@{
                Status = 'not_a_finding'
                Comment = $Comment.PolicyAndRegistry.NotAFinding `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                            -replace '{OUTPUT}', $Result.Output
            }
        }
        else {
            $Results[$VulNum] = [ordered]@{
                Status = 'open'
                Comment = $Comment.PolicyAndRegistry.Open `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                            -replace '{OUTPUT}', $Result.Output
            }
        }
    }

    return $Results
}