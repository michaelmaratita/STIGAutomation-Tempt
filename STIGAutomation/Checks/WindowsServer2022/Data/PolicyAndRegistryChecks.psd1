@{
    DefaultOperator = {
        param($Actual, $Expected)
        $Actual -eq $Expected
    }
    Checks = @{
        'V-254345' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
            RegistryName    = 'NoGPOListChanges'
            ExpectedValue   = 0
            PolicySetting   = 'Configure registry policy processing'
            ExpectedSetting = 'Enabled'
            SubSettings     = $true
        }
        'V-254359' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security'
            RegistryName    = 'MaxSize'
            Operator        = {
                param($Actual, $Expected)
                $Actual -ge $Expected
            }
            ExpectedValue   = 5120000
            PolicySetting   = 'Specify the maximum log file size (KB)'
            ExpectedSetting = 'Enabled'
            SubSettings     = $true
            LogSettings      = $true             
            LogName         = 'Security'
        }
        'V-254365' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            RegistryName    = 'DisablePasswordSaving'
            ExpectedValue   = 1
            PolicySetting   = 'Do not allow passwords to be saved'
            ExpectedSetting = 'Enabled'
        }
        'V-254366' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            RegistryName    = 'fDisableCdm'
            ExpectedValue   = 1
            PolicySetting   = 'Do not allow drive redirection'
            ExpectedSetting = 'Enabled'
        }
        'V-254367' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            RegistryName    = 'fPromptForPassword'
            ExpectedValue   = 1
            PolicySetting   = 'Always prompt for password upon connection'
            ExpectedSetting = 'Enabled'
        }
        'V-254373' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
            RegistryName    = 'EnableUserControl'
            ExpectedValue   = 0
            PolicySetting   = 'Allow user control over installs'
            ExpectedSetting = 'Disabled'
        }
        'V-254374' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
            RegistryName    = 'AlwaysInstallElevated'
            ExpectedValue   = 0
            PolicySetting   = 'Always install with elevated privileges'
            ExpectedSetting = 'Disabled'
        }
        'V-254383' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service'
            RegistryName    = 'DisableRunAs'
            ExpectedValue   = 1
            PolicySetting   = 'Disallow WinRM from storing RunAs credentials'
            ExpectedSetting = 'Enabled'
        }
        'V-254433' = @{
            RegistryPath    = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            RegistryName    = 'RestrictRemoteSAM'
            ExpectedValue   = 'O:BAG:BAD:(A;;RC;;;BA)'
            PolicySetting   = 'Network access: Restrict clients allowed to make remote calls to SAM'
            ExpectedSetting = 'O:BAG:BAD:(A;;RC;;;BA)'
        }
        'V-254441' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            RegistryName    = 'LsaCfgFlags'
            ExpectedValue   = 1
            PolicySetting   = 'Turn On Virtualization Based Security'
            ExpectedSetting = 'Enabled'
            SubSettings     = $true
        }
        'V-254458' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            RegistryName    = 'LegalNoticeCaption'
            ExpectedValue   = 'DoW Notice and Consent Banner'
            PolicySetting   = 'Interactive Logon: Message title for users attempting to log on'
            ExpectedSetting = 'US Department of Defense Warning Statement'
        }
        'V-254467' = @{
            RegistryPath    = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            RegistryName    = 'RestrictAnonymous'
            ExpectedValue   = 1
            PolicySetting   = 'Network access: Do not allow anonymous enumeration of SAM accounts and shares'
            ExpectedSetting = 'Enabled'
        }
        'V-254469' = @{
            RegistryPath    = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
            RegistryName    = 'RestrictNullSessAccess'
            ExpectedValue   = 1
            PolicySetting   = 'Network access: Restrict anonymous access to Named Pipes and Shares'
            ExpectedSetting = 'Enabled'
        }
        'V-254474' = @{
            RegistryPath    = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            RegistryName    = 'NoLMHash'
            ExpectedValue   = 1
            PolicySetting   = 'Network security: Do not store LAN Manager hash value on next password change'
            ExpectedSetting = 'Enabled'
        }
        'V-254480' = @{
            RegistryPath    = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy'
            RegistryName    = 'Enabled'
            ExpectedValue   = 1
            PolicySetting   = 'System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing'
            ExpectedSetting = 'Enabled'
        }
        'V-254482' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            RegistryName    = 'FilterAdministratorToken'
            ExpectedValue   = 1
            PolicySetting   = 'User Account Control: Admin Approval Mode for the Built-in Administrator account'
            ExpectedSetting = 'Enabled'
        }
        'V-254485' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            RegistryName    = 'ConsentPromptBehaviorUser'
            ExpectedValue   = 0
            PolicySetting   = 'User Account Control: Behavior of the elevation prompt for standard users'
            ExpectedSetting = 'Automatically deny elevation requests'
        }
        'V-254488' = @{
            RegistryPath    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            RegistryName    = 'EnableLUA'
            ExpectedValue   = 1
            PolicySetting   = 'User Account Control: Run all administrators in Admin Approval Mode'
            ExpectedSetting = 'Enabled'
        }

    }
}