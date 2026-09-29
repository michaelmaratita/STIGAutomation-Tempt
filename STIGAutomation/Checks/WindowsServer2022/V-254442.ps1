function Get-V254442 {
    [CmdletBinding()]
    param()

    $root_certs = Get-ChildItem `
        -Path Cert:Localmachine\root | 
        Where-Object Subject -Like "*DoD*"

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem `
    -Path Cert:Localmachine\root | 
    Where-Object Subject -Like "*DoD*" |
    Format-List Subject, NotAfter

Output
‾‾‾‾‾‾
$($root_certs | 
    Format-List Subject, NotAfter | 
    Out-String
)
"@


    if (($root_certs).Count -gt 0){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated DoD Root CA certificates are installed as Trusted Root Certification Authorities.

$pwsh_cmd
"@
        }
    } else {
        return [ordered]@{
            Status = 'open'
            Comment = @"
Validated DoD Root CA certificates are NOT installed as Trusted Root Certification Authorities.

$pwsh_cmd           
"@
        }
    }   
}