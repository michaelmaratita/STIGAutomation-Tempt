function Get-V254260 {
    [CmdletBinding()]
    param()
    
    $AllowedShares = @(
        'ADMIN$'
        'C$'
        'D$'
        'IPC$'
    )

    $Shares = @(Get-SmbShare)

    # Identify non-system-created shares
    $NonSystemShares = @(
        $Shares | Where-Object {
            $_.Name -notin $AllowedShares
        }
    )

    if ($NonSystemShares.Count -eq 0) {

        $Status = 'not_applicable'

        $Comment = @"
Validated that only system-created shares such as 'ADMIN$', 'C$', 'D$', and 'IPC$' 
exist on $env:COMPUTERNAME. No nonsystem-created shares require review.
"@

    }
    else {

        # Nonsystem-created shares exist and require permission validation
        $Status = 'open'

        $Comment = @"
Validated that the following nonsystem-created shares exist on 
$env:COMPUTERNAME and require review of Share Permissions and NTFS Security permissions:
"@
    }

    return [ordered]@{
        Status = $Status
        Comment = @"
$Comment

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-SmbShare | Select-Object Name

Ouptut
‾‾‾‾‾‾
$(Get-SmbShare | Select-Object Name | Out-String)
"@
    }
}