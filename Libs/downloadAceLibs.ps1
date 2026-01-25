#!/usr/bin/env pwsh
#
[CmdletBinding()]
param(
  [Parameter(Mandatory = $false, HelpMessage = "the url to download AceLibs from")][string]$AceUrl = "https://www.wowace.com/projects/ace3/files/latest"
  # MoP Classic: https://www.wowace.com/projects/ace3/files/6757007/download
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Write-Host "Downloading AceLibs from $AceUrl..."

# Download latest acelib from website, follow redirects
Invoke-WebRequest -Uri $AceUrl -MaximumRedirection 15 -OutFile "$PSScriptRoot/AceLibs.zip" -ConnectionTimeoutSeconds 15 -OperationTimeoutSeconds 9 -MaximumRetryCount 3 -RetryIntervalSec 5 -verbose

Write-Host "Extracting AceLibs..."
# Extract downloaded zip file
Expand-Archive -Path "$PSScriptRoot/AceLibs.zip" -DestinationPath "$PSScriptRoot/" -Force

Write-Host "Removing downloaded AceLibs.zip..."
# Remove downloaded zip file
Remove-Item -Path "$PSScriptRoot/AceLibs.zip"
