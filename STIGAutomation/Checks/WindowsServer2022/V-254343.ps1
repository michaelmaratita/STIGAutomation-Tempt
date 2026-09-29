function Get-V254343 {
    [CmdletBinding()]
    param()

    # Check PowerShell Output
    $PSCheck = Get-CimInstance -ClassName Win32_DeviceGuard `
        -Namespace root\Microsoft\Windows\DeviceGuard `
        -Verbose:$false
    $RequiredSecurityProperties = $PSCheck.RequiredSecurityProperties
    $VBSStatus = $PSCheck.VirtualizationBasedSecurityStatus
    $PSExpected = 2
    $PS_bool = ($RequiredSecurityProperties -contains $PSExpected) `
                -and `
                ($VBSStatus -contains $PSExpected)

    $pwsh_command = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

Output
‾‾‾‾‾‾
$($PSCheck | Out-String)
"@

    # Check Registry Output
    $Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
    $RegChecks = @{
        VBS = Get-RegistryValue -Path $Path -Name 'EnableVirtualizationBasedSecurity'
        RSP = Get-RegistryValue -Path $Path -Name 'RequirePlatformSecurityFeatures'
    }
    
    $Reg_bool = ($RegChecks.VBS.Value -eq 1) `
                -and `
                (
                    ($RegChecks.RSP.Value -eq 1) `
                    -or `
                    ($RegChecks.RSP.Value -eq 3)
                )
    
    # Check the Group Policy Object Settings
    $PolicySetting = Get-GpResultSetting -Setting 'Turn On Virtualization Based Security' -IncludeSubSettings
    $Policy_bool = $PolicySetting.Value -eq 'Enabled'

    if ($PS_bool `
        -and `
        $Reg_bool `
        -and `
        $Policy_bool){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment =  @"
$($env:COMPUTERNAME) is running SecureBoot and Virtualized Based Security (VBS). This is configured through Group Policy, but validations through PowerShell and Registry Settings have been completed. Outputs below.

$($PolicySetting.Comment)

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$pwsh_command
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

REGISTRY CHECKS:

$($RegChecks.VBS.Comment)

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($RegChecks.RSP.Comment)
"@
        }
    }

    return [ordered]@{
            Status  = 'open'
            Comment =  @"
$pwsh_command
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($RegChecks.VBS.Comment)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

$($RegChecks.RSP.Comment)
"@
    }
}