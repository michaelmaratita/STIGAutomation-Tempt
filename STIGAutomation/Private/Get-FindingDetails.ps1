function Get-FindingDetails {
    [CmdletBinding()]
    param()

    try {
        $UserName = (Get-ADUser $env:USERNAME -ErrorAction Stop).Name
    }
    catch {
        $UserName = $env:USERNAME
    }

    $Date = Get-Date -Format yyyy-MM-dd

    return [ordered]@{
        not_a_finding = "On $Date, $UserName manually verified $env:COMPUTERNAME is compliant with this check. THIS IS NOT A FINDING."
        open           = "On $Date, $UserName manually verified $env:COMPUTERNAME is NOT compliant with this check. THIS IS A FINDING."
        not_applicable = "On $Date, $UserName manually verified this check does not apply to $env:COMPUTERNAME. THIS IS NOT APPLICABLE."
        not_reviewed   = "On $Date, This check needs to be validated."
    }
}