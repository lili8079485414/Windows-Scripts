# ====================================================================================
# Windows Update Safe Disable/Enable Script (Only modifies policies, doesn't disable services)
# ====================================================================================

# Check Administrator Privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: Please run this script as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

function Toggle-UpdatePolicy {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "     Windows Update Security Policy Control Script"
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This script controls updates by modifying registry policies and will not disable services," -ForegroundColor Yellow
    Write-Host "therefore it will not affect the Start Menu or other system functions." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please select:"
    Write-Host "  1. Safely disable automatic updates"
    Write-Host "  2. Restore automatic update policy"
    Write-Host "  Q. Exit"
    $choice = Read-Host "Please enter your choice (1, 2, or Q)"

    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"

    switch ($choice) {
        '1' {
            Write-Host "`nDisabling automatic update policy..." -ForegroundColor Green
            if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
            Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force # 2 = Notify for download and install
            Write-Host "✔ Operation completed! Automatic updates have been disabled by policy." -ForegroundColor Cyan
        }
        '2' {
            Write-Host "`nRestoring automatic update policy..." -ForegroundColor Green
            if (Test-Path $regPath) { Remove-Item -Path $regPath -Recurse -Force }
            Write-Host "✔ Operation completed! Update policy has been restored to default." -ForegroundColor Cyan
        }
        default {
            Write-Host "Exited, no changes made."
        }
    }
    Read-Host "`nPress Enter to exit..."
}

Toggle-UpdatePolicy
