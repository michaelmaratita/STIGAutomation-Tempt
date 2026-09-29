#Requires -Version 5.1

$ModuleRoot = $PSScriptRoot

$script:STIGAutomation = [ordered]@{
    RootPath               = $null
    BlankChecklistPath     = $null
    CompletedChecklistPath = $null
    SCAPResultsPath        = $null
}

# Load private functions
Get-ChildItem `
    -Path "$ModuleRoot\Private" `
    -Filter '*.ps1' `
    -File |
    ForEach-Object {
        . $_.FullName
    }

# Load SCAP functions
Get-ChildItem `
    -Path "$ModuleRoot\SCAP" `
    -Filter '*.ps1' `
    -File |
    ForEach-Object {
        . $_.FullName
    }

# Load STIG checks
Get-ChildItem `
    -Path "$ModuleRoot\Checks" `
    -Filter '*.ps1' `
    -Recurse |
    ForEach-Object {
        . $_.FullName
    }

# Load public functions
Get-ChildItem `
    -Path "$ModuleRoot\Public" `
    -Filter '*.ps1' `
    -File |
    ForEach-Object {
        . $_.FullName
    }

# Export only public commands
Export-ModuleMember -Function @(
    'New-STIGChecklist'
    'New-STIGFolder'
    'New-SCAPScan'
    'Move-SCAPResults'
    'Move-ChecklistsToArchive'
    'Read-BlankChecklist'
    'Read-XCCDF'
    'Get-XCCDFInfo'
    'Update-Checklist'
    'Export-STIGChecklist'
)