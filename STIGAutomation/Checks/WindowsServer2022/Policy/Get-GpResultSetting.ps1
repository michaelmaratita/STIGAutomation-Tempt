function Get-GpResultSetting {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Setting,

        [Parameter()]
        [string]$LogName,

        [Parameter()]
        [switch]$IncludeSubSettings,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $Path = $script:STIGAutomation.GPResultPath
    $GPResult = $script:STIGAutomation.GPResult

    $Rows = Get-GpResultRows -GPResult $GPResult

    $SettingResult = Find-GpResultSetting `
        -Rows $Rows `
        -Setting $Setting `
        -LogName $LogName

    if ($null -eq $SettingResult) {

        $CommentText = $Comment.NotFound `
            -replace '{GPRESULTPATH}', $Path `
            -replace '{SETTING}', $Setting `
            -replace '{LOGNAME}', $(if ($LogName) { "LogName : $LogName" } else { '' })

        return [ordered]@{
            Setting     = $Setting
            Value       = $null
            GPO         = $null
            SubSettings = $null
            Comment     = $CommentText
        }
    }

    $SubSettings = [ordered]@{}

    if ($IncludeSubSettings) {
        $SubSettings = Get-GpResultSubSettings `
            -Rows $Rows `
            -StartIndex $SettingResult.Index
    }

    $SubSettingText = if ($SubSettings.Count -gt 0) {
        (
            $SubSettings.GetEnumerator() |
                ForEach-Object {
                    "$($_.Key) : $($_.Value)"
                }
        ) -join "`n"
    }

    $CommentText = $Comment.Validation `
        -replace '{GPRESULTPATH}', $Path `
        -replace '{SETTING}', $SettingResult.Setting `
        -replace '{LOGNAME}', $(if ($LogName) { "LogName : $LogName" } else { '' }) `
        -replace '{VALUE}', $SettingResult.Value `
        -replace '{GPO}', $SettingResult.GPO `
        -replace '{SUBSETTINGS}', $(if ($SubSettingText) {
            "SubSettings:`r`n$SubSettingText"
        })

    return [ordered]@{
        Setting     = $SettingResult.Setting
        Value       = $SettingResult.Value
        GPO         = $SettingResult.GPO
        SubSettings = $SubSettings
        Comment     = $CommentText
    }
}