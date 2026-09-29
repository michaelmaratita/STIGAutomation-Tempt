function Convert-BannerText {
    [CmdletBinding()]
    param(
        [string]$Text
    )

    $Text = $Text -replace '\s+', ' '
    $Text = $Text -replace ',\s*', ' '
    $Text = $Text.Trim()

    return $Text

}