@{
    Server2022 = @{
        # Manual STIG Checks Function
        Function  = 'Invoke-Server2022ManualChecks'

        # SCAP Benchmark Name
        Name      = 'MS_Windows_Server_2022_STIG'

        # SCAP Benchmark Version
        Version   = '002.010'

        XCCDF     = '*XCCDF-Results_MS_Windows_Server_2022*.xml'

        RuleResult     = @('ChildNodes', 'TestResult', 'rule-result')

        Substring = 25
    }

    DotNetFramework = @{
        # Manual STIG Checks Function
        Function = 'Invoke-DotNetFrameworkManualChecks'

        # SCAP Benchmark Name
        Name     = 'MS_Dot_Net_Framework'

        # SCAP Benchmark Version
        Version  = '002.008.015'

        XCCDF    = '*XCCDF-Results_MS_Dot_Net_Framework*.xml'

        RuleResult     = @('ChildNodes', 'TestResult', 'rule-result')

        Substring = 24
    }

    Server2025 = @{
        # Manual STIG Checks Function
        Function = 'Invoke-Server2025ManualChecks'

        # SCAP Benchmark Name
        Name     = 'MS_Windows_Server_2025_STIG'

        # SCAP Benchmark Version
        Version  = '001.001.001'

        XCCDF    = '*XCCDF-Results_MS_Windows_Server_2025*.xml'
    }
}