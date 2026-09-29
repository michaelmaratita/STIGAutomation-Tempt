function Get-V254244 {
    [CmdletBinding()]
    param()

    $svr_w_svc_account = @(
        'MS-01'
    )

    if ($env:COMPUTERNAME -in $svr_w_svc_account){
        return [ordered]@{
        Status = 'not_a_finding'
        Comment = @"
$env:COMPUTERNAME utilizes a shared account. Any shared account utlized is documented with
the Information System Security Officer (ISSO) via the E-Commerce Operational System
Support (EOSS) GovCloud Amazon Web Services (AWS) Server Access Form (SAF).

EOSS AWS SAF includes General and Specific DHA Rules of Behavior acknowledgement
prior to granting access.

All auditing account activity is configured via Group Policy.
"@
    }
    }
    
    return [ordered]@{
        Status = 'not_applicable'
        Comment = @"
$env:COMPUTERNAME does not utilize shared accounts.
"@
    }
}