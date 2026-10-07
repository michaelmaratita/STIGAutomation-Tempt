function Get-V254254 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $ExpectedRegistryAcls = Import-PowerShellDataFile `
                    -Path "$PSScriptRoot\..\Data\ExpectedRegistryACLs.psd1"

    $Paths = @(
        'SECURITY'
        'SOFTWARE'
        'SYSTEM'
    )

    $Results = [ordered]@{}
    $Failures = @()

    foreach ($Path in $Paths){

        $ExpectedAcl = $ExpectedRegistryAcls.$Path

        Get-Acl "HKLM:\$Path"

        $ConfiguredAcl = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
                        $Path,
                        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
                        [System.Security.AccessControl.RegistryRights]::ReadPermissions
                        ).GetAccessControl().Access

        $Results[$Path]= $ConfiguredAcl

        $Failures += Compare-Acl `
                        -Path $Path `
                        -ConfiguredAcl $ConfiguredAcl `
                        -ExpectedAcl $ExpectedAcl `
                        -Comment $Comment
    }

    # Determine status
    if ($Failures.Count -eq 0) {

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                        -replace '{FAILURES}', $($Failures -join "`n`n")
                        
    }

   $PowerShellCommand = $Comment.PowerShellCommand `
                         -replace '{SECURITY}', $($Results.SECURITY | Out-String) `
                         -replace '{SOFTWARE}', $($Results.SOFTWARE | Out-String) `
                         -replace '{SYSTEM}', $($Results.SYSTEM | Out-String)
                         
    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}