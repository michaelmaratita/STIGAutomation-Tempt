function Get-V254249 {
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
$($env:COMPUTERNAME) is utilizing a third-party Host Intrusion Protection (HIPS)/Host Intrustion Detection (HIDS) solution. Trellix Endpoint Security (ENS) is installed
with Exploitation Prevention and Access Protection enabled.

$pwsh_cmd
"@
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = @"
$($env:COMPUTERNAME) is NOT running any Host Intrusion Protection (HIPS)/Host Intrustion Detection (HIDS) solutions.

$pwsh_cmd
"@
    }
}