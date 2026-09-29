function Get-V254246 {
    [CmdletBinding()]
    param()

    $tpm_output = Get-Tpm

    if (($tpm_output.TpmPresent) -and ($tpm_output.TpmReady)){
        $Status = 'not_a_finding'
        $Comment = "Validated TPM is PRESENT and READY on $env:COMPUTERNAME using Get-Tpm."
    }
    else {
        $Status = 'not_reviewed'
        $Comment = "Validated TPM is NOT present on $env:COMPUTERNAME using Get-Tpm."
    }

    return [ordered]@{
        Status = $Status
        Comment = @"
$Comment

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-TPM

Output
‾‾‾‾‾‾
$($tpm_output | Out-String)
"@
    }
}