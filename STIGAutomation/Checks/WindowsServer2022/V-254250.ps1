function Get-V254250 {
    [CmdletBinding()]
    param()

    $AllowedFileSystems = @(
        'NTFS'
        'ReFS'
        'CSVFS'
    )

    $Volumes = Get-Volume |
        Where-Object {
            -not [string]::IsNullOrWhiteSpace($_.FileSystem)
        } |
        Where-Object {
            $Partition = Get-Partition `
                -Volume $_ `
                -ErrorAction SilentlyContinue

            $Partition.Type -notin @('System', 'Recovery')
        }

    $InvalidVolumes = $Volumes |
        Where-Object {
            $_.FileSystem -notin $AllowedFileSystems
        }

    if ($InvalidVolumes) {
        $Status = 'open'

        $Comment = @"
The following volumes are not formatted with an approved filesystem
(NTFS, ReFS, or CSVFS):
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
$(
    $InvalidVolumes |
        Select-Object DriveLetter, FileSystem, FileSystemLabel |
        Format-Table -AutoSize |
        Out-String
)
"@
    }
    else {
        $Status = 'not_a_finding'

        $Comment = @"
Output
‾‾‾‾‾‾‾
$(
    $Volumes |
        Select-Object DriveLetter, FileSystem, FileSystemLabel |
        Format-Table -AutoSize |
        Out-String
)
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
All applicable volumes are formatted with an approved filesystem
(NTFS, ReFS, or CSVFS).
"@
    }

    $pwsh_command = @'
PowerShell Cmd
‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Get-Volume |
    Where-Object {
        -not [string]::IsNullOrWhiteSpace($_.FileSystem)
    } |
    Where-Object {
        $Partition = Get-Partition `
            -Volume $_ `
            -ErrorAction SilentlyContinue

        $Partition.Type -notin @('System', 'Recovery')
    } |
    Select-Object DriveLetter, FileSystem, FileSystemLabel |
    Format-Table -AutoSize
'@ 

    return [ordered]@{
        Status  = $Status
        Comment = @"
$pwsh_command

$Comment
"@
    }
}