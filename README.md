# HomeLab: System Report Script

A PowerShell script that prints a quick health report for a Windows machine, handy for checking on a home server or PC. It shows basic hardware info, which dev tools are installed, what is using memory, whether key services are running, and how fast the machine runs a small benchmark.

## What it reports

- **System:** time (UTC), hostname, Windows version, PowerShell version, CPU cores
- **Memory and disk:** total and available RAM, used and free space on the system drive
- **Tools on PATH:** where `python`, `node`, `git`, `curl.exe`, `ffmpeg` and `pandoc` are installed (or `-` if missing)
- **Top 5 processes** by memory use
- **Service check:** `Spooler`, `EventLog` and `WinDefend`, shown in green if running and red if not
- **Benchmark:** counts the primes below 1,000,000 and prints how long it took (optional)

## Requirements

- Windows 10 or 11
- Windows PowerShell 5.1 or PowerShell 7+

No extra modules or installs are needed.

## Usage

Download `workspace_report.ps1`, open PowerShell in the same folder, and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\workspace_report.ps1
```

To skip the benchmark (it takes several seconds in PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File .\workspace_report.ps1 -Quick
```

## Example output

```
=== System report ===
Time (UTC):  2026-11-20 05:56:34
Host:        MY-PC
OS:          Microsoft Windows 10 Pro (build 19045)
PowerShell:  5.1.19041.6456
CPU cores:   4
Memory:      23.9 GB total, 15.7 GB available
Disk (C:):    187.1 GB used of 311.8 GB (124.7 GB free)

Tools on PATH:
  python     C:\Users\...\WindowsApps\python.exe
  node       C:\Program Files\nodejs\node.exe
  git        C:\Program Files\Git\cmd\git.exe
  curl.exe   C:\Windows\system32\curl.exe
  ffmpeg     -
  pandoc     -

Top 5 processes by memory:
  chrome               476 MB
  Code                 440 MB
  Code                 416 MB
  MsMpEng              375 MB
  chrome               299 MB

Services:
  Spooler      Running
  EventLog     Running
  WinDefend    Running

Benchmark: primes below 1,000,000 (this can take a few seconds)
  found 78,498 primes in 7.296s
```

## Notes

- The script only reads system information. It does not change anything on your machine.
- Service names are set in the `foreach` loop in the Services section. Edit that list to monitor other services.
- If PowerShell blocks the script, the `-ExecutionPolicy Bypass` flag in the commands above applies only to that one run.

