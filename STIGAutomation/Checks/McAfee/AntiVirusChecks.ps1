function  Get-V254248 {
    [CmdletBinding()]
    param()

    $ThreatPrevent= Get-Process mfetp -ErrorAction SilentlyContinue | Select-Object Product, ProductVersion, ProcessName, Id

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Process mfetp | Select-Object Product, ProductVersion, ProcessName, Id

$(Get-Process mfetp -ErrorAction SilentlyContinue | 
    Select-Object Product, ProductVersion, ProcessName, Id | 
    Format-List | 
    Out-String
)
"@

    if ($ThreatPrevent){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = @"
$($env:COMPUTERNAME) is utilizing a third-party anti-virus solution. Trellix Endpoint Security (ENS) is installed and configured 
with ThreatPrevent enabled.

$pwsh_cmd
"@
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = @"
$($env:COMPUTERNAME) is NOT running any anti-virus solutions.

$pwsh_cmd
"@
    }  
}