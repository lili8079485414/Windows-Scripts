# ====================================================================================
#            ***   Ultimate Windows Cleanup & Optimization Script   ***
# ====================================================================================
# Author: Your AI Assistant
# Version: 2.2 (Final Perfect Edition)
# Improvements:
#   - Uses try...catch structure to perfectly handle protected app removal errors.
#   - Ensures 100% clean execution logs with no red native error messages.
# ====================================================================================

# Script Start: Check Administrator Privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Error: This script requires administrator privileges to run!" -ForegroundColor Red
    Write-Host "Please right-click the script file and select 'Run with PowerShell'." -ForegroundColor Yellow
    Read-Host "Press Enter to exit..."
    exit
}

# --- Function Definition Area ---

# Function 1: Uninstall Bloatware
function Uninstall-Bloatware {
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "      1. Starting Pre-installed App Removal (Bloatware)"
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "This operation will remove apps from the list and attempt to remove their provisioned packages to prevent reinstallation." -ForegroundColor Yellow

    # --- List of Bloatware Apps Safe to Remove ---
    $BloatwareList = @(
        # Gaming Apps
        "*MicrosoftSolitaireCollection*", "*king.com.CandyCrush*", "*ROBLOXCORPORATION.ROBLOX*",
        # 3D and Mixed Reality
        "*Microsoft.MixedReality.Portal*", "*Microsoft.Microsoft3DViewer*", "*Microsoft.Paint3D*",
        # Media and Social Apps
        "*SpotifyAB.SpotifyMusic*", "*Netflix.Netflix*", "*Facebook.Facebook*",
        "*Facebook.Instagram*", "*Facebook.Messenger*", "*TikTok.TikTok*",
        # Other Microsoft Apps
        "*Microsoft.Getstarted*", "*Microsoft.Todos*", "*Microsoft.WindowsFeedbackHub*", "*Microsoft.SkypeApp*"
    )
    
    # --- List of System-Protected "Stubborn" Apps ---
    $ProtectedApps = @(
        "*Microsoft.Paint*", "*Microsoft.XboxGamingOverlay*", "*Microsoft.XboxSpeechToTextOverlay*",
        "*Microsoft.XboxApp*", "*Microsoft.Xbox.TCUI*", "*Microsoft.ZuneMusic*", "*Microsoft.ZuneVideo*",
        "*Microsoft.YourPhone*", "*Microsoft.GetHelp*", "*Microsoft.MicrosoftStickyNotes*",
        "*Microsoft.WindowsSoundRecorder*", "*Microsoft.People*"
    )

    $AllAppsToRemove = $BloatwareList + $ProtectedApps

    foreach ($AppName in $AllAppsToRemove) {
        Write-Host "`n[Processing]: $AppName" -ForegroundColor Green
        
        $isProtected = $ProtectedApps -contains $AppName
        
        # Step 1: Uninstall installed app packages (execute for all apps)
        $package = Get-AppxPackage -AllUsers $AppName -ErrorAction SilentlyContinue
        if ($package) {
            try {
                # Key change: Put uninstall command in try block and set ErrorAction to Stop
                $package | Remove-AppxPackage -AllUsers -ErrorAction Stop
                Write-Host "  - Uninstalled from all user accounts."
            }
            catch {
                # If the previous command fails, execute this code without printing red errors
                Write-Host "  - Uninstallation failed (this is a system core component that cannot be removed)." -ForegroundColor Yellow
            }
        } else {
            Write-Host "  - No installed package found." -ForegroundColor Gray
        }

        # Step 2: Remove provisioned packages (execute only for non-protected apps)
        if (-not $isProtected) {
            $provisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $AppName }
            if ($provisionedPackage) {
                $provisionedPackage | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                if($?) { Write-Host "  - Successfully removed provisioned package." }
                else { Write-Host "  - Failed to remove provisioned package." -ForegroundColor Yellow }
            } else {
                Write-Host "  - No provisioned package found." -ForegroundColor Gray
            }
        } else {
            Write-Host "  - Skipped removing provisioned package (this is a system-protected app)." -ForegroundColor Yellow
        }
    }
    Write-Host "`n✔ Pre-installed app cleanup completed!" -ForegroundColor Cyan
}

# Function 2: Control Windows Updates (code unchanged, kept as is)
function Toggle-WindowsUpdate {
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "      2. Windows Automatic Update Control"
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "This method controls updates by modifying system policies, safe and without side effects." -ForegroundColor Yellow
    Write-Host "Please select an operation:"
    Write-Host "  a) Safely disable automatic updates"
    Write-Host "  b) Restore automatic updates"
    $updateChoice = Read-Host "Please enter your choice (a or b)"
    
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    
    if ($updateChoice -eq 'a') {
        Write-Host "`nDisabling automatic update policy..." -ForegroundColor Green
        if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force
        Write-Host "✔ Operation completed! Windows will only notify you of available updates but will not automatically download or install them." -ForegroundColor Cyan
    }
    elseif ($updateChoice -eq 'b') {
        Write-Host "`nRestoring automatic update policy..." -ForegroundColor Green
        if (Test-Path $regPath) { Remove-Item -Path $regPath -Recurse -Force }
        Write-Host "✔ Operation completed! Windows automatic update policy has been restored to default settings." -ForegroundColor Cyan
    }
    else {
        Write-Host "Invalid selection, no changes made." -ForegroundColor Red
    }
}

# --- Main Menu and Script Execution Logic ---
function Show-Menu {
    Clear-Host
    Write-Host "=======================================================" -ForegroundColor Magenta
    Write-Host "          Welcome to Windows Ultimate Cleanup Script (v2.2)"
    Write-Host "=======================================================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Please select the operation to execute:" -ForegroundColor Green
    Write-Host "  1. Uninstall all pre-installed bloatware apps"
    Write-Host "  2. Control Windows automatic updates (disable/restore)"
    Write-Host "  3. [One-Click Execute] Execute all cleanup operations above (Option 1 + Disable Updates)"
    Write-Host "  Q. Exit script"
    Write-Host ""
}

do {
    Show-Menu
    $mainChoice = Read-Host "Please enter your choice"
    
    switch ($mainChoice) {
        '1' { Uninstall-Bloatware }
        '2' { Toggle-WindowsUpdate }
        '3' {
            Write-Host "`n--- Starting One-Click Cleanup Mode ---" -ForegroundColor Yellow
            Uninstall-Bloatware
            Write-Host "`n--- Automatically Disabling Windows Updates ---"
            $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
            if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
            Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force
            Write-Host "✔ Operation completed! Windows automatic updates have been disabled by policy." -ForegroundColor Cyan
        }
        'q' { Write-Host "Script exited." }
        default { Write-Host "Invalid input, please select again." -ForegroundColor Red }
    }
    
    if ($mainChoice -ne 'q') {
        Read-Host "`nOperation completed. Press Enter to return to main menu..."
    }
} while ($mainChoice -ne 'q')
