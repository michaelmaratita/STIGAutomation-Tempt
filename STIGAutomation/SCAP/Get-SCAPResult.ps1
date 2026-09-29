function Get-SCAPResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [xml]$XML
    )

    $SCAPResults = [ordered]@{}

    foreach ($Vulnerability in $XML.ChildNodes.TestResult.'rule-result') {

        $RuleID = $Vulnerability.idref

        # Preserve your existing ID extraction logic.
        $RuleID = $RuleID.Substring(15, 31).Substring(10, 21)

        $SCAPResults[$RuleID] = [ordered]@{
            Result = [string]$Vulnerability.result
        }
    }

    return $SCAPResults
}