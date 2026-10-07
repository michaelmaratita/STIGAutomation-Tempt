function Get-V254246 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $tpm_output = Get-Tpm

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{TPM}', $($tpm_output | Out-String)

    if (($tpm_output.TpmPresent) -and ($tpm_output.TpmReady)){
        
        $Status = 'not_a_finding'
        $CommentText = (
                        $Comment.NotAFinding `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                            ) 

    } else {

        $Status = 'open'
        $CommentText = (
                        $Comment.Open `
                            -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                        ) 

    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}