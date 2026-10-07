function Get-RegistryValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Comment
    )

    $Key = Get-Item -Path $Path
    $Value = $Key.GetValue($Name)
    $Type = $Key.GetValueKind($Name)

    $CommentText = $Comment `
                    -replace '{PATH}', $Path `
                    -replace '{NAME}', $Name `
                    -replace '{VALUE}', $Value `
                    -replace '{TYPE}', $Type

    return [ordered]@{
        Value = $Value
        Comment = $CommentText

    }

}