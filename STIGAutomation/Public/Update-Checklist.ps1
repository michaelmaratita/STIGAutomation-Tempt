function Update-Checklist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Checklist,

        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )
    
    $STIGData = Get-STIGSettings -Type $Type
    $Function = $STIGData.Function

    $Results = & $Function
    $FindingDetails = Get-FindingDetails

    foreach ($Vulnerability in $Checklist.stigs.rules){

        $VulnerabilityID = $Vulnerability.group_id
        if ($Results.Contains($VulnerabilityID)){

            # Used to TroubleShoot Vulnerability Iterations
            # Write-Host $Results[$VulnerabilityID].Status
            # Write-Host $Results[$VulnerabilityID].Comment
            # Write-Host $FindingDetails[$Results[$VulnerabilityID].Status]
            
            $Vulnerability.status = 
                $Results[$VulnerabilityID].Status
            
            $Vulnerability.comments = 
                $Results[$VulnerabilityID].Comment
            
            $Vulnerability.finding_details = $FindingDetails[$Results[$VulnerabilityID].Status]
        }

    }
    return $Checklist

}