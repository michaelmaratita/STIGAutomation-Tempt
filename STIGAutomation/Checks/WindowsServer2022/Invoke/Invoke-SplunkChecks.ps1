function Invoke-SplunkChecks {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $Splunk = Get-Service 'SplunkForwarder' `
        -ErrorAction SilentlyContinue |
        Select-Object Name, 
                      DisplayName, 
                      Status

     if ($Splunk.Status -eq 'Running'){
        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding
     }
     else {
        $Status  = 'open'
        $CommentText = $Comment.Open
     }

     $CommentText= $CommentText-replace '{COMPUTERNAME}', $env:COMPUTERNAME
     $PowerShellCommand = $Comment.PowerShellCommand -replace '{OUTPUT}', "$($Splunk | Format-List | Out-String)"
    
    foreach ($VulNum in $VulNums){
        $Results[$VulNum] = [ordered]@{
            Status  = $Status
            Comment = $CommentText + $PowerShellCommand
        }
    }
    return $Results
}