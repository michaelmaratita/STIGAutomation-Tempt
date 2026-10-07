function Get-V254255 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $ExcludedPrinterPattern = '^(Microsoft Print to PDF|Microsoft XPS Document Writer)(?: \((?:\d+|redirected \d+)\))?$'

    $Printers = @(Get-Printer | Select-Object -ExpandProperty Name)

    # Exclude Microsoft Print to PDF and Microsoft XPS Document Writer
    $ConfiguredPrinters = @(
        $Printers | Where-Object {
            $_ -notmatch $ExcludedPrinterPattern
        }
    )

    if ($ConfiguredPrinters.Count -eq 0) {
        
        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                          -replace '{OUTPUT}', (Get-Printer).Name

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }

}