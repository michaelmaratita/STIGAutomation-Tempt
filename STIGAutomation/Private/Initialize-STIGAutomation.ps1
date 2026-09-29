function Initialize-STIGAutomation {
    [CmdletBinding()]
    param()

    $DriveLetter = Get-DataDrive

    $script:STIGAutomation.RootPath =
        Join-Path "${DriveLetter}:" 'STIG_AUTOMATION'

    $script:STIGAutomation.Archive =
        Join-Path $script:STIGAutomation.RootPath 'Archive'

    $script:STIGAutomation.BlankChecklistPath =
        Join-Path $script:STIGAutomation.RootPath 'Blank_Checklists'

    $script:STIGAutomation.CompletedChecklistPath =
        Join-Path $script:STIGAutomation.RootPath 'Completed_Checklists'

    $script:STIGAutomation.SCAPResultsPath =
        Join-Path $script:STIGAutomation.RootPath 'SCAP_Results'

    $script:STIGAutomation.GPResultPath =
        Join-Path $script:STIGAutomation.RootPath 'gpresult.html'

    $null = gpresult /h $script:STIGAutomation.GPResultPath /f 2>&1

    if ($LASTEXITCODE -ne 0) {
        throw "gpresult failed with exit code $LASTEXITCODE."
    }

    $script:STIGAutomation.GPResult =
        Get-Content -Path $script:STIGAutomation.GPResultPath -Raw

    $Directories = @(
        $script:STIGAutomation.RootPath
        $script:STIGAutomation.Archive
        $script:STIGAutomation.BlankChecklistPath
        $script:STIGAutomation.CompletedChecklistPath
        $script:STIGAutomation.SCAPResultsPath
    )

    foreach ($Directory in $Directories) {
        if (-not (Test-Path -LiteralPath $Directory)) {
            Write-Verbose "Creating directory: $Directory"

            New-Item `
                -Path $Directory `
                -ItemType Directory `
                -Force |
                Out-Null
        }
    }
}