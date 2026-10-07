function Invoke-IcaclsChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )


    $DataPath = "$PSScriptRoot\..\Data\icaclsChecks.psd1" 

    $AclData = Import-PowerShellDataFile -Path $DataPath
    $Comments = Get-STIGComment -Type Server2022
    $PolicyComment = $Comments.Policy

    $PolicySetting = Get-GpResultSetting `
        -Setting 'Network access: Let Everyone permissions apply to anonymous users' `
        -Comment $PolicyComment

    foreach ($VulNum in $VulNums){
        $AclChecks = $AclData[$VulNum]

        $Checks = Compare-IcaclsPermissions `
                    -AclChecks $AclChecks `
                    -Comment $Comment.Compare

        if (
        $PolicySetting.Value -contains 'Disabled' -and
        $Checks.Pass
        ){
            $Status = 'not_a_finding'
            
#             $Results[$VulNum] = [ordered]@{
#                 Status = $Checks.Status
#                 Comment = @"
# $($PolicySetting.Comment)
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# $($Checks.Comment)
# "@
#             }
        } else {
            # $Results[$VulNum] = [ordered]@{
            $Status = 'open'
#             Comment = @"
# $($PolicySetting.Comment)
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# $($Checks.Comment)
# "@
            # }
        }

        $CommentText = $Comment.Output `
                        -replace '{POLICYSETTING}', $PolicySetting.Comment `
                        -replace '{CHECKS}', $Checks.Comment

        $Results[$VulNum] = [ordered]@{
            Status  = $Status
            Comment = $CommentText
        }
    }

    return $Results
}