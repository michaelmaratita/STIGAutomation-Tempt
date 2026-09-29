@{
        'V-254288' = @{
            PolicySetting   = 'Enforce password history'
            ExpectedSetting = '24 passwords remembered'
        }
        'V-254289' = @{
            PolicySetting   = 'Maximum password age'
            ExpectedSetting = '60 days'
        }
        'V-254290' = @{
            PolicySetting   = 'Minimum password age'
            ExpectedSetting = '1 days'
        }
        'V-254291' = @{
            PolicySetting   = 'Minimum password length'
            ExpectedSetting = '14 characters'
        }
        'V-254292' = @{
            PolicySetting   = 'Password must meet complexity requirements'
            ExpectedSetting = 'Enabled'
        }
        'V-254293' = @{
            PolicySetting   = 'Store passwords using reversible encryption'
            ExpectedSetting = 'Disabled'
        }
        'V-254434' = @{
            PolicySetting   = 'Access this computer from the network'
            ExpectedSetting = @(
                'Administrators'
                'Authenticated Users'
            )
            Comparison      = 'Groups'
        }
        'V-254435' = @{
            PolicySetting   = 'Deny access to this computer from the network'
            ExpectedSetting = @(
                '{USERDOMAIN}\Enterprise Admins'
                '{USERDOMAIN}\Domain Admins'
                'Local account'
                'Guests'
                )
            Comparison      = 'Groups'
        }
        'V-254436' = @{
            PolicySetting   = 'Deny log on as a batch job'
            ExpectedSetting = @(
                '{USERDOMAIN}\Enterprise Admins'
                '{USERDOMAIN}\Domain Admins'
                'Guests'
                )
            Comparison      = 'Groups'
        }
        'V-254437' = @{
            PolicySetting   = 'Deny log on as a service'
            ExpectedSetting = @(
                '{USERDOMAIN}\Enterprise Admins'    
                '{USERDOMAIN}\Domain Admins'
                )
            Comparison      = 'Groups'
        }
        'V-254438' = @{
            PolicySetting   = 'Deny log on locally'
            ExpectedSetting = @(
                '{USERDOMAIN}\Enterprise Admins'
                '{USERDOMAIN}\Domain Admins'
                'Guests'
                )
            Comparison      = 'Groups'
        }
        'V-254493' = @{
            PolicySetting   = 'Allow log on locally'
            ExpectedSetting = 'Administrators'
        }
        'V-278944' = @{
            PolicySetting   = 'Audit Handle Manipulation'
            ExpectedSetting = 'Failure'
        }
        'V-278946' = @{
            PolicySetting   = 'Audit Registry'
            ExpectedSetting = 'Failure'
            Comparison      = 'Contains'
        }
        'V-278947' = @{
            PolicySetting   = 'Audit Registry'
            ExpectedSetting = 'Success'
            Comparison      = 'Contains'
        }
        'V-278948' = @{
            PolicySetting   = 'Audit Sensitive Privilege Use'
            ExpectedSetting = 'Success'
            Comparison      = 'Contains'
        }
        'V-278949' = @{
            PolicySetting   = 'Audit Sensitive Privilege Use'
            ExpectedSetting = 'Failure'
            Comparison      = 'Contains'
        }
        
}