@{
    V225225 = @{

        PowerShellCommand = @"
CMD
‾‾‾‾
C:\Windows\Microsoft.NET\Framework\v4.0.30319\caspol.exe -m -lg

{OUTPUT}
"@

        NotAFinding = @"
CASPol machine-level policy was reviewed and code group 1.6 (Publisher Membership Condition) is not configured on {COMPUTERNAME}. Therefore, no Publisher Membership Condition is being used and no publisher certificate approval is required.`n`n
"@

        Open = @"
CASPol machine-level policy was reviewed and code group 1.6 (Publisher Membership Condition) is not configured on {COMPUTERNAME}. Please validate documentation with ISSO.`n`n
"@
    }
############################################################################### 
    V225227 = @"
Full-volume backups of the C: drive for {COMPUTERNAME} are performed using AWS Backup and Commvault. Full backups are conducted each Thursday, with incremental backups performed on all remaining days of the week. CAS policy and policy configuration files are included within the scope of these backups and are retained as part of the system's disaster recovery process.
"@
###############################################################################
    V225236 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Process | 
ForEach-Object {
    if (`$_.Modules.ModuleName -contains 'mscoree.dll') {
        `$_ | Select-Object Name, Id, Path
    }
}

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated all processes running on {COMPUTERNAME} are a part of the either provided by the host Windows Operating System or is part of the DHA Server 2022 Image, configured
to the Windows Secure Host Baseline (SHB) for Windows Servers.`n`n  
"@

        Open = @"
Validated NOT all processes running on {COMPUTERNAME} are a part of the either provided by the host Windows Operating System or is part of the DHA Server 2022 Image.

The following processes need to be reviewed:

{NEEDSREVIEW}`n`n
"@
    }
}