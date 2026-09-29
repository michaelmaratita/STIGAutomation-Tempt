function Get-V254265 {
    [CmdletBinding()]
    param()

    $Firewall = @{
        Trellix  = Get-Service mfefire -ErrorAction SilentlyContinue
        Defender = Get-Service mpssvc -ErrorAction SilentlyContinue
    }

    $pwsh_cmd = @"
PowerShell Cmd (Trellix Firewall Core Service)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service mfefire

$(Get-Service mfefire -ErrorAction SilentlyContinue | Format-List | Out-String)

PowerShell Cmd (Windows Defender FireWall)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service mpssvc

$(Get-Service mpssvc -ErrorAction SilentlyContinue  | Format-List | Out-String)
"@

    if ({$Firewall.Trellix.Status -eq 'Running' `
        -or `
        $Firewall.Defender.Status -eq 'Running'}
    ){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = @"
$($env:COMPUTERNAME) is utilizing a host-based firewall and it is enabled on the system.

$pwsh_cmd
"@
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = @"
$($env:COMPUTERNAME) is NOT utilizing a host-based firewall.

$pwsh_cmd
"@  
    }    
}