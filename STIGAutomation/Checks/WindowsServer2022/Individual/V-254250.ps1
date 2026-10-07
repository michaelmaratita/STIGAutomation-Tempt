function Get-V254250 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $AllowedFileSystems = @(
        'NTFS'
        'ReFS'
        'CSVFS'
    )

    $Volumes = Get-Volume |
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
        $CommentText = $Comment.Open `
                        -replace '{INVALID}', $(
                                                $InvalidVolumes |
                                                    Select-Object DriveLetter,
                                                                  FileSystem, 
                                                                  FileSystemLabel |
                                                    Format-Table -AutoSize |
                                                    Out-String
                                            )

    } else {

        $Status = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '{COMPUTERNAME}', $env:COMPUTERNAME
                        
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $(
                                                    $Volumes |
                                                        Select-Object DriveLetter,
                                                                      FileSystem, 
                                                                      FileSystemLabel |
                                                        Format-Table -AutoSize |
                                                        Out-String
                                                )

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand
    }
}