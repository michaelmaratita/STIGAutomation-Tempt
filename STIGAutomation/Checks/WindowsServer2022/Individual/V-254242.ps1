function Get-V254242 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $PwPolicy= Get-ADDefaultDomainPasswordPolicy
    
    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $($PwPolicy | Out-String)

    if ($PwPolicy.MinPasswordLength -ge 14){
        
        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{POLICYSETTING}', $PwPolicy.MinPasswordLength

    } else {

        $Status = 'open'
        $CommentText = $Comment.Open
        
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}