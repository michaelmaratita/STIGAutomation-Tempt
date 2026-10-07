function Update-ChecklistSCAPResults {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Checklist,

        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    try {
        $UserName = (Get-ADUser $env:USERNAME -ErrorAction Stop).Name
    }
    catch {
        $UserName = $env:USERNAME
    }

    Write-Verbose 'Updating checklist with SCAP results.'
    
    $SCAPInfo = Get-XCCDF_Info -Type $Type

    $SCAPTool = $SCAPInfo.XCCDF.ChildNodes.TestResult.'test-system'
    $SCAPTime = $SCAPInfo.XCCDF.ChildNodes.TestResult.'end-time'

    $Checklist.target_data.host_name       = $SCAPInfo.Name
    $Checklist.target_data.fqdn            = $SCAPInfo.FQDN
    $Checklist.target_data.ip_address      = $SCAPInfo.IP
    $Checklist.target_data.mac_address     = $SCAPInfo.MAC
    $Checklist.target_data.role            = 'Member Server'
    $Checklist.target_data.technology_area = 'Windows OS'

    $StatusMap = @{
        pass = @{
            Status  = 'not_a_finding'
            Comment = 'THIS IS NOT A FINDING.'
        }

        fail = @{
            Status  = 'open'
            Comment = 'THIS IS A FINDING.'
        }

        not_applicable = @{
            Status  = 'not_applicable'
            Comment = 'THIS IS NOT APPLICABLE.'
        }
    }

    foreach ($Rule in $Checklist.stigs.rules) {

        # rule_id_src example: SV-225225r961038_rule
        $RuleID = [string]$Rule.rule_id_src

        if ($SCAPInfo.SCAP_Results.Contains($RuleID)) {

            $Result = [string]$SCAPInfo.SCAP_Results[$RuleID].Result

            if ($StatusMap.ContainsKey($Result)) {

                $Rule.status = $StatusMap[$Result].Status

                $Rule.finding_details = @"
Tool: $SCAPTool
Time: $SCAPTime
Result: $Result
"@

                $Rule.comments = (
                    "$UserName completed a SCAP Scan on $SCAPTime " +
                    "and the result was '$Result'. " +
                    $StatusMap[$Result].Comment
                )
            }
        }
    }

    return $Checklist
}