function Get-XCCDF_Info {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $XCCDF = Read-XCCDF -Type $Type

    $HostFacts = $XCCDF.ChildNodes.TestResult.'target-facts'.fact

    $SCAPResults = Get-SCAPResult -XML $XCCDF -Type $Type

    return [ordered]@{
        Name         = ($HostFacts | Where-Object Name -Like '*host_name').'#text'
        FQDN         = ($HostFacts | Where-Object Name -Like '*fqdn').'#text'
        IP           = ($HostFacts | Where-Object Name -Like '*ipv4').'#text'
        MAC          = ($HostFacts | Where-Object Name -Like '*mac').'#text'
        XCCDF        = $XCCDF
        SCAP_Results = $SCAPResults
    }
}
