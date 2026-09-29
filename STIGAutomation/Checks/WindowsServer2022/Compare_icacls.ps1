function Compare-IcaclsPermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$AclChecks
    )

    $Results = foreach ($Item in $AclChecks.GetEnumerator()) {

        $Path     = $Item.Key
        $Expected = $Item.Value

        $Actual = icacls $Path |
            ForEach-Object {

                $Line = $_.Trim()

                # The first ACL entry appears on the same line as the path
                if ($Line -match "^$([regex]::Escape($Path))\s+(.*)$") {
                    $Line = $Matches[1]
                }

                if ($Line -match '.*:\(') {
                    $Line
                }
            }

        $Actual = @($Actual)

        $Missing = @(
            $Expected | Where-Object {
                $_ -notin $Actual
            }
        )

        $Unexpected = @(
            $Actual | Where-Object {
                $_ -notin $Expected
            }
        )

        $Status = if (
            $Missing.Count -eq 0 -and
            $Unexpected.Count -eq 0
        ) {
            'not_a_finding'
        }
        else {
            'open'
        }

        [ordered]@{
            Path       = $Path
            Status     = $Status
            Value      = $Actual
            Missing    = $Missing
            Unexpected = $Unexpected
            Comment    = @"
Path: $Path

icacls $Path
$($Actual -join "`n")

$(if ($Status -eq 'open') {
@"
Please review Folder permissions for $Path.

Missing:
$($Missing -join "`n")

Unexpected:
$($Unexpected -join "`n")
"@
}
else {
    "Folder permissions for $Path match the expected configuration."
})
"@
        }
    }

    $OverallStatus = if ($Results.Status -contains 'open') {
        'open'
    }
    else {
        'not_a_finding'
    }

    $Comment = $Results.Comment -join "`n`n‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n"

    return [ordered]@{
        Status  = $OverallStatus
        Value   = $Results
        Comment = $Comment
    }
}