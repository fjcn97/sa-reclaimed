param(
    [string]$Godot = "",
    [int]$TimeoutSeconds = 20,
    [string]$Filter = "*_smoke.gd"
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ([string]::IsNullOrWhiteSpace($Godot)) {
    $Godot = 'C:\Users\Fabio\AppData\Local\Microsoft\WinGet\Links\godot.exe'
}
if (-not (Test-Path -LiteralPath $Godot)) {
    throw "Godot executable not found: $Godot"
}

$tests = Get-ChildItem -LiteralPath (Join-Path $projectRoot 'tests\smoke') -Filter $Filter | Sort-Object Name
$failed = @()
foreach ($test in $tests) {
    $resourcePath = 'res://tests/smoke/' + $test.Name
    $process = Start-Process -FilePath $Godot -ArgumentList '--headless','--path',$projectRoot,'--script',$resourcePath -PassThru
    if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
        Stop-Process -Id $process.Id -Force
        Write-Error "TIMEOUT: $($test.Name) exceeded $TimeoutSeconds seconds"
        $failed += $test.Name
        continue
    }
    if ($process.ExitCode -ne 0) {
        Write-Error "FAILED: $($test.Name) exited with code $($process.ExitCode)"
        $failed += $test.Name
        continue
    }
    Write-Output "PASS: $($test.Name)"
}

if ($failed.Count -gt 0) {
    throw ("Smoke failures: " + ($failed -join ', '))
}
Write-Output ("SMOKE_PASS_COUNT=" + $tests.Count)
