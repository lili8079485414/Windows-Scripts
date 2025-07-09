# Windows System Optimization Toolkit

> **🌐 Language**: [中文版 (Chinese)](README.md) | **English**

## 📋 Project Overview

This project contains two professional PowerShell scripts designed to optimize and clean Windows systems by removing unnecessary pre-installed applications and controlling system update policies.

> **🎯 Design Philosophy**: Safe, Reversible, User-Friendly - Restore Windows to its pure state and enhance user experience

## 📁 File Description

### 1. `Remove-Windows-Bloatware.ps1` (English) / `卸载系统自带垃圾应用.ps1` (Chinese)
**Ultimate Windows Cleanup & Optimization Script v2.2**

#### Key Features
- ✅ **Smart Bloatware Removal**: Safely remove games, social media, entertainment and other unnecessary apps
- ✅ **Perfect Error Handling**: Uses try-catch structure to handle protected app removal errors
- ✅ **Dual Cleanup Mechanism**: Removes both installed packages and provisioned packages to prevent app reinstallation
- ✅ **System Stability Protection**: Intelligently identifies system core components to avoid deleting important apps
- ✅ **Interactive Menu**: Provides user-friendly interface with single-item or one-click execution options

#### Supported App Categories for Removal
- **🎮 Gaming**: Solitaire, Candy Crush, Roblox, etc.
- **🥽 3D/Mixed Reality**: 3D Viewer, Paint 3D, Mixed Reality Portal
- **📱 Media & Social**: Spotify, Netflix, Facebook, Instagram, TikTok, etc.
- **🔧 Other Microsoft Apps**: Feedback Hub, Skype, Get Started, Sticky Notes, etc.
- **🛡️ Protected Apps**: Xbox components, Paint, Voice Recorder, etc. (removal attempted but may fail)

### 2. `Disable-Windows-Updates.ps1` (English) / `彻底禁用Windows更新.ps1` (Chinese)
**Windows Update Security Policy Control Script**

#### Key Features
- ✅ **Security Policy Control**: Controls updates through registry policy modification without disabling system services
- ✅ **Reversible Operations**: Supports both disabling and restoring automatic update policies
- ✅ **System Stability**: Does not affect Start Menu or other system functions
- ✅ **Simple & Efficient**: Focused on update control with straightforward operations

## 🚀 Usage Instructions

### Prerequisites
- Windows 10/11 Operating System
- Administrator privileges
- PowerShell 5.0 or higher

### Execution Methods

#### Method 1: Right-Click Run (Recommended)
1. Right-click on the `.ps1` script file
2. Select **"Run with PowerShell"**
3. Click **"Yes"** in the UAC dialog box

#### Method 2: PowerShell Command Line
```powershell
# Open PowerShell as Administrator
# Navigate to script directory
cd "path\to\script\directory"

# Run bloatware removal script (English version)
.\Remove-Windows-Bloatware.ps1
# Or run Chinese version
.\卸载系统自带垃圾应用.ps1

# Run update control script (English version)
.\Disable-Windows-Updates.ps1
# Or run Chinese version
.\彻底禁用Windows更新.ps1
```

#### Method 3: Batch File Execution
Create a `.bat` file to automatically run with administrator privileges:
```batch
@echo off
REM For English version
powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0Remove-Windows-Bloatware.ps1\"' -Verb RunAs"

REM For Chinese version
REM powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0卸载系统自带垃圾应用.ps1\"' -Verb RunAs"
```

### Execution Policy Setup
If you encounter execution policy restrictions, run first:
```powershell
# Temporarily allow script execution (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass execution policy (single run)
powershell -ExecutionPolicy Bypass -File "script_path"
```

## 📖 User Guide

### Bloatware Removal Script Options
1. **Option 1**: Remove pre-installed bloatware apps only
2. **Option 2**: Control Windows automatic updates only
3. **Option 3**: One-click execute all cleanup operations (recommended)
4. **Option Q**: Exit script

### Windows Update Control Options
1. **Option 1**: Safely disable automatic updates
2. **Option 2**: Restore automatic update policy
3. **Option Q**: Exit script

## ⚠️ Important Notes

### Security Guarantees
- ✅ All operations are reversible and won't permanently damage the system
- ✅ Intelligently identifies system core components to avoid accidental deletion
- ✅ Uses official Windows APIs for safe and reliable operation
- ✅ Does not modify system services, maintaining system stability

### Precautions
- 🔸 **Recommended to create a system restore point before running**
- 🔸 Some protected apps may not be completely removable (this is normal)
- 🔸 After disabling updates, manually check for important security updates periodically
- 🔸 To restore an app, reinstall it through Microsoft Store
- 🔸 Enterprise or Education editions may have additional Group Policy restrictions
- 🔸 Some apps may reappear after major system updates

### Compatibility Information
| Windows Version | Compatibility | Notes |
|----------------|---------------|-------|
| Windows 11 | ✅ Full Support | Recommended |
| Windows 10 (2004+) | ✅ Full Support | Recommended |
| Windows 10 (1903-1909) | ⚠️ Partial Support | Some apps may not be removable |
| Windows 10 (Below 1903) | ❌ Not Recommended | May have compatibility issues |

## 🔧 Technical Details

### Core Technologies
- **PowerShell 5.0+**: Script runtime environment
- **AppX Package Management**: Uses `Get-AppxPackage` and `Remove-AppxPackage`
- **Registry Policies**: Controls updates through `HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate`
- **Error Handling**: try-catch structure ensures stable execution

### Modified Registry Keys
```
HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate
├── NoAutoUpdate (DWORD): 1 = Disable, Delete = Enable
└── AUOptions (DWORD): 2 = Notify only
```

## 📝 Version History

### v2.2 (Current) - July 9, 2025
- ✨ Improved error handling mechanism, eliminated runtime red error messages
- 🔧 Optimized protected app handling logic
- 🎨 Enhanced user experience and operation feedback
- 🛡️ Improved system compatibility and stability

### v2.1
- ➕ Added one-click cleanup mode
- 📊 Optimized app categorization and handling strategy
- 🎨 Improved menu interface design

### v2.0
- 🔄 Refactored code architecture
- ➕ Added Windows update control functionality
- 🛡️ Enhanced security and stability

## 🔍 Frequently Asked Questions (FAQ)

### Q: Some apps remain after running the script, is this normal?
A: Yes, certain system core apps (like Xbox components) are protected and cannot be completely removed. This is Windows' security mechanism.

### Q: How to manually check for updates after disabling them?
A: You can manually check and install updates through "Settings → Update & Security → Windows Update".

### Q: How to restore accidentally deleted apps?
A: Most apps can be reinstalled through Microsoft Store, or let the system automatically reinstall after restoring update policy.

### Q: Will the script affect system stability?
A: No. The script only removes non-essential apps and modifies update policies without touching system core components.

## 🤝 Support & Feedback

If you encounter issues or have suggestions for improvement:
1. Check if running with administrator privileges
2. Verify PowerShell version compatibility
3. Review error messages and refer to this documentation
4. Check Windows version compatibility

### Troubleshooting
- **Insufficient Privileges**: Ensure running PowerShell as Administrator
- **Execution Policy Restriction**: Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **App Cannot Be Uninstalled**: Some system-protected apps are normal
- **Update Policy Ineffective**: Check if Enterprise Windows has domain policy restrictions

## 📄 License & Disclaimer

This project is for educational and personal use only. Please comply with relevant laws and regulations. Users are responsible for any consequences resulting from using this script.

**Disclaimer**:
- This tool will not intentionally damage the system, but backing up important data before use is recommended
- The author is not responsible for any losses caused by using this tool
- Please use with caution after fully understanding the script functionality

---

## 🚀 Quick Start Guide

### Recommended Process for Beginners
1. **Create System Restore Point** (Control Panel → System → System Protection)
2. **Right-click** `Remove-Windows-Bloatware.ps1` (English) or `卸载系统自带垃圾应用.ps1` (Chinese)
3. **Select** "Run with PowerShell"
4. **Choose Option 3** One-click cleanup mode
5. **Wait for completion** and restart system

### Advanced Users
- Can run both scripts separately for fine-grained control
- Supports command-line parameters and automated deployment
- Can be integrated into system deployment scripts

**⚡ Quick Start**: `Remove-Windows-Bloatware.ps1` → Right-click run → Option 3 → Done!
