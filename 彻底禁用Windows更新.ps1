# ====================================================================================
# Windows Update 安全禁用/启用脚本 (仅修改策略，不禁用服务)
# ====================================================================================

# 检查管理员权限
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "错误：请以管理员身份运行此脚本。" -ForegroundColor Red
    Read-Host "按 Enter 键退出..."
    exit
}

function Toggle-UpdatePolicy {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "     Windows Update 安全策略控制脚本"
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "此脚本通过修改注册表策略来控制更新，不会禁用服务，" -ForegroundColor Yellow
    Write-Host "因此不会影响开始菜单等系统功能。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请选择："
    Write-Host "  1. 安全地禁用自动更新"
    Write-Host "  2. 恢复自动更新策略"
    Write-Host "  Q. 退出"
    $choice = Read-Host "请输入您的选择 (1, 2, or Q)"

    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"

    switch ($choice) {
        '1' {
            Write-Host "`n正在禁用自动更新策略..." -ForegroundColor Green
            if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
            Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force # 2 = 通知下载和安装
            Write-Host "✔ 操作完成！自动更新已被策略禁用。" -ForegroundColor Cyan
        }
        '2' {
            Write-Host "`n正在恢复自动更新策略..." -ForegroundColor Green
            if (Test-Path $regPath) { Remove-Item -Path $regPath -Recurse -Force }
            Write-Host "✔ 操作完成！更新策略已恢复为默认。" -ForegroundColor Cyan
        }
        default {
            Write-Host "已退出，未做任何更改。"
        }
    }
    Read-Host "`n按 Enter 键退出..."
}

Toggle-UpdatePolicy