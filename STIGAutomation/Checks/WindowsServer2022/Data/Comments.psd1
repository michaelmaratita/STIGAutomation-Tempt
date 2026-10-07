@{
###############################################################################
    DomainController = @"
{COMPUTERNAME} is NOT a Domain Controller.

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Windows Feature
{ActiveDirectory}
"@

###############################################################################
    FTP = @{
        
        NotApplicable = @"
Validated FTP is NOT installed on {COMPUTERNAME}.`n`n
"@
        Open = @"
Validated FTP is installed on {COMPUTERNAME}. Please validate the additional settings in the check text.`n`n
"@

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-WindowsFeature ``
-Name Web-Ftp-Server, 
      Web-Ftp-Service, 
      Web-Ftp-Ext | 
Select-Object DisplayName, 
              Name, 
              Installed

Output
‾‾‾‾‾‾
{OUTPUT}
"@

    }
###############################################################################
    icacls = @{

        Compare = @{

                NotAFinding = "Folder permissions for '{PATH}' match the expected configuration.`n`n"

                Open = @"
Please review Folder permissions for '{PATH}'.

Missing:
{MISSiNG}

Unexpected:
{UNEXPECTED}`n`n
"@
                Path = @"
Path: {PATH}

icacls '{PATH}'
{ACTUAL}`n
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n
"@
        }

        Output = @"
{POLICYSETTING}‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{CHECKS}
"@
    }
###############################################################################
    Policy = @{

        Validation = @"
GPO Validation found at {GPRESULTPATH}:

Setting : {SETTING}
Value   : {VALUE}
GPO     : {GPO}

{SUBSETTINGS}
{LOGNAME}
"@

        NotFound = @"
GPO Validation found at {GPRESULTPATH}:

Setting : {SETTING}
{LOGNAME}
Result  : Setting not found
"@

        NotAFinding = @"
Validated {COMPUTERNAME} is configured properly per the Check Text. Evaluations Below:`n`n
"@

        Open = @"
Validated {COMPUTERNAME} is NOT configured properly per the Check Text. Evaluations Below:`n
{IF}`n`n
"@

        Missing = @"
The following required values are MISSING from {POLICYSETTING}:`n`n{MISSING}
"@
    }
###############################################################################
    PolicyAndRegistry = @{

        Validation = @"
GPO Validation found at {GPRESULTPATH}:

Setting : {SETTING}
Value   : {VALUE}
GPO     : {GPO}

{SUBSETTINGS}
{LOGNAME}
"@

        NotFound = @"
GPO Validation found at {GPRESULTPATH}:

Setting : {SETTING}
{LOGNAME}
Result  : Setting not found
"@

        Output = @"
{POLICYSETTING}‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{REGISTRY}
"@

        NotAFinding = @"
Validated {COMPUTERNAME} is configured properly per the Check Text. Evaluations Below:

{OUTPUT}
"@
        Open = @"
Validated {COMPUTERNAME} is NOT configured properly per the Check Text. Evalutaions Below:

{OUTPUT}
"@
        
    }
###############################################################################
    Registry = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key = Get-Item -Path '{PATH}'

Registry Type Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key.GetValueKind('{NAME}')

Type: {TYPE}

Registry Value Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$Key.GetValue('{NAME}')

Value: {VALUE}
"@
###############################################################################
        Splunk = @{

        NotAFinding = @"
Windows Event and Audit Logs for {COMPUTERNAME} are off-loaded to a different system via the SplunkForwarder service. These are off-loaded in real-time to prevent accidental loss or deletion.`n`n
"@
        Open = @"
SplunkForwarder service is NOT RUNNING on {COMPUTERNAME}.`n`n
"@
        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service SplunkForwarder |
Select-Object Name, 
              DisplayName, 
              Status

Output
‾‾‾‾‾‾
{OUTPUT}
"@
    }
###############################################################################
    V254238 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADUser ``
-Filter "GivenName -eq '{GIVEN}' -and Surname -eq '{SURNAME}'" ``
-Properties MemberOf | 
Select-Object GivenName, 
              SurName, 
              SamAccountName,
              UserPrincipalName,
              SID,
              MemberOf

Output
‾‾‾‾‾‾‾{OUTPUT}

"@

        NotAFinding = @"
Validated there are separate accounts for {GIVEN} {SURNAME}. SA accounts are specifically used for System Administration tasks on {COMPUTERNAME}. Normal user accounts (non-SA) do not have login/admin access to Windows Servers.`n`n
"@

        Open = @"
Please validate the status for this STIG check.

{GIVEN} {SURNAME} has {EXAMPLEUSER} accounts
associated with the {USERDNSDOMAIN}.`n`n
"@
    }
###############################################################################
    V254239 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
Where-Object SID -like "*500"

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotApplicable = @"
{LOCALADMIN} is not Enabled on {COMPUTERNAME}.`n`n
"@

        NotAFinding = @"
{LOCALADMIN} is Enabled and Password is less than 60 days old.`n`n
"@

        Open = @"
{LOCALADMIN} is Enabled and Password is older than 60 days.`n`n
"@
    }
############################################################################### 
    V254240 = @{

    }
###############################################################################
    V254241 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalGroupMember ``
-Group 'Backup Operators'
    
Output
‾‾‾‾‾‾
{OUTPUT}
"@

        NotApplicable = @"
Validated Backup Operators does not have any users assigned.`n`n
"@

        Open = @"
Validated Backup Operators has users assigned.`n`n
"@
    }
###############################################################################
    V254242 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADDefaultDomainPasswordPolicy

Output
‾‾‾‾‾‾‾ {OUTPUT}
"@

        NotAFinding = @"
DHA has a default password policy for manually managed application/service accounts that require at least {POLICYSETTING} characters in length and meet complexity rules.`n`n
"@

        Open = @"
The domain does not have a default password policy that requires 14 characters in length.`n`n
"@
    }
###############################################################################
    V254243 = @{

        PowerShellCommand = @"
PowerShell Cmd for AD User
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ADUser ``
-Identity {SamAccountName} ``
-Properties pwdLastSet | 
Select-Object Name,
              Enabled,
              SamAccountName,
              pwdLastSet

Convert pwdLastSet to Human Readable
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
[DateTime]::FromFileTime({pwdLastSet})`n`n
"@

        Info = @"
{USER} Converted pwdLastSet for {SAMACCOUNTNAME}: {CONVERTEDPW}
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
"@

        NotAFinding = @"
{COMPUTERNAME} has the following service account(s) associated with it. These accounts are manually managed and their passwords are reviewed and updated annually. Additionally, when an administrator with knowledge of a service account password leaves the organization, the password is changed after the administrator's access has been revoked.`n`n
"@

        Open = @"
({EXPIREDCOUNT}) account(s) have passwords that are older than 365 days. Please review the accounts and reset the passwords as soon as possible.

Accounts with Passwords Older than 365 days
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{USEREXPIREDPW}
"@

        ServiceAccounts = @"
Service Accounts
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{SERVICEACCOUNTS}

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n
"@

    }
###############################################################################
    V254244 = @{

        NotApplicable = @"
{COMPUTERNAME} does not utilize shared accounts.
"@

        NotAFinding = @"
{COMPUTERNAME} utilizes a shared account. Any shared account utlized is documented with
the Information System Security Officer (ISSO) via the E-Commerce Operational System
Support (EOSS) GovCloud Amazon Web Services (AWS) Server Access Form (SAF).

EOSS AWS SAF includes General and Specific DHA Rules of Behavior acknowledgement
prior to granting access.

All auditing account activity is configured via Group Policy.
"@
    }
###############################################################################
    V254245 = @{

    }
###############################################################################
    V254246 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-TPM

Output
‾‾‾‾‾‾{TPM}
"@

        NotAFinding = @"
Validated TPM is PRESENT and READY on {COMPUTERNAME} using Get-Tpm.`n`n
"@

        Open = @"
Validated TPM is NOT present on {COMPUTERNAME} using Get-Tpm.`n`n
"@
    }
###############################################################################
    V254248 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Process mfetp | 
Select-Object Product, 
              ProductVersion, 
              ProcessName, 
              Id

Output
‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
{COMPUTERNAME} is utilizing a third-party anti-virus solution. Trellix Endpoint Security (ENS) is installed and configured with ThreatPrevent enabled.`n`n
"@

        Open = "{COMPUTERNAME} is NOT running any anti-virus solutions.`n`n"
    }
###############################################################################
    V254249 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Process mfetp | 
Select-Object Product, 
              ProductVersion, 
              ProcessName, 
              Id

Output
‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
{COMPUTERNAME} is utilizing a third-party Host Intrusion Protection (HIPS)/Host Intrustion Detection (HIDS) solution. Trellix Endpoint Security (ENS) is installed
with Exploitation Prevention and Access Protection enabled.`n`n
"@

        Open = "{COMPUTERNAME} is NOT running any Host Intrusion Protection (HIPS)/Host Intrustion Detection (HIDS) solutions.`n`n"
    }
###############################################################################    
    V254250 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Volume |
Where-Object {

    {PARTITION} = Get-Partition ``
    -Volume `$_ ``
    -ErrorAction SilentlyContinue

    {PARTITION}.Type -notin @('System', 'Recovery')
} |
Select-Object DriveLetter,
              FileSystem, 
              FileSystemLabel |
Format-Table -AutoSize

Output
‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
All applicable volumes are formatted with an approved filesystem
(NTFS, ReFS, or CSVFS) on {COMPUTERNAME}.

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n
"@

        Open = @"
The following volumes are not formatted with an approved filesystem
(NTFS, ReFS, or CSVFS):
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n
{INVALID}
"@
    }
###############################################################################
    V254254 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$null = Get-Acl 'HKLM:\SECURITY'

[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
'SECURITY',
[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
[System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl().Access

`$null = Get-Acl 'HKLM:\SOFTWARE'

[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
'SOFTWARE',
[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
[System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl().Access

`$null = Get-Acl 'HKLM:\SYSTEM'

[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
'SYSTEM',
[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadSubTree,
[System.Security.AccessControl.RegistryRights]::ReadPermissions
).GetAccessControl().Access

Output
‾‾‾‾‾‾
HKLM:\SECURITY
‾‾‾‾‾‾‾‾‾‾‾‾‾‾{SECURITY}
HKLM:\SOFTWARE
‾‾‾‾‾‾‾‾‾‾‾‾‾‾{SOFTWARE}
HKLM:\SYSTEM
‾‾‾‾‾‾‾‾‾‾‾‾‾‾{SYSTEM}
"@

        MissingPrincipal = "{PATH} - Missing required principal: {KEY}"

        AccessControlType = "HKLM:\{PATH} - {KEY} has AccessControlType '{ACCESSCONTROLTYPE}' instead of 'Allow'."

        Inherited = "HKLM:\{PATH} - {KEY} has an inherited permission."

        Comparison = "HKLM:\{PATH} - {KEY} has '{ACTUAL}' instead of '{EXPECTED}'."

        Unexpected = "HKLM:\{PATH} - Unexpected principal found: {KEY}"

        NotAFinding = @"
Validated {COMPUTERNAME} registry ACL permissions for compliance.`n`n
"@

        Open = @"
Validated {COMPUTERNAME} registry ACL permissions are NOT configured properly.`n`n

Review the Registry Permissions Below:
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{FAILURES}
"@
    }
###############################################################################
    V254255 = @{

        PowerShellCommand = @"
Microsoft Print to PDF and Microsoft XPS Document Writer or any variation of those, e.g (redirected 2), are excluded from this check.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Printer | Select-Object Name 

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotApplicable = "No printers are configured on {COMPUTERNAME}.`n`n"

        Open = @"
Validated that printers are configured on {COMPUTERNAME}. Please verify the printers that are configured.`n`n
"@
    }
###############################################################################
    V254256 = @{

        Note = @"
NOTE: Excluded accounts are the following per the Check Text:
- Built-in administrator account (Renamed, SID ending in 500)
- Built-in guest account (Renamed, Disabled, SID ending in 501)
- Application accounts:
    - DefaultAccount (SID ending in 503)
    - WDAGUtilityAccount  (SID ending in 504)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n
"@

        PowerShellCommand =@"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
Where-Object Enabled -eq `$true | 
Select-Object Name, 
              Enabled, 
              LastLogon

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotAFinding = @{
                
                CountEqZero = @"
There are no applicable enabled local accounts to evaluate on {COMPUTERNAME}.`n`n
"@
                CountGtZero = @"
All applicable enabled local accounts have logged on within the last 35 days.

Validate the account usage and supporting documentation with the ISSO.`n`n
"@      }

        Open = @"
Review the identified account(s) on {COMPUTERNAME} and determine whether they are required. 
If the account is required, validate the account usage and supporting documentation with the ISSO.
"@


    }
###############################################################################
    V254257 = @{

        PowerShellCommand =@"
NOTE: Excluded accounts are Guest and DefaultAccount per the Check Text.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-CimInstance -Class Win32_UserAccount ``
-Filter "PasswordRequired=False ``
and ``
LocalAccount=True ``
and ``
Disabled=False" |
Select-Object Name, 
              SID, 
              PasswordRequired, 
              PasswordExpires, 
              Disabled, 
              LocalAccount

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotAFinding = @"
There are no local accounts that are Enabled and Password not required on {COMPUTERNAME}.`n`n
"@

        Open = @"
Please review the local accounts on {COMPUTERNAME} using the list below. There is an account that does not require a password.`n`n
"@
    }
###############################################################################
    V254258 = @{

        PowerShellCommand = @"
NOTE: Excluded accounts are Guest and DefaultAccount per the Check Text.

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-CimInstance ``
-Class Win32_UserAccount ``
-Filter "PasswordExpires=False ``
and ``
LocalAccount=True ``
and ``
Disabled=False" |
Select-Object Name, 
              SID, 
              PasswordRequired, 
              PasswordExpires, 
              Disabled, 
              LocalAccount

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotAFinding = @"
There are no local accounts that are Enabled and Password never expires on {COMPUTERNAME}.`n`n
"@

        Open = @"
Please review the local accounts on {COMPUTERNAME} using the list below. There is an account that has a password that does not expire.`n`n
"@
    }
###############################################################################
    V254259 = @{

    }
###############################################################################
    V254260 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-SmbShare | Select-Object Name

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated that only system-created shares such as 'ADMIN$', 'C$', 'D$', and 'IPC$' exist on {COMPUTERNAME}. No nonsystem-created shares require review.`n`n
"@

        Open = @"
Validated that the following nonsystem-created shares exist on {COMPUTERNAME} and require review of Share Permissions and NTFS Security permissions.`n`n
"@
    }
###############################################################################
    V254261 = @{

        PowerShellCommand = @'
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$Extensions = '*.p12', '*.pfx'

$Drives = Get-PSDrive `
-PSProvider FileSystem |
    Where-Object { $_.Root }

foreach ($Drive in $Drives) {
foreach ($Extension in $Extensions) {
        Get-ChildItem -Path $Drive.Root `
            -Filter $Extension `
            -File `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}

Output
‾‾‾‾‾‾‾
{OUTPUT}
'@

        NotAFinding = "No .p12 or .pfx files were found on {COMPUTERNAME}`n`n"

        Open = @"
Certificate installation files were found on {COMPUTERNAME}:

Remove any certificate installation files (*.p12 and *.pfx) found on the system.

If the files are required by a server-based application, verify that they are
application files rather than certificate installation files and ensure the
exception is documented with the ISSO.`n`n
"@
    }
###############################################################################
    V254262 = @"
{COMPUTERNAME} is an Amazon Web Service (AWS) Elastic Compute Cloud (EC2) Instance.

Physical protections for AWS assets can be found at https://aws.amazon.com/compliance/data-center/controls/

EC2 volumes are configured with encryption to ensure Data at Rest.

Screen capture evidence for EC2 volume encrytion can be found on GitLab:

paaS/ecs/architecture/windows/server-baseline/-/blob/main/{COMPUTERNAME}/{COMPUTERNAME}.md#ec2-volume-encryption-evidence
"@
###############################################################################
    V254263 = @"
- EOSS systems utilize the latest versions of TLS for secure connections. Weaker
TLS and SSL versions are disabled through the registry. Any Public facing URLs
utilize F5 Proxies that also require the use of the latest TLS versions.

- Per ISSM Guidelines, any remote workers must utilize Cisco AnyConnect VPN connections
to access EOSS resources. 

- ALL EOSS staff must utilize the Application Virtualization Hosting Environment (AVHE)
desktops. AVHE Production and AVHE-Labs desktops are the only means
to be granted login access to the servers hosted in Amazon Web Service (AWS). Any
attempts to login outside of AVHE/AVHE-Labs will fail to connect to the instance.


Reference Doc: 'DHA ECS, System & Communication (SC) Policy and Procedures, Section 3.8.2 SC-08(02) Transmission Confidentiality and Integrity | Pre- and Post-transmission'
"@
###############################################################################
    V254264 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-WindowsFeature | 
Where-Object Installed -eq `$true |
Format-List DisplayName, Name, FeatureType

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated {COMPUTERNAME} has the following Windows Features installed. 
Documentation for the installed features can be referenced on the GitLab: 
paaS/ecs/architecture/windows/server-baseline/-/blob/main/{COMPUTERNAME}/{COMPUTERNAME}.md#installed-windows-features`n`n
"@
    }
###############################################################################
    V254265 = @{

        PowerShellCommand = @"
PowerShell Cmd (Trellix Firewall Core Service)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service mfefire

{TRELLIXFW}

PowerShell Cmd (Windows Defender FireWall)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Service mpssvc

{DEFENDER}
"@

        NotAFinding = @"
{COMPUTERNAME} is utilizing a host-based firewall and it is enabled on the system.`n`n
"@

        Open = "{COMPUTERNAME} is NOT utilizing a host-based firewall.`n`n"
    }
###############################################################################
    V254267 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
Select-Object Name, 
              Enabled

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotApplicable = @"
Validated there are no temporary accounts utilized on {COMPUTERNAME}.`n`n
"@

        Open = @"
A local user that is not a default user account has been found on {COMPUTERNAME}.
Please validate the status of the user(s) and delete if not required.

Non-Default User Accounts
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{NONDEFAULT}
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
"@
    }
###############################################################################
    V254268 = @{

        Note = @"
NOTE: Excluding the following accounts as they are not designed for Emergency Access:
- Built-in administrator account (Renamed, SID ending in 500)
- Built-in guest account (Renamed, Disabled, SID ending in 501)
- Application accounts:
    - DefaultAccount (SID ending in 503)
    - WDAGUtilityAccount  (SID ending in 504)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n
"@

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalUser | 
Where-Object {
(`$_.Enabled -eq `$true) ``
-and ``
(`$null -eq `$_.AccountExpires)
} | 
Select-Object Name, Enabled, AccountExpires

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotApplicable = @"
{COMPUTERNAME} does not utilize Emergency Accounts. Only the built-in accounts exist on the server.`n`n
"@

        Open = @"
A local user that is not a default user account has been found on {COMPUTERNAME}. Please validate the status of the user(s) and delete if not required.`n`n
"@
    }
###############################################################################
    V254281 = @{

        Outputs = @"
{POLICYSETTING}{REGISTRYSETTING}`n`n
"@

        PowerShellCommand = @"
w32tm /query /source
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
NTP Server: {NTPSOURCE}

w32tm /query /configuration
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Type: {TYPE}
"@

        NotAFinding = @"
Validated {POLICYSETTING} is set to {POLICYVALUE} and NTP Client is set to {REGISTRYVALUE}`n`n
"@
    }
###############################################################################
    V254282 = @{

        NotAFinding = @"
No unresolved SIDs were identified in the User Rights Assignment section of the effective Group Policy.

GPResult:
{GPRESULTPATH}
"@

        Open = @"
The following unresolved SIDs were identified in the User Rights Assignment section of the effective Group Policy:

{UNRESOLVEDSIDS}

Review each unresolved SID to determine whether it belongs to a currently valid account or group. If an unresolved SID is not for a currently valid account or group, this is a finding.

GPResult:
{GPRESULTPATH}
"@
    }
###############################################################################
    V254283 = @"
{COMPUTERNAME} utilizes {FIRMWARETYPE}. 

PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
`$env:firmware_type

Output
‾‾‾‾‾‾
{FIRMWARETYPE}
"@
###############################################################################
    V254284 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Confirm-SecureBootUEFI

Output
‾‾‾‾‾‾‾
{OUTPUT}
"@

        NotAFinding = @"
Validated {COMPUTERNAME} utilizes {FIREWARETYPE} with SecureBoot enabled.
"@

        Open = "Settings need to be validated for {COMPUTERNAME}"
    }
###############################################################################
    V254343 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        Registry = @"
REGISTRY CHECKS:

{VBS}
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{RSP}
"@

        NotAFinding = @"
{COMPUTERNAME}} is running SecureBoot and Virtualized Based Security (VBS). This is configured through Group Policy, but validations through PowerShell and Registry Settings have been completed. Outputs below.

{POLICYSETTING}
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾`n`n
"@
    }
###############################################################################
    v254428 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-LocalGroupMember -Group Administrators

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
The following groups within the Local Administrators groups are authorized and required. The Server Access Form (SAF) documents server access for each group. Each individual user assigned to the identified groups are documented with the ISSO.

{DATA}

NOTE: The renamed Local Administrator account is exempt from this check.`n`n
"@

        Open = @"
({GROUPCOUNT}) unauthorized group(s) have been identified. Please validated the group and users are authorized
access and documented with the ISSO.

Unauthorized Group(s)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{UNAUTHORIZED}

Update the AdminGroups.psd1 if authorized or remove the identified groups to clear this check.
AdminGroups.psd1 is located at {DATAPATH}.`n`n
"@
    }
###############################################################################
    V254442 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem ``
-Path Cert:Localmachine\root | 
Where-Object Subject -Like "*DoD*" |
Format-List Subject, 
            NotAfter

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated DoD Root CA certificates are installed as Trusted Root Certification Authorities on {COMPUTERNAME}.`n`n
"@

        Open = @"
Validated DoD Root CA certificates are NOT installed as Trusted Root Certification Authorities on {COMPUTERNAME}.`n`n
"@
    }
###############################################################################
    V254443 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem ``
-Path Cert:Localmachine\disallowed | 
Where-Object {
`$_.Issuer -Like "*DoD Interoperability*" `
-and `
`$_.Subject -Like "*DoD*"
} |
Format-List Issuer, 
            Subject, 
            NotAfter

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated certificates are listed where the Issuer and Subject matches the provided Check text for {COMPUTERNAME}.`n`n
"@

        Open = @"
Validated certificates are NOT listed where the Issuer and Subject matches the provided Check text for {COMPUTERNAME}.`n`n
"@
    }
###############################################################################
    V254444 = @{

        PowerShellCommand = @"
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-ChildItem ``
-Path Cert:Localmachine\disallowed | 
Where-Object Issuer -Like "*CCEB Interoperability*" |
Format-List Issuer, 
            Subject, 
            NotAfter

Output
‾‾‾‾‾‾‾{OUTPUT}
"@

        NotAFinding = @"
Validated CCEB Interoperability Root CA certificates are listed from the provided Check text command for {COMPUTERNAME}.`n`n
"@

        Open = @"
Validated CCEB Interoperability Root CA certificates are NOT listed from the provided Check Text command for {COMPUTERNAME}.
"@

    }
###############################################################################
    V254457 = @{

        BannerText = @"
You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.

By using this IS (which includes any device attached to this IS), you consent to the following conditions:

-The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.

-At any time, the USG may inspect and seize data stored on this IS.

-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.

-This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.

-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.
"@

        Output = @"
{POLICYSETTING}‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
{REGISTRY}
"@

        NotAFinding = @"
The Interactive Logon Message text on {COMPUTERNAME} matches the required Check Text.
"@

        Open = @"
The Interactive Logon message text on {COMPUTERNAME} does NOT match the required Check Text.
"@
    }
}