function Convert-GpResultRow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Text.RegularExpressions.Match]$Row
    )

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

    return @(
        $Values | Where-Object {
            -not [string]::IsNullOrWhiteSpace($_)
        }
    )
}