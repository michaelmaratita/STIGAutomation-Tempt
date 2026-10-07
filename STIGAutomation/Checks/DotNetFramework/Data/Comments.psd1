@{
    V225225 = @{

        PowerShellCommand = @"
CMD
‾‾‾‾
cd 'C:\Windows\Microsoft.NET\Framework\v4.0.30319'

.\caspol.exe -m -lg

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

}