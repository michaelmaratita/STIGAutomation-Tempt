function Invoke-PolicyChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $DataPath = "$PSScriptRoot\..\Data\PolicyOnlyChecks.psd1"
    $DataFile = Import-PowerShellDataFile -Path $DataPath

    foreach ($VulNum in $VulNums) {

        $Data = $DataFile[$VulNum]

        $ExpectedSetting = foreach ($Setting in @($Data.ExpectedSetting)) {
            $Setting `
                -replace '{USERDOMAIN}', $env:USERDOMAIN
        }

        $PolicyParamSettings = New-PolicyParamSetting -Data $Data
        $PolicySetting = Get-GpResultSetting @PolicyParamSettings -Comment $Comment

        $MissingValues = Compare-GpResultValues `
            -ConfiguredValue $PolicySetting.Value `
            -ExpectedSetting $ExpectedSetting

        # GPO evidence comment
        $PolicyComment = $PolicySetting.Comment

        if ($MissingValues.Count -eq 0) {

            $CommentText = $Comment.NotAFinding -replace '{COMPUTERNAME}', $env:COMPUTERNAME
            
            $Results[$VulNum] = [ordered]@{
                Status = 'not_a_finding'
                Comment = $CommentText + $PolicyComment
            }
        }
        else {

            $MissingComment = $Comment.Missing `
                                -replace '{POLICYSETTING}', $Data.PolicySetting `
                                -replace '{MISSING}', $MissingValues -join "`n"
            
            $CommentText = $Comment.Open `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME `
                            -replace '{IF}', $MissingComment

            $Results[$VulNum] = [ordered]@{
                Status = 'open'
                Comment = $CommentText + $PolicyComment

            }
        }
    }

    return $Results
}