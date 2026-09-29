function Get-V254262 {
    [CmdletBinding()]
    param()
   
    return [ordered]@{
        Status = 'not_a_finding'
        Comment = @"
$env:ComputerName is an Amazon Web Service (AWS) Elastic Compute Cloud (EC2) Instance.

Physical protections for AWS assets can be found at https://aws.amazon.com/compliance/data-center/controls/

EC2 volumes are configured with encryption to ensure Data at Rest.

Screen capture evidence for EC2 volume encrytion can be found on GitLab:

PaaS\ECS\Architecture\Windows\Server Baseline\$env:ComputerName\Baseline_Configurations
"@
    }
}