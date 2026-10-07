function Get-GpResultRows {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GPResult
    )

    return [regex]::Matches(
        $GPResult,
        '(?is)<tr[^>]*>(.*?)</tr>'
    )
}