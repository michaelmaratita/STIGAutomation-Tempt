function Invoke-FtpChecks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )
    
    $FTP_Features = Get-WindowsFeature `
        -Name Web-Ftp-Server, 
              Web-Ftp-Service, 
              Web-Ftp-Ext | 
        Select-Object DisplayName, 
                      Name, 
                      Installed
    $pwsh_command = @"
PowerShell Cmd:
Get-WindowsFeature ``
        -Name Web-Ftp-Server, 
              Web-Ftp-Service, 
              Web-Ftp-Ext | 
        Select-Object DisplayName, 
                      Name, 
                      Installed

Output:
$(Get-WindowsFeature `
        -Name Web-Ftp-Server, 
              Web-Ftp-Service, 
              Web-Ftp-Ext | 
        Select-Object DisplayName, 
                      Name, 
                      Installed | 
        Out-String)
"@

    foreach ($feature in $FTP_Features) {

        if ($feature.installed){
            
            foreach ($VulNum in $VulNums){
                $Results[$VulNum] = [ordered]@{
                Status = "open"
                Comment = @"
Validated FTP is installed on $env:ComputerName. Please validate the additional settings in the check text.

$pwsh_command
"@
                } 
            }
        } else {
            foreach ($VulNum in $VulNums){
                $Results[$VulNum] = [ordered]@{
                Status = "not_applicable"
                Comment = @"
Validated FTP is NOT installed on $env:ComputerName.

$pwsh_command
"@
                }
            }
        }
    }

    return $Results
}

