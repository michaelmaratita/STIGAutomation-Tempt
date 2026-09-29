function Get-DataDrive {
    [CmdletBinding()]
    param()

    $Drive = Get-Volume |
        Where-Object {
            $_.DriveLetter -and
            $_.DriveLetter -ne 'C'
        } |
        Sort-Object DriveLetter |
        Select-Object -First 1

    if ($null -eq $Drive) {
        throw 'Unable to locate a data drive. No drive other than C: was found.'
    }

    return $Drive.DriveLetter
}