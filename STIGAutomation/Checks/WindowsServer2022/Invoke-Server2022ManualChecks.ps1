function Invoke-Server2022ManualChecks {
    [CmdletBinding()]
    param()

    $Results = [ordered]@{}

    $ManualChecks = Import-PowerShellDataFile `
        -Path "$PSScriptRoot\..\..\Data\ManualChecks.psd1" 

    foreach ($VulNumber in $ManualChecks.OS.Checks){
        
        $FunctionName = "Get-$($VulNumber -replace '-', '')"

        $Results[$VulNumber] = & $FunctionName

    }

    $Results = Set-DomainControllerChecksNA `
        -Results $Results `
        -VulNums $ManualChecks.OS.DomainControllerChecks

    $Results = Invoke-FtpChecks `
        -Results $Results `
        -VulNums $ManualChecks.OS.FtpChecks

    $Results = Invoke-SplunkChecks `
        -Results $Results `
        -VulNums $ManualChecks.OS.SplunkChecks

    $Results = Invoke-IcaclsChecks `
        -Results $Results `
        -VulNums $ManualChecks.OS.icaclsChecks

    $Results = Invoke-PolicyChecks `
        -Results $Results `
        -VulNums $ManualChecks.OS.PolicyOnlyChecks

    $Results = Invoke-PolicyAndRegistryChecks `
        -Results $Results `
        -VulNums $ManualChecks.OS.PolicyAndRegistryChecks

    return $Results
}