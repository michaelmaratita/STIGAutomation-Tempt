function New-SCAPScan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Server2022', 'DotNetFramework')]
        [string]$Type
    )

    $STIGData = Import-PowerShellDataFile `
        -Path "$PSScriptRoot\..\Data\STIGSettings.psd1"
    $Benchmark = $STIGData[$Type]

    $SCAPPath = Get-ChildItem `
        -Path $env:ProgramFiles `
        -Directory `
        -ErrorAction SilentlyContinue |
        Where-Object Name -like 'SCAP*' |
        Select-Object -First 1

    if ($null -eq $SCAPPath) {
        throw "SCAP Scanner is not installed on $env:COMPUTERNAME."
    }

    $CSCCPath = Join-Path $SCAPPath.FullName 'cscc.exe'

    if (-not (Test-Path -LiteralPath $CSCCPath)) {
        throw "SCAP Scanner was found, but cscc.exe was not found at $CSCCPath."
    }

    Write-Verbose "Resetting SCAP benchmark state..."
    
    & $CSCCPath -da -q

    Write-Verbose "Enabling SCAP benchmark: $($Benchmark.Name) Version: $($Benchmark.Version)"

    & $CSCCPath --enableBenchmark $($Benchmark.Name) $($Benchmark.Version) -q

    Write-Verbose "Starting SCAP Scan..."

    & $CSCCPath -q

    if ($LASTEXITCODE -ne 0) {
        throw "SCAP Scanner returned exit code $LASTEXITCODE."
    }

    Write-Verbose 'SCAP scan completed successfully.'
}