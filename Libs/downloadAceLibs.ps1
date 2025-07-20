#!/usr/bin/env pwsh
#
param(
    [string]$AceUrl = "https://www.wowace.com/projects/ace3/files/latest"
    # MoP Classic: https://www.wowace.com/projects/ace3/files/6757007/download
)

Write-Host "Downloading AceLibs from $AceUrl..."

# # Download latest acelib from website, follow redirects
Invoke-WebRequest -Uri $AceUrl -MaximumRedirection 10 -OutFile "$PSScriptRoot/AceLibs.zip" -UseBasicParsing

Write-Host "Extracting AceLibs..."
# Extract downloaded zip file
Expand-Archive -Path "$PSScriptRoot/AceLibs.zip" -DestinationPath "$PSScriptRoot/" -Force

Write-Host "Removing downloaded AceLibs.zip..."
# Remove downloaded zip file
Remove-Item -Path "$PSScriptRoot/AceLibs.zip"
