function Find-GpResultSetting {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object[]]$Rows,

        [Parameter(Mandatory)]
        [string]$Setting,

        [Parameter()]
        [string]$LogName
    )

    for ($i = 0; $i -lt $Rows.Count; $i++) {

        $Row = $Rows[$i]

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

        $Values = Convert-GpResultRow -Row $Row

        if ($Values.Count -eq 0) {
            continue
        }

        if (-not $LogName) {

            if ($Values[0] -ne $Setting -and
                $Values[0] -notlike "*$Setting*") {
                continue
            }
        }

        return [ordered]@{
            Index   = $i
            Setting = $Values[0]
            Value   = $(if ($Values.Count -ge 2) { $Values[1] })
            GPO     = $(if ($Values.Count -ge 3) { $Values[2] })
        }
    }

    return $null
}