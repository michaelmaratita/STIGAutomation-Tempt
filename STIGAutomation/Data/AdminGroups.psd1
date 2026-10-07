@{
    Server = @{
        'AEPPECOMWSPRISM'  = 'PRISM'
        'AEPRECSWSPRISM1'  = 'PRISM'
        'AEPRECSWSPRISM2'  = 'PRISM'
        'AEDVEOMAPQC01'    = 'TOOLS'
        'AEPPECOMAPJIRA01' = 'TOOLS'
        'AEPRECSAPJIRA01'  = 'TOOLS'
        'AEDVECOMAPHC01'   = 'SECURITY'
        'AEPPECOMAPHC01'   = 'SECURITY'
        'MS-01'            = 'PRISM'
    }

    AuthorizedGroups = @{
        'PRISM' = @(
            'MHS\DCOPS IaaS eCommerce Admins'
            'MHS\ECOM_RDP_PRSIM'
            'MHS\svc_cas_clientpush'
            'MICHAELMARATITA\mapagahes_admins'
        )
        'TOOLS' = @(
            'MHS\DCOPS IaaS eCommerce Admins'
            'MHS\ECOM_RDP_TOOLS'
            'MHS\svc_cas_clientpush'
            'MHS\svc_ecom_jira'

        )
        'SECURITY' = @(
            'MHS\DCOPS IaaS eCommerce Admins'
            'MHS\ECOM_RDP_Security'
            'MHS\svc_cas_clientpush'
        )
    }

    Comment = @{
        'PRISM' = @"
MHS\DCOPS IaaS eCommerce Admins - Architecture (OS Admins)
MHS\ECOM_RDP_PRSIM              - Application Admins (APP/DBA)
MHS\svc_cas_clientpush          - Software Center Service Account
"@
        'TOOLS' = @"
MHS\DCOPS IaaS eCommerce Admins - Architecture (OS Admins)
MHS\ECOM_RDP_TOOLS              - Application Admins (APP/DBA)
MHS\svc_cas_clientpush          - Software Center Service Account
MHS\svc_ecom_jira               - JIRA Application Service Account 
"@
        'SECURITY' = @"
MHS\DCOPS IaaS eCommerce Admins - Architecture (OS Admins)
MHS\ECOM_RDP_Security           - Application Admins
MHS\svc_cas_clientpush          - Software Center Service Account
"@
    }
}