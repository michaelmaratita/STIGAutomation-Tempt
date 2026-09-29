function Get-GpUserRightsAssignment {
    [CmdletBinding()]
    param()

    $Path = $script:STIGAutomation.GPResultPath

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "GPResult file was not found at $Path."
    }

    $Content = Get-Content -Path $Path -Raw

    $Match = [regex]::Match(
        $Content,
        '(?is)<span class="sectionTitle"[^>]*>\s*Local Policies/User Rights Assignment\s*</span>.*?(?=<div class="he3">)'
    )

    if (-not $Match.Success) {
        throw "User Rights Assignment section was not found in $Path."
    }

    return $Match.Value
}