function Get-STIGComment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework', 'Server2025')]
        [string]$Type
    )

    $CommentsPath = @{
        Server2022      = '..\Checks\WindowsServer2022\Data\Comments.psd1'
        DotNetFramework = '..\Checks\DotNetFramework\Data\Comments.psd1'
        Server2025      = '..\Checks\WindowsServer2025\Data\Comments.psd1'
    }

    $DataPath = Join-Path $PSScriptRoot $CommentsPath[$Type]
    
    return Import-PowerShellDataFile -Path $DataPath
}