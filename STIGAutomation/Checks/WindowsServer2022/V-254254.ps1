function Get-V254254 {
    [CmdletBinding()]
    param()

    # Get Registry ACLs
    get-acl HKLM:\SECURITY
    get-acl HKLM:\SOFTWARE
    get-acl HKLM:\SYSTEM
    $HKLM_SECURITY = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
        'SECURITY',
        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
        [System.Security.AccessControl.RegistryRights]::ReadPermissions
    ).GetAccessControl()
    $HKLM_SOFTWARE = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
        'SOFTWARE',
        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
        [System.Security.AccessControl.RegistryRights]::ReadPermissions
    ).GetAccessControl()
    $HKLM_SYSTEM   = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
        'SYSTEM',
        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
        [System.Security.AccessControl.RegistryRights]::ReadPermissions
    ).GetAccessControl()
    
    $AccessControlType = 'Allow'

    # Permission sets per STIG Check
    $Security = [ordered]@{
        'NT AUTHORITY\SYSTEM' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = [ordered]@{
            #ReadPermissions is Read Control
            #ChangePermissions is Write DAC
            RegistryRights = 'ReadPermissions, ChangePermissions'
        }
    }

   $Software = [ordered]@{
        'CREATOR OWNER' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'NT AUTHORITY\SYSTEM' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Users' = [ordered]@{
            RegistryRights = 'ReadKey'
        }

        'APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES' = [ordered]@{
            RegistryRights = 'ReadKey'
        }

        'S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681' = [ordered]@{
            RegistryRights = 'ReadKey'
        }
    }

    $System = [ordered]@{
        'CREATOR OWNER' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'NT AUTHORITY\SYSTEM' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = [ordered]@{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Users' = [ordered]@{
            RegistryRights = 'ReadKey'
        }

        'APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES' = [ordered]@{
            RegistryRights = 'ReadKey'
        }

        'S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681' = [ordered]@{
            RegistryRights = 'ReadKey'
        }
    }

    # Create ACL tables
    $HKLM_SECURITY_ACL = [ordered]@{}
    $HKLM_SOFTWARE_ACL = [ordered]@{}
    $HKLM_SYSTEM_ACL   = [ordered]@{}

    foreach ($Access in $HKLM_SECURITY.Access) {

        $HKLM_SECURITY_ACL[$Access.IdentityReference.Value] = [ordered]@{
            RegistryRights    = $Access.RegistryRights
            AccessControlType = $Access.AccessControlType
            IdentityReference = $Access.IdentityReference.Value
            IsInherited       = $Access.IsInherited
            InheritanceFlags  = $Access.InheritanceFlags
            PropagationFlags  = $Access.PropagationFlags
        }
    }

    foreach ($Access in $HKLM_SOFTWARE.Access) {

        $HKLM_SOFTWARE_ACL[$Access.IdentityReference.Value] = [ordered]@{
            RegistryRights    = $Access.RegistryRights
            AccessControlType = $Access.AccessControlType
            IdentityReference = $Access.IdentityReference.Value
            IsInherited       = $Access.IsInherited
            InheritanceFlags  = $Access.InheritanceFlags
            PropagationFlags  = $Access.PropagationFlags
        }
    }

    foreach ($Access in $HKLM_SYSTEM.Access) {

        $HKLM_SYSTEM_ACL[$Access.IdentityReference.Value] = [ordered]@{
            RegistryRights    = $Access.RegistryRights
            AccessControlType = $Access.AccessControlType
            IdentityReference = $Access.IdentityReference.Value
            IsInherited       = $Access.IsInherited
            InheritanceFlags  = $Access.InheritanceFlags
            PropagationFlags  = $Access.PropagationFlags
        }
    }

    # Track failures
    $Failures = @()

    # Validate SECURITY
    foreach ($Key in $Security.Keys) {

        if (-not $HKLM_SECURITY_ACL.Contains($Key)) {

            $Failures += "HKLM:\SECURITY - Missing required principal: $Key"
            continue
        }

        $Actual = $HKLM_SECURITY_ACL[$Key]
        $Expected = $Security[$Key]

        if ($Actual.AccessControlType -ne $AccessControlType) {
            $Failures += "HKLM:\SECURITY - $Key has AccessControlType '$($Actual.AccessControlType)' instead of '$AccessControlType'."
        }

        if ($Actual.IsInherited) {
            $Failures += "HKLM:\SECURITY - $Key has an inherited permission."
        }

        if ($Actual.RegistryRights.ToString() -ne $Expected.RegistryRights) {
            $Failures += "HKLM:\SECURITY - $Key has '$($Actual.RegistryRights)' instead of '$($Expected.RegistryRights)'."
        }
    }

    # Validate SOFTWARE
    foreach ($Key in $Software.Keys) {

        if (-not $HKLM_SOFTWARE_ACL.Contains($Key)) {

            $Failures += "HKLM:\SOFTWARE - Missing required principal: $Key"
            continue
        }

        $Actual = $HKLM_SOFTWARE_ACL[$Key]
        $Expected = $Software[$Key]

        if ($Actual.AccessControlType -ne $AccessControlType) {
            $Failures += "HKLM:\SOFTWARE - $Key has AccessControlType '$($Actual.AccessControlType)' instead of '$AccessControlType'."
        }

        if ($Actual.IsInherited) {
            $Failures += "HKLM:\SOFTWARE - $Key has an inherited permission."
        }

        if ($Actual.RegistryRights.ToString() -ne $Expected.RegistryRights) {
            $Failures += "HKLM:\SOFTWARE - $Key has '$($Actual.RegistryRights)' instead of '$($Expected.RegistryRights)'."
        }
    }

    # Validate SYSTEM
    foreach ($Key in $System.Keys) {

        if (-not $HKLM_SYSTEM_ACL.Contains($Key)) {

            $Failures += "HKLM:\SYSTEM - Missing required principal: $Key"
            continue
        }

        $Actual = $HKLM_SYSTEM_ACL[$Key]
        $Expected = $System[$Key]

        if ($Actual.AccessControlType -ne $AccessControlType) {
            $Failures += "HKLM:\SYSTEM - $Key has AccessControlType '$($Actual.AccessControlType)' instead of '$AccessControlType'."
        }

        if ($Actual.IsInherited) {
            $Failures += "HKLM:\SYSTEM - $Key has an inherited permission."
        }

        if ($Actual.RegistryRights.ToString() -ne $Expected.RegistryRights) {
            $Failures += "HKLM:\SYSTEM - $Key has '$($Actual.RegistryRights)' instead of '$($Expected.RegistryRights)'."
        }
    }

    # Check for unexpected ACEs
    foreach ($Key in $HKLM_SECURITY_ACL.Keys) {

        if (-not $Security.Contains($Key)) {
            $Failures += "HKLM:\SECURITY - Unexpected principal found: $Key"
        }
    }

    foreach ($Key in $HKLM_SOFTWARE_ACL.Keys) {

        if (-not $Software.Contains($Key)) {
            $Failures += "HKLM:\SOFTWARE - Unexpected principal found: $Key"
        }
    }

    foreach ($Key in $HKLM_SYSTEM_ACL.Keys) {

        if (-not $System.Contains($Key)) {
            $Failures += "HKLM:\SYSTEM - Unexpected principal found: $Key"
        }
    }

    # Determine status
    if ($Failures.Count -eq 0) {

        $Status = 'not_a_finding'

        $Comment = @"
Output
‾‾‾‾‾‾
HKLM:\SECURITY
$($HKLM_SECURITY.Access | Out-String)
HKLM:\SOFTWARE
$($HKLM_SOFTWARE.Access | Out-String)
HKLM:\SYSTEM
$($HKLM_SYSTEM.Access | Out-String)
"@
    }
    else {

        $Status = 'open'

        $Comment = @"
Validated $env:COMPUTERNAME registry ACL permissions are NOT configured properly.

Review the Registry Permissions Below:
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

$($Failures -join "`r`n")

HKLM:\SECURITY
$($HKLM_SECURITY.Access | Out-String)
HKLM:\SOFTWARE
$($HKLM_SOFTWARE.Access | Out-String)
HKLM:\SYSTEM
$($HKLM_SYSTEM.Access | Out-String)
"@
    }

    $pwsh_command = @'
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

get-acl HKLM:\SECURITY
get-acl HKLM:\SOFTWARE
get-acl HKLM:\SYSTEM

$HKLM_SECURITY = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    'SECURITY',
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
    [System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl()

$HKLM_SOFTWARE = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    'SOFTWARE',
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
    [System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl()

$HKLM_SYSTEM   = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    'SYSTEM',
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
    [System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl()

$HKLM_SECURITY.Access
$HKLM_SOFTWARE.Access
$HKLM_SYSTEM.Access
'@


    return [ordered]@{
        Status  = $Status
        Comment = @"
Validated $env:COMPUTERNAME registry ACL permissions for compliance.

$pwsh_command

$Comment
"@
    }
}