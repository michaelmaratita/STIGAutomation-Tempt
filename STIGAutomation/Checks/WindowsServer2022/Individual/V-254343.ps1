function Get-V254343 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    # Check PowerShell Output
    $PSCheck = Get-CimInstance -ClassName Win32_DeviceGuard `
                               -Namespace root\Microsoft\Windows\DeviceGuard `
                               -Verbose:$false

    $PS_bool = ($PSCheck.RequiredSecurityProperties -contains 2) `
                -and `
                ($PSCheck.VirtualizationBasedSecurityStatus -contains 2)

    $Comments = Get-STIGComment -Type Server2022
    $RegChecksComment = $Comments.Registry
    $PolicyComment = $Comments.Policy

    # Check Registry Output
    $Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
    $RegChecks = @{
        VBS = Get-RegistryValue `
                -Path $Path `
                -Name 'EnableVirtualizationBasedSecurity' `
                -Comment $RegChecksComment
        RSP = Get-RegistryValue `
                -Path $Path `
                -Name 'RequirePlatformSecurityFeatures' `
                -Comment $RegChecksComment
    }
    
    $Reg_bool = ($RegChecks.VBS.Value -eq 1) `
                -and `
                (
                    ($RegChecks.RSP.Value -eq 1) `
                    -or `
                    ($RegChecks.RSP.Value -eq 3)
                )
    
    # Check the Group Policy Object Settings
    
    $PolicySetting = Get-GpResultSetting `
                        -Setting 'Turn On Virtualization Based Security' `
                        -Comment $PolicyComment `
                        -IncludeSubSettings
    $Policy_bool = $PolicySetting.Value -eq 'Enabled'


    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($PSCheck | Out-String)

    $RegistryComment = $Comment.Registry `
                        -replace '{VBS}', $RegChecks.VBS.Comment `
                        -replace '{RSP}', $RegChecks.RSP.Comment
    
    if ($PS_bool -and `
        $Reg_bool -and `
        $Policy_bool){

        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                        -replace '{POLICYSETTING}', $PolicySetting.Comment

    } else {

        $Status  = 'open'
        $CommentText = $null
    }

    return [ordered]@{
            Status  = $Status
            Comment = $CommentText + $PowerShellCommand + $RegistryComment
    }
}