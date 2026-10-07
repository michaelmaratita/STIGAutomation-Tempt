function Get-STIGSettings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $STIGData = Import-PowerShellDataFile `
        -Path "$PSScriptRoot\..\Data\STIGSettings.psd1"

    return $STIGData[$Type]
    
}