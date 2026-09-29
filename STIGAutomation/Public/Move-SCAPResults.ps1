function Move-SCAPResults {
    [CmdletBinding()]
    param()

    $SessionPath = Join-Path `
        $env:USERPROFILE `
        'SCC\Sessions'

    if (-not (Test-Path -LiteralPath $SessionPath)) {
        throw "SCAP session directory was not found: $SessionPath"
    }

    $Date = Get-Date -Format 'yyyy-MM-dd'

    $SCAPSession = Get-ChildItem `
        -Path $SessionPath `
        -Directory |
        Where-Object Name -like "$Date*" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $SCAPSession) {
        throw "No SCAP session was found for $Date."
    }

    $XMLPath = Join-Path `
        $SCAPSession.FullName `
        'Results\SCAP\XML'

    if (-not (Test-Path -LiteralPath $XMLPath)) {
        throw "SCAP XML results were not found at $XMLPath."
    }

    $XMLFiles = Get-ChildItem `
        -Path $XMLPath `
        -File `
        -ErrorAction Stop

    if ($XMLFiles.Count -eq 0) {
        throw "No SCAP result files were found in $XMLPath."
    }

    # # Remove previous results.
    # $ExistingResults = Get-ChildItem `
    #     -Path $script:STIGAutomation.SCAPResultsPath `
    #     -File `
    #     -ErrorAction SilentlyContinue

    # if ($ExistingResults) {
    #     Write-Verbose 'Removing previous SCAP results.'

    #     $ExistingResults |
    #         Remove-Item -Force -ErrorAction Stop
    # }

    Write-Verbose "Moving $($XMLFiles.Count) SCAP result file(s)."

    foreach ($File in $XMLFiles) {
        Move-Item `
            -LiteralPath $File.FullName `
            -Destination $script:STIGAutomation.SCAPResultsPath `
            -Force `
            -ErrorAction Stop
    }

    # Remove the completed SCAP session.
    # Remove-Item `
    #     -LiteralPath $SCAPSession.FullName `
    #     -Recurse `
    #     -Force `
    #     -ErrorAction Stop

    Write-Verbose 'SCAP results successfully moved.'
}