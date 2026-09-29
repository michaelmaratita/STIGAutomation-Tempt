function Read-BlankChecklist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $ChecklistFiles = @{
        Server2022      = 'Blank*2022.cklb'
        DotNetFramework = 'Blank*Framework.cklb'
    }

    $Pattern = $ChecklistFiles[$Type]

    $File = Get-ChildItem `
        -Path $script:STIGAutomation.BlankChecklistPath `
        -Recurse `
        -File `
        -Filter $Pattern |
        Select-Object -First 1

    if ($null -eq $File) {
        throw "No blank checklist was found for type '$Type'."
    }

    Write-Verbose "Reading checklist: $($File.FullName)"

    return Get-Content `
        -LiteralPath $File.FullName `
        -Raw |
        ConvertFrom-Json
}