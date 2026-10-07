function Compare-Acl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [System.Security.AccessControl.AuthorizationRuleCollection]$ConfiguredAcl,

        [Parameter(Mandatory)]
        [hashtable]$ExpectedAcl,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    # Track failures
    $Failures = @()

    # Validate PATH {SECURITY, SOFTWARE, SYSTEM}
    foreach ($Key in $ExpectedAcl.Keys){

        $Configured = $ConfiguredAcl | Where-Object IdentityReference -eq $Key
        
        if (-not $ConfiguredAcl.IdentityReference.Value.Contains($Key)){

            $Failures += $Comment.MissingPrincipal `
                         -replace '{PATH}', $Path `
                         -replace '{KEY}', $Key

            continue
        }

        if ($Configured.AccessControlType -ne 'Allow'){

            $Failures += $Comment.AccessControlType `
                          -replace '{PATH}', $Path `
                          -replace '{KEY}', $Key `
                          -replace '{ACCESSCONTROLTYPE}', $($Configured.AccessControlType.ToString())
        }

        if ($Configured.IsInherited){

            $Failures += $Comment.Inherited `
                          -replace '{PATH}', $Path `
                          -replace '{KEY}', $Key 
        }

        if ($Configured.RegistryRights.ToString() -ne $ExpectedAcl.$Key.RegistryRights){

            $Failures += $Comment.Comparison `
                          -replace '{PATH}', $Path `
                          -replace '{KEY}', $Key `
                          -replace '{ACTUAL}', $($Configured.RegistryRights.ToString()) `
                          -replace '{EXPECTED}', $($Key.RegistryRights)
        }
    }

    # Check for unexpected ACEs
    foreach ($Key in $ConfiguredAcl.Keys) {

        if (-not $Security.Contains($Key)) {
            $Failures += $Comment.Unexpected `
                          -replace '{PATH}', $Path `
                          -replace '{KEY}', $Key
        }
    }

    return $Failures
}