function Invoke-SplunkChecks {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Results,

        [Parameter(Mandatory)]
        [string[]]$VulNums
    )

    $Comment = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service SplunkForwarder
"@

    foreach ($VulNum in $VulNums){
        try {
            $Splunk = Get-Service 'SplunkForwarder' -ErrorAction Stop |
                Select-Object Name, DisplayName, Status

            if ($Splunk.Status -eq 'Running'){
                $Results[$VulNum] = [ordered]@{
                    Status  = 'not_a_finding'
                    Comment = @"
Windows Event and Audit Logs for $($env:COMPUTERNAME)are off-loaded to a different system via the SplunkForwarder service.
These are off-loaded in real-time to prevent accidental loss or deletion.

$Comment

Output
‾‾‾‾‾‾
$($Splunk | Out-String)
"@
                }
            }
            $Results[$VulNum] = [ordered]@{
                Status  = 'open'
                Comment = @"
SplunkForwarder service is installed, but NOT RUNNING on $($env:COMPUTERNAME).

$Comment

Output
‾‾‾‾‾‾
$($Splunk | Out-String)
"@
                
            }
        } catch {
            $Results[$VulNum] = [ordered]@{
                Status  = 'open'
                Comment = @"
SplunkForwarder service is NOT INSTALLED on $($env:COMPUTERNAME).

$Comment
"@
            }
        }
    }
    return $Results
}