function Get-V254263 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Comment
    )
    
    return [ordered]@{
        Status  = 'open'
        Comment = $Comment 
    }
}