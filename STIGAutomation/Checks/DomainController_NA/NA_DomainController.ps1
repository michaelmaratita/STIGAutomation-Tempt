function Set-DomainControllerChecksNA {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [string]$Comment
    )

    $AD = Get-WindowsFeature `
        -Name AD-Domain-Services | 
        Select-Object DisplayName, 
                      Name, 
                      Installed

    $Comment = $Comment `
                -replace '{COMPUTERNAME}', $env:COMPUTERNAME`
                -replace '{ActiveDirectory}', "$($AD | Format-List | Out-String)"

    foreach ($VulNum in $VulNums) {

        $Results[$VulNum] = [ordered]@{
            Status  = "not_applicable"
            Comment = $Comment
        }
    }

    return $Results
}