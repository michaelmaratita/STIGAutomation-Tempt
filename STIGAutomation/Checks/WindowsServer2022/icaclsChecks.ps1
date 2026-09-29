function Invoke-IcaclsChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )


    $DataPath = "$PSScriptRoot\..\..\Data\icaclsChecks.psd1" 

    $AclData = Import-PowerShellDataFile -Path $DataPath

    $PolicySetting = Get-GpResultSetting `
        -Setting 'Network access: Let Everyone permissions apply to anonymous users'


    foreach ($VulNum in $VulNums){
        $AclChecks = $AclData[$VulNum]

        $icacls = Compare-IcaclsPermissions -AclChecks $AclChecks

        if (
        $PolicySetting.Value -contains 'Disabled' -and
        $icacls.Status -eq 'not_a_finding'
        ){
            $Results[$VulNum] = [ordered]@{
                Status = $icacls.Status
                Comment = @"
$($PolicySetting.Comment)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($icacls.Comment)
"@
            }
        }
        else {
            $Results[$VulNum] = [ordered]@{
            Status = 'open'
            Comment = @"
$($PolicySetting.Comment)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$($icacls.Comment)
"@
            }
        }
    }

    return $Results
}