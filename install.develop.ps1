#!/usr/bin/env pwsh
# This script installs the addon in development mode. Use -Information or -Verbose for logging.
param(
    [string]$wowDirectory = "C:\BNetGames\World of Warcraft"
)

# create method Test-IsAdmin; returns boolean
function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# this directory here
$myAddonDir = Get-Location

# check if directory exists
if (!(Test-Path "$wowDirectory")) {
    Write-Error "WoW Directory $wowDirectory does not exist!"
} else {
    $flavors = @("_retail_", "_classic_", "_classic_era_", "_ptr_", "_beta_")
    foreach ($flavor in $flavors) {
        # check if flavor directory exists
        if (!(Test-Path "$wowDirectory\$flavor")) {
            Write-Information "WoW Directory $wowDirectory with $flavor flavor does not exist!"
            continue
        }
        $addonDir = "$wowDirectory\$flavor\Interface\AddOns\HelloWorld"
        if (Test-Path $addonDir) {
            Write-Information "HelloWorld addon link already exists in $addonDir"
        } else {
            # check if user has administrator privileges
            if (-not (Test-IsAdmin)) {
                Write-Error "You need administrator privileges to create symbolic links!"
            } else {
                # create link
                Write-Verbose "Creating symbolic link for HelloWorld addon..."
                New-Item -ItemType SymbolicLink -Path "$wowDirectory\$flavor\Interface\AddOns\HelloWorld" -Target $myAddonDir
                Write-Host "Symbolic link in $flavor created successfully!"
            }
        }
    }
}
