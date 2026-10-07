function Get-PolicyAndRegistryValues {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Data,

        [Parameter(Mandatory)]
        [scriptblock]$DefaultOperator,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $Operator = if ($Data.ContainsKey('Operator')) {
                $Data.Operator
            }
            else {
                $DefaultOperator
            }
    
    $PolicyParamSettings = New-PolicyParamSetting -Data $Data
    $PolicySetting = Get-GpResultSetting @PolicyParamSettings -Comment $Comment.PolicyAndRegistry
    
    $RegistryOutput = Get-RegistryValue `
        -Path $Data.RegistryPath `
        -Name $Data.RegistryName `
        -Comment $Comment.Registry

    $RegistryMatch = & $Operator `
        $RegistryOutput.Value `
        $Data.ExpectedValue

    $Output = $Comment.PolicyAndRegistry.Output `
                    -replace '{POLICYSETTING}', $PolicySetting.Comment `
                    -replace '{REGISTRY}', $RegistryOutput.Comment

    return [PSCustomObject]@{
    PolicySetting = $PolicySetting
    RegistryMatch = $RegistryMatch
    Output        = $Output
    }
}