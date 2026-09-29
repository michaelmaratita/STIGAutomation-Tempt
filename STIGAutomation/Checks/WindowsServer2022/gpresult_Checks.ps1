function Get-GpResultSetting {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Setting,

        [Parameter()]
        [string]$LogName,

        [Parameter()]
        [switch]$IncludeSubSettings
    )

    $Path = $script:STIGAutomation.GPResultPath
    # Read the entire GPResult HTML
    $gpresult = $script:STIGAutomation.GPResult

    # Find all table rows
    $Rows = [regex]::Matches(
        $gpresult,
        '(?is)<tr[^>]*>(.*?)</tr>'
    )

    $SettingValue = $null
    $Value = $null
    $GPO = $null
    $SubSettings = [ordered]@{}

    # Track which row contains the requested setting
    $SettingRowIndex = $null

    for ($i = 0; $i -lt $Rows.Count; $i++) {

        $Row = $Rows[$i]

        # If LogName was supplied, only consider rows
        # containing the requested setting and log name.
        if ($LogName) {

            $Pattern = 'gpmc_settingName="' +
                       [regex]::Escape($Setting) +
                       '".*?gpmc_settingPath="[^"]*/' +
                       [regex]::Escape($LogName) +
                       '"'

            if ($Row.Value -notmatch $Pattern) {
                continue
            }
        }

        # Extract TD values from the row
        $Values = [regex]::Matches(
            $Row.Groups[1].Value,
            '(?is)<td[^>]*>(.*?)</td>'
        ) |
            ForEach-Object {

                $Item = $_.Groups[1].Value

                $Item = $Item -replace '<[^>]+>', ''
                $Item = $Item -replace '&nbsp;', ' '
                $Item = $Item -replace '&amp;', '&'
                $Item = $Item -replace '&lt;', '<'
                $Item = $Item -replace '&gt;', '>'
                $Item = $Item -replace '\s+', ' '

                $Item.Trim()
            }

        $Values = @(
            $Values | Where-Object {
                -not [string]::IsNullOrWhiteSpace($_)
            }
        )

        if ($Values.Count -eq 0) {
            continue
        }

        # Normal setting search when LogName isn't supplied
        if (-not $LogName) {

            if ($Values[0] -ne $Setting -and
                $Values[0] -notlike "*$Setting*") {
                continue
            }
        }

        # We found the requested setting
        $SettingValue = $Values[0]

        if ($Values.Count -ge 2) {
            $Value = $Values[1]
        }

        if ($Values.Count -ge 3) {
            $GPO = $Values[2]
        }

        $SettingRowIndex = $i

        break
    }

    # Setting not found
    if ($null -eq $SettingRowIndex) {

        return [ordered]@{
            Setting     = $Setting
            Value       = $null
            GPO         = $null
            SubSettings = $null
            Comment     = @"
GPO Validation found at $Path`:

Setting : $Setting
$(if ($LogName) { "LogName : $LogName" })
Result  : Setting not found
"@
        }
    }

    # Collect subsettings from rows following the parent setting
    if ($IncludeSubSettings) {

        for ($i = $SettingRowIndex + 1; $i -lt $Rows.Count; $i++) {

            $SubRow = $Rows[$i]

            $SubValues = [regex]::Matches(
                $SubRow.Groups[1].Value,
                '(?is)<td[^>]*>(.*?)</td>'
            ) |
                ForEach-Object {

                    $Item = $_.Groups[1].Value

                    $Item = $Item -replace '<[^>]+>', ''
                    $Item = $Item -replace '&nbsp;', ' '
                    $Item = $Item -replace '&amp;', '&'
                    $Item = $Item -replace '&lt;', '<'
                    $Item = $Item -replace '&gt;', '>'
                    $Item = $Item -replace '\s+', ' '

                    $Item.Trim()
                }

            $SubValues = @(
                $SubValues | Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                }
            )

            if ($SubValues.Count -eq 0) {
                continue
            }

            # Two-column row = SubSetting | Value
            if ($SubValues.Count -eq 2) {

                $SubSettings[$SubValues[0]] = $SubValues[1]

                continue
            }

            # Three-column row means we reached another policy setting
            if ($SubValues.Count -ge 3) {
                break
            }
        }
    }

    # Build subsetting comment
    $SubSettingText = $null

    if ($SubSettings.Count -gt 0) {

        $SubSettingText = (
            $SubSettings.GetEnumerator() |
                ForEach-Object {
                    "$($_.Key) : $($_.Value)"
                }
        ) -join "`n"
    }

    return [ordered]@{
        Setting     = $SettingValue
        Value       = $Value
        GPO         = $GPO
        SubSettings = $SubSettings
        Comment     = @"
GPO Validation found at $Path`:
$(if ($LogName) {
"LogName : $LogName
"
})
Setting : $SettingValue
Value   : $Value
GPO     : $GPO
$(if ($SubSettingText) {
@"

SubSettings:
$SubSettingText
"@
})
"@
    }
}