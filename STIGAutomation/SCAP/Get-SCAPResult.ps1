function Get-SCAPResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [xml]$XML,

        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $STIGData = Get-STIGSettings -Type $Type
    $RuleResults = $XML
    $Substring = $STIGData.Substring

    foreach ($Property in $STIGData.RuleResult) {
        
        $RuleResults = $RuleResults.$Property

    }

    $SCAPResults = [ordered]@{}

    # foreach ($Vulnerability in $XML.ChildNodes.TestResult.'rule-result') {
    foreach ($Result in $RuleResults){

        $RuleID = $Result.idref.Substring($Substring)

        $SCAPResults[$RuleID] = [ordered]@{
            Result = [string]$Result.result
        }
    }

    return $SCAPResults
}