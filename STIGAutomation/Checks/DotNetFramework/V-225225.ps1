function Get-V225225 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $CasPolOutput = .\caspol.exe -m -lg
    $CasPolText = $CasPolOutput -join [Environment]::NewLine

    $Exists = $CasPolOutput -match '^\s*1\.6\.'

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $CasPolText

    if ($Exists){

        $Status = 'open'
        $CommentText = $Comment.Open `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
    
    } else {

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}