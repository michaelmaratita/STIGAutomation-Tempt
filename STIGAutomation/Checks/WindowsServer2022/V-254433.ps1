function Get-V254433 {
    [CmdletBinding()]
    param()

    $RegistryOutput = Get-RegistryValue `
        -Path "hklm:\SYSTEM\CurrentControlSet\Control\Lsa" `
        -Name "RestrictRemoteSAM"
    $PolicySetting = Get-GpResult -Setting "Network access: Restrict clients allowed to make remote calls to SAM"

    $Comment = @"
$($PolicySetting.Comment)

$($RegistryOutput.Comment)
"@

    if ($RegistryOutput.Value -eq 'O:BAG:BAD:(A;;RC;;;BA)'){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated Network access: Restrict clients allowed to make remote calls to SAM is defined and set to 'O:BAG:BAD:(A;;RC;;;BA)'.

$Comment
"@
        }
    } else {
        return [ordered]@{
            Status = 'open'
            Comment = $Comment
        }
    }   
}