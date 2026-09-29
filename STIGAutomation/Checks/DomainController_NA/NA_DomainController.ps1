function Set-DomainControllerChecksNA {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )

    $AD = get-windowsfeature `
            -Name AD-Domain-Services | 
                Select-Object DisplayName, `
                              Name, `
                            Installed
    foreach ($VulNum in $VulNums) {

        $Results[$VulNum] = [ordered]@{
            Status  = "not_applicable"
            Comment = @"
$env:ComputerName is NOT a Domain Controller.

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($AD | Format-List | Out-String)
"@
        }
    }

    return $Results
}