function Get-V254263 {
    [CmdletBinding()]
    param()

    $Comment = @"
- EOSS systems utilize the latest versions of TLS for secure connections. Weaker
TLS and SSL versions are disabled through the registry. Any Public facing URLs
utilize F5 Proxies that also require the use of the latest TLS versions.

- Per ISSM Guidelines, any remote workers must utilize Cisco AnyConnect VPN connections
to access EOSS resources. 

- ALL EOSS staff must utilize the Application Virtualization Hosting Environment (AVHE)
desktops. AVHE Production and AVHE-Labs desktops are the only means
to be granted login access to the servers hosted in Amazon Web Service (AWS). Any
attempts to login outside of AVHE/AVHE-Labs will fail to connect to the instance.


MUST FIND REFERENCE DOCUMENATION TO ANNOTATE HERE!
"@
    return [ordered]@{
        Status  = 'open'
        Comment = $Comment 
    }
}