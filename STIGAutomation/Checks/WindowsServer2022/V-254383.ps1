function Get-V254383 {
    [CmdletBinding()]
    param()

    $RegistryOutput = Get-RegistryValue `
        -Path "hklm:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
        -Name "DisableRunAs"
    $PolicySetting = Get-GpResult -Setting "Disallow WinRM from storing RunAs credentials"

    $Comment = @"
$($PolicySetting.Comment)

$($RegistryOutput.Comment)
"@

    if ($RegistryOutput.Value -eq 1){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated Disallow WinRM from storing RunAs credentials is set to 'Enabled'.

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