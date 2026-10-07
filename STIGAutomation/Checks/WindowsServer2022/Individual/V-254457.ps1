function Get-V254457 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $ExpectedSetting = Convert-BannerText $Comment.BannerText
    $Comments = Get-STIGComment -Type Server2022
    $RegChecksComment = $Comments.Registry
    $PolicyComment = $Comments.Policy

    $PolicySetting ='Interactive Logon: Message text for users attempting to log on'
    $Policy_BannerText = Get-GpResultSetting `
                            -Setting $PolicySetting `
                            -Comment $PolicyComment
    $Converted_PolicyBannerText = Convert-BannerText $Policy_BannerText.Value
    
    $RegistryPath  = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $RegistryName  = 'LegalNoticeText'
    $Registry_BannerText = Get-RegistryValue `
                            -Path $RegistryPath `
                            -Name $RegistryName `
                            -Comment $RegChecksComment
    $Converted_Registry_BannerText = Convert-BannerText $Registry_BannerText.Value

    $PolicyMatch = $Converted_PolicyBannerText -eq $ExpectedSetting
    $RegistryMatch = $Converted_Registry_BannerText -eq $ExpectedSetting

    $Output = $Comment.Output `
                -replace '{POLICYSETTING}', $Policy_BannerText.Comment `
                -replace '{REGISTRY}', $Registry_BannerText.Comment
    

    if ($PolicyMatch -and $RegistryMatch){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $Output
    }

}