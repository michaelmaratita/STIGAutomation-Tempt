function Get-V254255 {
    [CmdletBinding()]
    param()

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
        $Comment = @"
No printers are configured on $env:COMPUTERNAME.
"@
    }
    else {
        $Status = 'open'
        $Comment = @"
Validated that printers are configured on $env:COMPUTERNAME. Please verify the printers that are configured.
"@
    }

    $pwsh_command = @"
Microsoft Print to PDF and Microsoft XPS Document Writer or any variation of those, e.g (redirected 2), are excluded from this check.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Printer | Select-Object Name 

Output
‾‾‾‾‾‾‾
$(Get-Printer | Select-Object Name | Out-String)
"@

    return [ordered]@{
        Status  = $Status
        Comment = @"
$Comment
$pwsh_command
"@
    }

}