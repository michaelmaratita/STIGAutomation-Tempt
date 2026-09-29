function Export-STIGChecklist {
    param(
        [Parameter(Mandatory)]
        $Checklist
    )

    $Path = $script:STIGAutomation.CompletedChecklistPath

    $Checklist | 
    ConvertTo-Json -Depth 4 -WarningAction SilentlyContinue | 
    Out-File -Path "$Path\$($env:COMPUTERNAME)_Windows_Server_2022_STIG_Checklist.cklb"

}

