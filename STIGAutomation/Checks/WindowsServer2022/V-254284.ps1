function Get-V254284 {
    [CmdletBinding()]
    param()

    $Comment = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Confirm-SecureBootUEFI

Output
‾‾‾‾‾‾
$(Confirm-SecureBootUEFI | Out-String)
"@
    if (Confirm-SecureBootUEFI){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = @"
Validated $($env:COMPUTERNAME) utilizes $($env:firmware_type) with SecureBoot enabled.

$Comment
"@
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = @"
Settings need to be validated for $($env:COMPUTERNAME)

$Comment
"@
    }
}