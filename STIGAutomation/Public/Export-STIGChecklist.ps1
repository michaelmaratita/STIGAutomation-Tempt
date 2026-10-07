function Export-STIGChecklist {
    param(
        [Parameter(Mandatory)]
        $Checklist,

        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $Path = $script:STIGAutomation.CompletedChecklistPath

    $ChecklistName = @{
        Server2022 = "$($env:COMPUTERNAME)_MS_Windows_Server_2022_STIG_Checklist.cklb"
        DotNetFramework = "$($env:COMPUTERNAME)_MS_DotNet_Framework_STIG_Checklist.cklb"

    }

    $Checklist | 
    ConvertTo-Json -Depth 5 -WarningAction SilentlyContinue | 
    Out-File -Path "$Path\$($ChecklistName[$Type])"

}

# Depth 4 works as intended for Windows OS 2022