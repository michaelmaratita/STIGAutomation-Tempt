function Get-V254428 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Comment
    )

    $DataPath         = "$PSScriptRoot\..\..\..\Data\AdminGroups.psd1"
    $Data             = Import-PowerShellDataFile -Path $DataPath

    $App                  = $Data.Server[$env:COMPUTERNAME]
    $AuthorizedGroups     = $Data.AuthorizedGroups[$App]
    $AdministratorsGroups = Get-LocalGroupMember -Group Administrators | Select-Object Name, SID

    $AdministratorsGroups = $AdministratorsGroups | Where-Object {

        # Exclude the BuiltIn\Local Admin 
        $_.SID -notmatch '-500$'
    }

    $PowerShellCommand = $Comment.PowerShellCommand `
                            -replace '{OUTPUT}', $(Get-LocalGroupMember -Group Administrators |
                                                   Select-Object Name, PrincipalSource |
                                                   Format-List |
                                                   Out-String
                                                )

    $UnauthorizedGroup = @()

    foreach ($Group in $AdministratorsGroups.Name){
        if ($Group -notin $AuthorizedGroups){
            $UnauthorizedGroup += $Group
        }
    }

    if ($UnauthorizedGroup.Count -eq 0){

        $Status  = 'not_a_finding'
        $CommentText = $Comment.NotAFinding `
                        -replace '\{DATA\}', $Data.Comment[$App]
        

    } else {

        $Status  = 'open'
        $CommentText = $Comment.Open `
                        -replace '{GROUPCOUNT}', $UnauthorizedGroup.Count `
                        -replace '{UNAUTHORIZED}', $UnauthorizedGroup `
                        -replace '{DATAPATH}', $DataPath
        
    }

    return [ordered]@{
        Status  = $Status
        Comment = $CommentText + $PowerShellCommand

    }
}