<#
.SYNOPSIS
    Reports on the machine it runs on and runs a small benchmark.
    Works in Windows PowerShell 5.1 and PowerShell 7+ (Windows).
#>

Write-Host "=== System report ==="
Write-Host ("Time (UTC):  {0:yyyy-MM-dd HH:mm:ss}" -f [DateTime]::UtcNow)
Write-Host ("Host:        {0}" -f $env:COMPUTERNAME)

$os = Get-CimInstance Win32_OperatingSystem
Write-Host ("OS:          {0} (build {1})" -f $os.Caption, $os.BuildNumber)
Write-Host ("PowerShell:  {0}" -f $PSVersionTable.PSVersion)
Write-Host ("CPU cores:   {0}" -f [Environment]::ProcessorCount)

$totalGB = $os.TotalVisibleMemorySize / 1MB
$freeGB  = $os.FreePhysicalMemory / 1MB
Write-Host ("Memory:      {0:N1} GB total, {1:N1} GB available" -f $totalGB, $freeGB)

$drive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'"
Write-Host ("Disk ({0}):    {1:N1} GB used of {2:N1} GB ({3:N1} GB free)" -f `
    $drive.DeviceID, (($drive.Size - $drive.FreeSpace) / 1GB), ($drive.Size / 1GB), ($drive.FreeSpace / 1GB))

Write-Host "`nTools on PATH:"
foreach ($tool in "python", "node", "git", "curl.exe", "ffmpeg", "pandoc") {
    $cmd = Get-Command $tool -ErrorAction SilentlyContinue
    $path = if ($cmd) { $cmd.Source } else { "-" }
    Write-Host ("  {0,-10} {1}" -f $tool, $path)
}

Write-Host "`nBenchmark: primes below 1,000,000 (this can take a few seconds)"
$limit = 1000000
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$composite = New-Object bool[] $limit
$count = 0
for ($i = 2; $i -lt $limit; $i++) {
    if (-not $composite[$i]) {
        $count++
        for ($j = [long]$i * $i; $j -lt $limit; $j += $i) { $composite[$j] = $true }
    }
}
$timer.Stop()
Write-Host ("  found {0:N0} primes in {1:N3}s" -f $count, $timer.Elapsed.TotalSeconds)