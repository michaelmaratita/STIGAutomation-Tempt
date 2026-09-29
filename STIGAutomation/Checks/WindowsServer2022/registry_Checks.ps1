function Get-RegistryValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Name
    )

    $Key = Get-Item -Path $Path
    $Value = $Key.GetValue($Name)
    $Type = $Key.GetValueKind($Name)

    # $value = Get-ItemPropertyValue -Path $Path -Name $Name

    return [ordered]@{
        Value = $Value
        Comment = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key = Get-Item -Path '$Path'

Registry Type Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key.GetValueKind('$Name')

> $Type

Registry Value Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key.GetValue('$Name')

> $Value
"@
    }

}