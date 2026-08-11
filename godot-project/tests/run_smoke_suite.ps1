param(
    [string]$Godot = "godot.exe",
    [string]$TestPattern = ""
)

$projectPath = (Resolve-Path (Join-Path $PSScriptRoot ".." )).Path
$smokePath = Join-Path $PSScriptRoot "smoke"
$logPath = Join-Path $PSScriptRoot ".logs"
New-Item -ItemType Directory -Force -Path $logPath | Out-Null
$processPath = Join-Path $logPath ".process"
New-Item -ItemType Directory -Force -Path $processPath | Out-Null

function Stop-GodotProcesses {
    Get-Process | Where-Object { $_.ProcessName -like "*godot*" } | ForEach-Object {
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
}

function Invoke-GodotProcess {
    param(
        [string[]]$Arguments,
        [string]$Name,
        [int]$TimeoutSeconds = 90
    )

    $stdoutPath = Join-Path $processPath ("{0}.out" -f $Name)
    $stderrPath = Join-Path $processPath ("{0}.err" -f $Name)
    Remove-Item -LiteralPath $stdoutPath,$stderrPath -Force -ErrorAction SilentlyContinue
    $process = Start-Process -FilePath $Godot -ArgumentList $Arguments -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath -PassThru
    $timedOut = $false
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ($null -ne (Get-Process -Id $process.Id -ErrorAction SilentlyContinue)) {
        if ((Get-Date) -ge $deadline) {
            $timedOut = $true
            break
        }
        Start-Sleep -Milliseconds 100
    }
    if ($timedOut) {
        Stop-GodotProcesses
    }
    $process.Refresh()
    $exitCode = if ($process.HasExited) { $process.ExitCode } else { 124 }
    $stdout = if (Test-Path -LiteralPath $stdoutPath) { Get-Content -LiteralPath $stdoutPath -Raw } else { "" }
    $stderr = if (Test-Path -LiteralPath $stderrPath) { Get-Content -LiteralPath $stderrPath -Raw } else { "" }
    Stop-GodotProcesses
    [pscustomobject]@{
        Output = $stdout + "`n" + $stderr
        ExitCode = $exitCode
        TimedOut = $timedOut
    }
}

$preflightLog = Join-Path $logPath "editor_preflight.log"
$preflightRun = Invoke-GodotProcess @("--headless", "--path", $projectPath, "--editor", "--quit", "--log-file", $preflightLog) "editor_preflight" 60
$preflightText = $preflightRun.Output
$preflightLogText = if (Test-Path -LiteralPath $preflightLog) { Get-Content -LiteralPath $preflightLog -Raw } else { "" }
$preflightNormalized = [regex]::Replace(($preflightText + "`n" + $preflightLogText), "`e\[[0-9;]*m", "")
$preflightFailed = $preflightNormalized -match "SCRIPT ERROR|Parse Error|Failed to load"
if (-not $preflightFailed -and -not $preflightRun.TimedOut -and $preflightRun.ExitCode -ne 0) {
    # Godot can return a transient non-zero status on the first global-class
    # scan after new scripts are registered, even when the editor log is clean.
    # Retry once so genuine parse/load failures remain fatal.
    $preflightRun = Invoke-GodotProcess @("--headless", "--path", $projectPath, "--editor", "--quit", "--log-file", $preflightLog) "editor_preflight_retry" 60
    $preflightText = $preflightRun.Output
    $preflightLogText = if (Test-Path -LiteralPath $preflightLog) { Get-Content -LiteralPath $preflightLog -Raw } else { "" }
    $preflightNormalized = [regex]::Replace(($preflightText + "`n" + $preflightLogText), "`e\[[0-9;]*m", "")
    $preflightFailed = $preflightNormalized -match "SCRIPT ERROR|Parse Error|Failed to load"
}
if ($preflightFailed -or $preflightRun.TimedOut) {
    Write-Output "FAIL editor_preflight RUNTIME_ERROR"
    exit 1
}

$failed = @()
$pendingSummaries = @()
$smokes = Get-ChildItem -LiteralPath $smokePath -File -Filter "*_smoke.gd" | Sort-Object Name
$smokes = if ($TestPattern) { @($smokes | Where-Object { $_.Name -match $TestPattern }) } else { @($smokes) }
foreach ($smoke in $smokes) {
    $relativeScript = "res://tests/smoke/{0}" -f $smoke.Name
    $logFile = Join-Path $logPath ("{0}.log" -f $smoke.BaseName)
    $timeoutSeconds = if ($smoke.Name -eq "runtime_source_smoke.gd") { 60 } else { 15 }
    $run = Invoke-GodotProcess @("--headless", "--path", $projectPath, "--log-file", $logFile, "--script", $relativeScript) $smoke.BaseName $timeoutSeconds
    $text = $run.Output
    $processExit = $run.ExitCode
    $logText = if (Test-Path -LiteralPath $logFile) { Get-Content -LiteralPath $logFile -Raw } else { "" }
    $normalized = [regex]::Replace(($text + "`n" + $logText), "`e\[[0-9;]*m", "")
    $check = [regex]::Match($normalized, "(?m)^[A-Z0-9_]+_CHECKS=([0-9]+)\s*$")
    $diagnosticSummary = [regex]::Match($normalized, "(?m)^[A-Z0-9_]+_CHECKED=([0-9]+)\s*$")
    for ($retry = 0; $retry -lt 10 -and -not $check.Success -and -not $diagnosticSummary.Success; $retry++) {
        Start-Sleep -Milliseconds 100
        $logText = if (Test-Path -LiteralPath $logFile) { Get-Content -LiteralPath $logFile -Raw } else { "" }
        $normalized = [regex]::Replace(($text + "`n" + $logText), "`e\[[0-9;]*m", "")
        $check = [regex]::Match($normalized, "(?m)^[A-Z0-9_]+_CHECKS=([0-9]+)\s*$")
        $diagnosticSummary = [regex]::Match($normalized, "(?m)^[A-Z0-9_]+_CHECKED=([0-9]+)\s*$")
    }
    $diagnostic = $smoke.Name -eq "boss_route_smoke.gd"
    $hasFailure = $normalized -match "\bFAIL\b|SCRIPT ERROR|Parse Error|Failed to load"
    $missingSummary = -not $check.Success -and -not $diagnosticSummary.Success
    $runtimeFailure = $run.TimedOut -or $processExit -ne 0 -or $hasFailure
    if ($runtimeFailure) {
        $failed += $smoke.Name
        Write-Output ("FAIL " + $smoke.Name + " RUNTIME_ERROR")
    } elseif ($missingSummary) {
        $pendingSummaries += $smoke.Name
    } else {
        if ($check.Success) {
            Write-Output ("PASS " + $smoke.Name + " " + $check.Groups[1].Value)
        } else {
            Write-Output ("PASS " + $smoke.Name + " diagnostic=" + $diagnosticSummary.Groups[1].Value)
        }
    }
}

foreach ($pendingName in $pendingSummaries) {
    $pendingLog = Join-Path $logPath ("{0}.log" -f [IO.Path]::GetFileNameWithoutExtension($pendingName))
    $pendingText = if (Test-Path -LiteralPath $pendingLog) { Get-Content -LiteralPath $pendingLog -Raw } else { "" }
    $pendingNormalized = [regex]::Replace($pendingText, "`e\[[0-9;]*m", "")
    $pendingCheck = [regex]::Match($pendingNormalized, "(?m)^[A-Z0-9_]+_CHECKS=([0-9]+)\s*$")
    $pendingDiagnostic = [regex]::Match($pendingNormalized, "(?m)^[A-Z0-9_]+_CHECKED=([0-9]+)\s*$")
    for ($retry = 0; $retry -lt 10 -and -not $pendingCheck.Success -and -not $pendingDiagnostic.Success; $retry++) {
        Start-Sleep -Milliseconds 100
        $pendingText = if (Test-Path -LiteralPath $pendingLog) { Get-Content -LiteralPath $pendingLog -Raw } else { "" }
        $pendingNormalized = [regex]::Replace($pendingText, "`e\[[0-9;]*m", "")
        $pendingCheck = [regex]::Match($pendingNormalized, "(?m)^[A-Z0-9_]+_CHECKS=([0-9]+)\s*$")
        $pendingDiagnostic = [regex]::Match($pendingNormalized, "(?m)^[A-Z0-9_]+_CHECKED=([0-9]+)\s*$")
    }
    $pendingFailure = $pendingNormalized -match "\bFAIL\b|SCRIPT ERROR|Parse Error|Failed to load"
    if ($pendingFailure -or (-not $pendingCheck.Success -and -not $pendingDiagnostic.Success)) {
        $failed += $pendingName
        $reason = if ($pendingFailure) { "RUNTIME_ERROR" } else { "MISSING_CHECKS" }
        Write-Output ("FAIL " + $pendingName + " " + $reason)
    } elseif ($pendingCheck.Success) {
        Write-Output ("PASS " + $pendingName + " " + $pendingCheck.Groups[1].Value)
    } else {
        Write-Output ("PASS " + $pendingName + " diagnostic=" + $pendingDiagnostic.Groups[1].Value)
    }
}

Write-Output ("SMOKE_TESTS=" + $smokes.Count)
if ($failed.Count -gt 0) {
    Write-Output ("FAILED=" + ($failed -join ","))
    exit 1
}
