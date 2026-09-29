function Get-V254264 {
    [CmdletBinding()]
    param()

    $windows_features = Get-WindowsFeature | 
        Where-Object Installed -eq $true |
        Format-List DisplayName, Name, FeatureType |
        Out-String
    
    return [ordered]@{
        Status = 'not_a_finding'
        Comment = @"
Validated $env:ComputerName has the following Windows Features installed. 
Documentation for the installed features can be referenced on the GitLab: 
PaaS\ECS\Architecture\Windows\Server Baseline\$env:ComputerName\Baseline_Configurations

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-WindowsFeature | 
    Where-Object Installed -eq $true |
    Format-List DisplayName, Name, FeatureType

Output
‾‾‾‾‾‾
$windows_features
"@
    }
}