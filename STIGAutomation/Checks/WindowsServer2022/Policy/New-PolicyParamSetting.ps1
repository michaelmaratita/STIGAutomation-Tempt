function New-PolicyParamSetting {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Data
    )

    $PolicyParamSettings = @{
            Setting = $Data.PolicySetting
        }

    if ($Data.LogSettings) {
        $PolicyParamSettings.LogName = $Data.LogName
    }

    if ($Data.SubSettings) {
        $PolicyParamSettings.IncludeSubSettings = $true
    }

    return $PolicyParamSettings

}