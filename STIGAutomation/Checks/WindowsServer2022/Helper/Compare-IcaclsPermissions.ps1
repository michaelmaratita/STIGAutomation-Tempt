function Compare-IcaclsPermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$AclChecks,

        [Parameter(Mandatory)]
        [hashtable]$Comment
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

        $PathComment = $Comment.Path `
                        -replace '{PATH}', $Path `
                        -replace '{ACTUAL}', $($Actual -join "`n")

        if (
            $Missing.Count -eq 0 `
            -and
            $Unexpected.Count -eq 0
        ) {

            $Status      = 'not_a_finding'
            $CommentText = $Comment.NotAFinding `
                            -replace '{PATH}', $Path

        }
        else {

            $Status      = 'open'
            $CommentText = $Comment.Open `
                            -replace '{PATH}', $Path `
                            -replace '{MISSiNG}', $($Missing -join "`n") `
                            -replace '{UNEXPECTED}', $($Unexpected -join "`n")
        }

        [ordered]@{
            Path       = $Path
            Status     = $Status
            Value      = $Actual
            Missing    = $Missing
            Unexpected = $Unexpected
            Comment    = $CommentText + $PathComment
            # Comment    = @"
# Path: $Path

# icacls $Path
# $($Actual -join "`n")

# $(if ($Status -eq 'open') {
# @"
# Please review Folder permissions for $Path.

# Missing:
# $($Missing -join "`n")

# Unexpected:
# $($Unexpected -join "`n")
# "@
# }
# else {
#     "Folder permissions for $Path match the expected configuration."
# })
# "@
        }
    }

    $Pass = if ($Results.Status -contains 'open') {
        $false
    }
    else {
        $true
    }

    # $Comment = $Results.Comment -join "`n`n‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n"

    # Write-Host $Results.Comment

    return [ordered]@{
        Pass    = $Pass
        Value   = $Results
        Comment = $Results.Comment
    }
}