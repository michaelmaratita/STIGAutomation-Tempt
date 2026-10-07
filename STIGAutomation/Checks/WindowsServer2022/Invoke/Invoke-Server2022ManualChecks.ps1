function Invoke-Server2022ManualChecks {
    [CmdletBinding()]
    param()

    $Results = [ordered]@{}

    $ManualChecks = Get-ManualChecks -Type Server2022
    $Comment = Get-STIGComment -Type Server2022
    
    foreach ($VulNumber in $ManualChecks.IndividualChecks){
        
        $FunctionName = "Get-$($VulNumber -replace '-', '')"

        $Results[$VulNumber] = & $FunctionName -Comment $Comment.$($VulNumber -replace '-', '')

    }

    $Results = Invoke-FtpChecks `
        -Results $Results `
        -VulNums $ManualChecks.FtpChecks `
        -Comment $Comment.FTP
    
    $Results = Invoke-IcaclsChecks `
        -Results $Results `
        -VulNums $ManualChecks.icaclsChecks `
        -Comment $Comment.icacls

    $Results = Invoke-PolicyChecks `
        -Results $Results `
        -VulNums $ManualChecks.PolicyOnlyChecks `
        -Comment $Comment.Policy

    $Results = Invoke-PolicyAndRegistryChecks `
        -Results $Results `
        -VulNums $ManualChecks.PolicyAndRegistryChecks `
        -Comment $Comment

    $Results = Invoke-SplunkChecks `
        -Results $Results `
        -VulNums $ManualChecks.SplunkChecks `
        -Comment $Comment.Splunk

    $Results = Set-DomainControllerChecksNA `
        -Results $Results `
        -VulNums $ManualChecks.DomainControllerChecks `
        -Comment $Comment.DomainController

    return $Results
}