function Invoke-DotNetFrameworkManualChecks {
    [CmdletBinding()]
    param()

    $Results = [ordered]@{}

    $ManualChecks = Get-ManualChecks -Type DotNetFramework
    $Comment = Get-STIGComment -Type DotNetFramework
    
    foreach ($VulNumber in $ManualChecks.IndividualChecks){
        
        $FunctionName = "Get-$($VulNumber -replace '-', '')"

        $Results[$VulNumber] = & $FunctionName -Comment $Comment.$($VulNumber -replace '-', '')

    }

    return $Results
}