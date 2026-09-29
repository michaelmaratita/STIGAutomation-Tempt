function Get-V254428 {
    [CmdletBinding()]
    param()

    $DataPath         = "$PSScriptRoot\..\..\Data\AdminGroups.psd1"
    $Data             = Import-PowerShellDataFile -Path $DataPath

    $App              = $Data.Server[$env:COMPUTERNAME]
    $AuthorizedGroups    = $Data.AuthorizedGroups[$App]
    $AdministratorsGroups = Get-LocalGroupMember -Group Administrators | Select-Object Name, SID

    $AdministratorsGroups = $AdministratorsGroups | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$'
    }

    $pwsh_cmd = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalGroupMember -Group Administrators

Output
‾‾‾‾‾‾
$(Get-LocalGroupMember -Group Administrators |
Select-Object Name, PrincipalSource |
Format-List |
Out-String
)
"@

    $UnauthorizedGroup = @()

    foreach ($Group in $AdministratorsGroups.Name){
        if ($Group -notin $AuthorizedGroups){
            $UnauthorizedGroup += $Group
        }
    }

    if ($UnauthorizedGroup.Count -eq 0){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = @"
The following groups within the Local Administrators groups are authorized and required.
The Server Access Form (SAF) documents server access for each group. Each individual user
assigned to the identified groups are documented with the ISSO.

$($Data.Comment[$App])

NOTE: The renamed Local Administrator account is exempt from this check.

$pwsh_cmd
"@
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = @"
($($UnauthorizedGroup.Count)) unauthorized group(s) have been identified. Please validated the group and users are authorized
access and documented with the ISSO.

Unauthorized Group(s)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($UnauthorizedGroup)

Update the AdminGroups.psd1 if authorized or remove the identified groups to clear this check.
AdminGroups.psd1 is located at $($DataPath).

$pwsh_cmd
"@
    }


}