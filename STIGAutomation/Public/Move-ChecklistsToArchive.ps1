function Move-ChecklistsToArchive {
    [CmdletBinding()]
    param()

    # Make sure STIGAutomation paths are initialized.
    if ([string]::IsNullOrWhiteSpace(
        $script:STIGAutomation['CompletedChecklistPath']
    )) {
        Initialize-STIGAutomation
    }

    $CompletedPath = $script:STIGAutomation['CompletedChecklistPath']
    $ArchivePath = $script:STIGAutomation['Archive']

    # Get all files currently in the Completed_Checklists folder.
    $Checklists = Get-ChildItem `
        -Path $CompletedPath `
        -File

    # Nothing to archive.
    if ($Checklists.Count -eq 0) {
        Write-Verbose "No checklists found in: $CompletedPath"
        return
    }

    # Create a timestamped folder for this archive operation.
    $Timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'

    $ArchiveSessionPath = Join-Path `
        -Path $ArchivePath `
        -ChildPath $Timestamp

    New-Item `
        -Path $ArchiveSessionPath `
        -ItemType Directory `
        -Force | Out-Null

    Write-Verbose "Archive folder created: $ArchiveSessionPath"

    # Move each checklist into the timestamped archive folder.
    foreach ($Checklist in $Checklists) {

        $Destination = Join-Path `
            -Path $ArchiveSessionPath `
            -ChildPath $Checklist.Name

        Move-Item `
            -LiteralPath $Checklist.FullName `
            -Destination $Destination

        Write-Verbose "Archived: $($Checklist.Name)"
    }

    Write-Verbose "$($Checklists.Count) checklist(s) moved to: $ArchiveSessionPath"

    # Return the archive folder.
    #return Get-Item -LiteralPath $ArchiveSessionPath
}