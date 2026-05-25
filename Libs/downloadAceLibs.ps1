#!/usr/bin/env pwsh
#
# Usage: downloadAceLibs.ps1 [-AceUrl <url>] [-UseWebRequest]
[CmdletBinding()]
param(
  [Parameter(Mandatory = $false, HelpMessage = "the url to download AceLibs from")][string]$AceUrl = "https://www.wowace.com/projects/ace3/files/latest",
  [Parameter(Mandatory = $false, HelpMessage = "force using Invoke-WebRequest instead of aria2c")][switch]$UseWebRequest
  # MoP Classic: https://www.wowace.com/projects/ace3/files/6757007/download
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Write-Host "Downloading AceLibs from $AceUrl..."

# Download latest acelib from website, follow redirects
# Prefer aria2c if available, fall back to Invoke-WebRequest
$zipPath = "$PSScriptRoot/AceLibs.zip"
$useAria2 = (-not $UseWebRequest) -and ($null -ne (Get-Command aria2c -CommandType Application -ErrorAction Ignore))
if ($useAria2) {
  Write-Host "  -> using aria2c"
  & aria2c --max-connection-per-server=4 --split=4 --max-tries=5 --retry-wait=5 --allow-overwrite=true --log="$PSScriptRoot/.aria2c.log" --dir="$PSScriptRoot" --out="AceLibs.zip" "$AceUrl"
  if ($LASTEXITCODE -ne 0) { throw "aria2c failed with exit code $LASTEXITCODE" }
} else {
  $msg = if ($UseWebRequest) { "  -> using Invoke-WebRequest (forced via -UseWebRequest)" } else { "  -> using Invoke-WebRequest (install aria2 for faster downloads)" }
  Write-Host $msg
  Invoke-WebRequest -Uri $AceUrl -MaximumRedirection 15 -OutFile "$zipPath" -MaximumRetryCount 3 -RetryIntervalSec 5 -verbose
}

Write-Host "Extracting AceLibs..."
# Extract downloaded zip file
Expand-Archive -Path $zipPath -DestinationPath "$PSScriptRoot/" -Force

Write-Host "Removing downloaded AceLibs.zip..."
# Remove downloaded zip file
Remove-Item -Path $zipPath
