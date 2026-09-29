function Get-V254444 {
    [CmdletBinding()]
    param()

    $interoperability_certs = Get-ChildItem `
        -Path Cert:Localmachine\disallowed | 
        Where-Object Issuer -Like "*CCEB Interoperability*"

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem `
    -Path Cert:Localmachine\disallowed | 
    Where-Object Issuer -Like "*CCEB Interoperability*" |
    Format-List Issuer, Subject, NotAfter

Output
‾‾‾‾‾‾
$($interoperability_certs | 
    Format-List Issuer, Subject, NotAfter | 
    Out-String
)
"@


    if (($interoperability_certs).Count -gt 0){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated CCEB Interoperability Root CA certificates are listed from the provided Check text command.

$pwsh_cmd
"@
        }
    } else {
        return [ordered]@{
            Status = 'open'
            Comment = @"
Validated CCEB Interoperability Root CA certificates are NOT listed from the provided Check Text command.

$pwsh_cmd          
"@
        }
    }   
}