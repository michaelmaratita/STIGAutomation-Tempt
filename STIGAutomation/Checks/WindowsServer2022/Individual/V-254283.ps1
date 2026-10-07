function Get-V254283 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Comment
    )

    $Comment = $Comment `
                -replace  '{COMPUTERNAME}', $env:COMPUTERNAME `
                -replace '{FIRMWARETYPE}', $env:firmware_type

    if ($env:firmware_type -eq 'UEFI'){

        $Status  = 'not_a_finding'

    } else {

        $Status  = 'open'

    }

    return [ordered]@{
        Status  = $Status
        Comment = $Comment
    }
}