function Compare-GpResultValues {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConfiguredValue,

        [Parameter(Mandatory)]
        [string[]]$ExpectedSetting
    )

    $ConfiguredValues = @(
        $ConfiguredValue -split ',' |
            ForEach-Object {
                $_.Trim()
            }
    )

    $MissingValues = @(
        $ExpectedSetting | Where-Object {
            $_ -notin $ConfiguredValues
        }
    )

    return $MissingValues

}