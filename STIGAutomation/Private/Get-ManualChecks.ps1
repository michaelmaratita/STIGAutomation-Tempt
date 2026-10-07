function Get-ManualChecks {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework', 'Server2025')]
        [string]$Type
    )

    $Checks =  Import-PowerShellDataFile -Path "$PSScriptRoot\..\Data\ManualChecks.psd1"

    return $Checks.$Type
}