@{
    # Permission sets per STIG Check
    SECURITY= @{
        'NT AUTHORITY\SYSTEM' = @{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = @{
            #ReadPermissions is Read Control
            #ChangePermissions is Write DAC
            RegistryRights = 'ReadPermissions, ChangePermissions'
        }
    }

   SOFTWARE = @{
        'CREATOR OWNER' = @{
            RegistryRights = 'FullControl'
        }

        'NT AUTHORITY\SYSTEM' = @{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = @{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Users' = @{
            RegistryRights = 'ReadKey'
        }

        'APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES' = @{
            RegistryRights = 'ReadKey'
        }

        'S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681' = @{
            RegistryRights = 'ReadKey'
        }
    }

    SYSTEM = @{
        'CREATOR OWNER' = @{
            RegistryRights = 'FullControl'
        }

        'NT AUTHORITY\SYSTEM' = @{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Administrators' = @{
            RegistryRights = 'FullControl'
        }

        'BUILTIN\Users' = @{
            RegistryRights = 'ReadKey'
        }

        'APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES' = @{
            RegistryRights = 'ReadKey'
        }

        'S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681' = @{
            RegistryRights = 'ReadKey'
        }
    }
}