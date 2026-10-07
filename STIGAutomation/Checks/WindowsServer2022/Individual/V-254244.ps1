function Get-V254244 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $HasServiceAccount = @(
        'MS-01'
    )

    if ($env:COMPUTERNAME -in $HasServiceAccount){

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME

    } else {

        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable `
                    -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                    
    }

    return [ordered]@{
        Status  = $Status 
        Comment = $CommentText
    }    
}