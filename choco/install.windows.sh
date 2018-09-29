#!/usr/bin/env bash

"$WINDIR/System32/WindowsPowerShell/v1.0/powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy ByPass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
