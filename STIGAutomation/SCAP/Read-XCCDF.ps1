function Read-XCCDF {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $STIGData = Import-PowerShellDataFile `
        -Path "$PSScriptRoot\..\Data\STIGSettings.psd1"

    $Pattern = $STIGData[$Type].XCCDF

    $File = Get-ChildItem `
        -Path $script:STIGAutomation.SCAPResultsPath `
        -Recurse `
        -File `
        -Filter $Pattern |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $File) {
        throw "No XCCDF result was found for type '$Type'."
    }

    Write-Verbose "Reading XCCDF result: $($File.FullName)"

    return [xml](Get-Content `
        -LiteralPath $File.FullName `
        -Raw)
}