function Get-V254264 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $WindowsFeatures = Get-WindowsFeature | 
        Where-Object Installed -eq $true |
        Format-List DisplayName, Name, FeatureType |
        Out-String

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $WindowsFeatures

    $CommentText = $Comment.NotAFinding `
                    -replace '{COMPUTERNAME}', $env:COMPUTERNAME
    
    return [ordered]@{
        Status = 'not_a_finding'
        Comment = $CommentText + $PowerShellCommand
    }
}