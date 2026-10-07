function Invoke-FtpChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums,

        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $FTP = Get-WindowsFeature `
        -Name Web-Ftp-Server, 
              Web-Ftp-Service, 
              Web-Ftp-Ext | 
        Select-Object DisplayName, 
                      Name, 
                      Installed
    
    $FPTInstalled = $FTP.Installed -contains $true

    if($FPTInstalled){
        $Status = 'open'
        $CommentText = $Comment.Open
    }
    else {
        $Status = 'not_applicable'
        $CommentText = $Comment.NotApplicable
    }

    $CommentText= $CommentText-replace '{COMPUTERNAME}', $env:COMPUTERNAME
    $PowerShellCommand = $Comment.PowerShellCommand -replace '{OUTPUT}', $FTP | Format-List | Out-String

    foreach ($VulNum in $VulNums){
        $Results[$VulNum] = [ordered]@{
            Status  = $Status 
            Comment = $CommentText + $PowerShellCommand
        } 
    }

    return $Results

}

