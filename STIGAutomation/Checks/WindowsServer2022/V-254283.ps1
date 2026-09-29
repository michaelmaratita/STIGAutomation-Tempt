function Get-V254283 {
    [CmdletBinding()]
    param()

    $Comment = @"
$($env:COMPUTERNAME) utilizes $($env:firmware_type). 

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$env:firmware_type

Output
‾‾‾‾‾‾
$($env:firmware_type)
"@
    if ($env:firmware_type -eq 'UEFI'){
        return [ordered]@{
            Status  = 'not_a_finding'
            Comment = $Comment
        }
    }

    return [ordered]@{
        Status  = 'open'
        Comment = $Comment
    }
}