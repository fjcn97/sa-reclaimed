param(
    [int]$TimeoutSeconds = 60
)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$godot = 'C:\Users\Fabio\AppData\Local\Microsoft\WinGet\Links\godot.exe'
$smokeRoot = Join-Path $projectRoot 'godot-project'
$logRoot = Join-Path ([IO.Path]::GetTempPath()) ('sa2-smoke-' + [guid]::NewGuid().ToString('N'))

if (-not (Test-Path -LiteralPath $godot)) {
    throw "Godot executable not found: $godot"
}
New-Item -ItemType Directory -Path $logRoot -Force | Out-Null

$total = 0
$passed = 0
$failed = @()
try {
    foreach ($script in (Get-ChildItem -LiteralPath $smokeRoot -Filter '*_smoke.gd' -File | Sort-Object Name)) {
        $total++
        $log = Join-Path $logRoot ($script.BaseName + '.log')
        $process = Start-Process -FilePath $godot -ArgumentList @(
            '--headless', '--path', 'godot-project', '--script', ('res://' + $script.Name),
            '--log-file', $log
        ) -WindowStyle Hidden -PassThru
        $finished = $process.WaitForExit($TimeoutSeconds * 1000)
        if (-not $finished) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            $failed += "$($script.Name): timeout"
            continue
        }
        $output = Get-Content -LiteralPath $log -Raw -ErrorAction SilentlyContinue
        $has_result = $output -match '(?m)^[A-Z][A-Z0-9_]+=[0-9]+'
        $has_error = $output -match '(?m)(SCRIPT ERROR|Parse Error|_[A-Z]+_FAIL:|ERROR: Cannot)'
        if ($process.ExitCode -eq 0 -and $has_result -and -not $has_error) {
            $passed++
        } else {
            $failed += "$($script.Name): exit=$($process.ExitCode) result=$has_result error=$has_error"
        }
    }
} finally {
    # Keep the isolated logs in the OS temp directory when a process has to be
    # terminated, so Windows can release its file handles without blocking the
    # final summary. The path is printed only on failures below.
}

"SMOKE_TOTAL=$total"
"SMOKE_PASSED=$passed"
"SMOKE_FAILED=$($failed.Count)"
$failed
if ($failed.Count -gt 0) {
    "SMOKE_LOG_ROOT=$logRoot"
}
exit $(if ($failed.Count -eq 0) { 0 } else { 1 })
