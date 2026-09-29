function New-STIGChecklist {
    [CmdletBinding()]
    param(
        # Type of STIG checklist to create.
        # Examples: OS, DotNetFramework
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    Write-Verbose "Initializing STIG Automation."

    Initialize-STIGAutomation

    Write-Verbose "Starting SCAP scan..."

    New-SCAPScan -Type $Type

    Write-Verbose "Moving SCAP results..."

    Move-SCAPResults

    Write-Verbose "Moving old checklists to Archive"

    Move-ChecklistsToArchive

    Write-Verbose "Loading blank checklist: $Type"

    $Checklist = Read-BlankChecklist -Type $Type

    $Checklist = Update-ChecklistSCAPResults `
        -Checklist $Checklist `
        -Type $Type
    
    Write-Verbose 'Running manual checks...'

    $Checklist = Update-Checklist `
        -Checklist $Checklist `
        -Type $Type

    Write-Verbose 'Generating checklist...'

    Export-STIGChecklist `
        -Checklist $Checklist
    
    Write-Verbose 'STIG checklist generation complete.'

}