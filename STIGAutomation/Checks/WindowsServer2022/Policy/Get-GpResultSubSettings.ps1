function Get-GpResultSubSettings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object[]]$Rows,

        [Parameter(Mandatory)]
        [int]$StartIndex
    )

    $SubSettings = [ordered]@{}

    for ($i = $StartIndex + 1; $i -lt $Rows.Count; $i++) {

        $SubValues = Convert-GpResultRow -Row $Rows[$i]

        if ($SubValues.Count -eq 0) {
            continue
        }

        # SubSetting | Value
        if ($SubValues.Count -eq 2) {

            $SubSettings[$SubValues[0]] = $SubValues[1]

            continue
        }

        # Three or more columns means next policy setting
        if ($SubValues.Count -ge 3) {
            break
        }
    }

    return $SubSettings
}