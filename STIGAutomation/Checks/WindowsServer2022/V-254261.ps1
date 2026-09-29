function Get-V254261 {
    [CmdletBinding()]
    param()
    
    $certs = Test-CertificateInstallationFiles

    if ($certs.IsFinding){
        return [ordered]@{
            Status = 'open'
            Comment = @"
Certificate installation files were found on $($env:COMPUTERNAME):

Remove any certificate installation files (*.p12 and *.pfx) found on the system.

If the files are required by a server-based application, verify that they are
application files rather than certificate installation files and ensure the
exception is documented with the ISSO.

$($certs.Comment)

Output
‾‾‾‾‾‾‾
$($certs.Files -join "`n")
"@
        }
    }
    else {
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
No .p12 or .pfx files were found on $env:COMPUTERNAME
"@
        }
    }

    
}