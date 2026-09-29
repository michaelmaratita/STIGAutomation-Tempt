function Get-V254281 {
    [CmdletBinding()]
    param()

    $RegistryOutput = Get-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\W32time\Parameters" `
        -Name "Type"
    $PolicySetting = Get-GpResultSetting -Setting "Configure Windows NTP Client"
    $NTP_Source = w32tm /query /source
    $Type = w32tm /query /configuration |
    Select-String '^\s*Type:' |
    ForEach-Object { ($_ -split ':', 2)[1].Trim() }

$Type

    $Comment = @"
$($PolicySetting.Comment)

$($RegistryOutput.Comment)

w32tm /query /source
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
NTP Server: $NTP_Source

w32tm /query /configuration
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Type: $Type
"@

    if ({($PolicySetting.Value).contains("Enabled") 
        -and
        ($RegistryOutput.Value).contains("NT5DS")
        }){
        return [ordered]@{
            Status = 'not_a_finding'
            Comment = @"
Validated $($PolicySetting.Setting) is set to $($PolicySetting.Value) and NTP Client is set to $($RegistryOutput.Value)

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