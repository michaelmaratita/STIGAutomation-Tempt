function Get-V254262 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Comment
    )

    $CommentText = $Comment -replace '{COMPUTERNAME}', $env:COMPUTERNAME
   
    return [ordered]@{
        Status = 'not_a_finding'
        Comment = $CommentText
    }
}