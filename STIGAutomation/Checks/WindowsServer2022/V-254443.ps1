function Get-V254443 {
    [CmdletBinding()]
    param()

    $interoperability_certs = Get-ChildItem `
        -Path Cert:Localmachine\disallowed | 
        Where-Object {
            $_.Issuer -Like "*DoD Interoperability*" `
            -and `
            $_.Subject -Like "*DoD*"
        }

    $pwsh_cmd= @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem `
    -Path Cert:Localmachine\disallowed | 
    Where-Object {
        `$_.Issuer -Like "*DoD Interoperability*" `
        -and `
        `$_.Subject -Like "*DoD*"
    } |
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
Validated certificates are listed where the Issuer and Subject matches the provided Check text.

$pwsh_cmd
"@
        }
    } else {
        return [ordered]@{
            Status = 'open'
            Comment = @"
Validated certificates are NOT listed where the Issuer and Subject matches the provided Check text.

$pwsh_cmd           
"@
        }
    }   
}