function Test-CertificateInstallationFiles {
    [CmdletBinding()]
    param()

    $Extensions = '*.p12', '*.pfx'

    $Drives = Get-PSDrive -PSProvider FileSystem |
        Where-Object { $_.Root }

    $CertificateFiles = foreach ($Drive in $Drives) {
        foreach ($Extension in $Extensions) {
            
            Write-Verbose "Checking $Drive for $Extension files"
            
            Get-ChildItem -Path $Drive.Root `
                -Filter $Extension `
                -File `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }
    }

    $CertificateFiles = @($CertificateFiles)

    [PSCustomObject]@{
        IsFinding = $CertificateFiles.Count -gt 0
        Count     = $CertificateFiles.Count
        Files     = $CertificateFiles.FullName
    }
}
