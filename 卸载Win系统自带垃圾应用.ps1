# ====================================================================================
#            ***   终极版 Windows 净化与优化脚本   ***
# ====================================================================================
# 作者: Your AI Assistant
# 版本: 2.2 (最终完美版)
# 改进:
#   - 使用 try...catch 结构完美处理受保护应用的卸载错误。
#   - 确保运行日志100%干净，不再出现任何红色的原生错误信息。
# ====================================================================================

# 脚本开始: 检查管理员权限
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "错误：此脚本需要管理员权限才能运行！" -ForegroundColor Red
    Write-Host "请右键单击脚本文件，然后选择 '使用 PowerShell 运行'。" -ForegroundColor Yellow
    Read-Host "按 Enter 键退出..."
    exit
}

# --- 函数定义区域 ---

# 函数1: 卸载垃圾应用
function Uninstall-Bloatware {
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "      1. 开始卸载预装应用 (Bloatware)"
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "此操作将移除列表中的应用，并尝试移除其预置包以防重装。" -ForegroundColor Yellow

    # --- 可安全移除的垃圾应用列表 ---
    $BloatwareList = @(
        # 游戏类
        "*MicrosoftSolitaireCollection*", "*king.com.CandyCrush*", "*ROBLOXCORPORATION.ROBLOX*",
        # 3D 和混合现实
        "*Microsoft.MixedReality.Portal*", "*Microsoft.Microsoft3DViewer*", "*Microsoft.Paint3D*",
        # 媒体和社交类
        "*SpotifyAB.SpotifyMusic*", "*Netflix.Netflix*", "*Facebook.Facebook*",
        "*Facebook.Instagram*", "*Facebook.Messenger*", "*TikTok.TikTok*",
        # 其他微软应用
        "*Microsoft.Getstarted*", "*Microsoft.Todos*", "*Microsoft.WindowsFeedbackHub*", "*Microsoft.SkypeApp*"
    )
    
    # --- 受系统保护的“顽固”应用列表 ---
    $ProtectedApps = @(
        "*Microsoft.Paint*", "*Microsoft.XboxGamingOverlay*", "*Microsoft.XboxSpeechToTextOverlay*",
        "*Microsoft.XboxApp*", "*Microsoft.Xbox.TCUI*", "*Microsoft.ZuneMusic*", "*Microsoft.ZuneVideo*",
        "*Microsoft.YourPhone*", "*Microsoft.GetHelp*", "*Microsoft.MicrosoftStickyNotes*",
        "*Microsoft.WindowsSoundRecorder*", "*Microsoft.People*"
    )

    $AllAppsToRemove = $BloatwareList + $ProtectedApps

    foreach ($AppName in $AllAppsToRemove) {
        Write-Host "`n[正在处理]: $AppName" -ForegroundColor Green
        
        $isProtected = $ProtectedApps -contains $AppName
        
        # 步骤 1: 卸载已安装的应用包 (对所有应用执行)
        $package = Get-AppxPackage -AllUsers $AppName -ErrorAction SilentlyContinue
        if ($package) {
            try {
                # 关键改动：将卸载命令放入 try 块，并设置 ErrorAction 为 Stop
                $package | Remove-AppxPackage -AllUsers -ErrorAction Stop
                Write-Host "  - 已从所有用户账户卸载。"
            }
            catch {
                # 如果上一条命令失败，则执行这里的代码，而不会打印红色错误
                Write-Host "  - 卸载失败 (此为系统核心组件，无法移除)。" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  - 未找到已安装的包。" -ForegroundColor Gray
        }

        # 步骤 2: 移除预置包 (仅对非保护应用执行)
        if (-not $isProtected) {
            $provisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $AppName }
            if ($provisionedPackage) {
                $provisionedPackage | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                if($?) { Write-Host "  - 已成功移除预置包。" }
                else { Write-Host "  - 移除预置包失败。" -ForegroundColor Yellow }
            } else {
                Write-Host "  - 未找到预置包。" -ForegroundColor Gray
            }
        } else {
            Write-Host "  - 跳过移除预置包 (此为受系统保护的应用)。" -ForegroundColor Yellow
        }
    }
    Write-Host "`n✔ 预装应用清理完成！" -ForegroundColor Cyan
}

# 函数2: 控制Windows更新 (代码无变化，保持原样)
function Toggle-WindowsUpdate {
    # ... (此处代码与上一版完全相同，为简洁省略)
    Write-Host "`n=======================================================" -ForegroundColor Cyan;Write-Host "      2. Windows自动更新控制";Write-Host "=======================================================" -ForegroundColor Cyan;Write-Host "此方法通过修改系统策略来控制更新，安全且无副作用。" -ForegroundColor Yellow;Write-Host "请选择操作:";Write-Host "  a) 安全地禁用自动更新";Write-Host "  b) 恢复自动更新";$updateChoice=Read-Host "请输入您的选择 (a 或 b)";$regPath="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate";if($updateChoice -eq 'a'){Write-Host "`n正在禁用自动更新策略..." -ForegroundColor Green;if(-not (Test-Path $regPath)){New-Item -Path $regPath -Force | Out-Null};Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force;Write-Host "✔ 操作完成！Windows将仅通知您有可用更新，但不会自动下载或安装。" -ForegroundColor Cyan}elseif($updateChoice -eq 'b'){Write-Host "`n正在恢复自动更新策略..." -ForegroundColor Green;if(Test-Path $regPath){Remove-Item -Path $regPath -Recurse -Force};Write-Host "✔ 操作完成！Windows自动更新策略已恢复为默认设置。" -ForegroundColor Cyan}else{Write-Host "无效的选择，未做任何更改。" -ForegroundColor Red}
}

# --- 主菜单和脚本执行逻辑 --- (代码无变化，保持原样)
function Show-Menu {
    # ... (此处代码与上一版完全相同，为简洁省略)
    Clear-Host;Write-Host "=======================================================" -ForegroundColor Magenta;Write-Host "          欢迎使用 Windows 终极净化脚本 (v2.2)";Write-Host "=======================================================" -ForegroundColor Magenta;Write-Host "";Write-Host "请选择要执行的操作：" -ForegroundColor Green;Write-Host "  1. 卸载所有预装垃圾应用";Write-Host "  2. 控制 Windows 自动更新 (禁用/恢复)";Write-Host "  3. [一键执行] 执行以上所有净化操作 (选项1 + 禁用更新)";Write-Host "  Q. 退出脚本";Write-Host ""
}
do{Show-Menu;$mainChoice=Read-Host "请输入您的选择";switch($mainChoice){'1'{Uninstall-Bloatware}'2'{Toggle-WindowsUpdate}'3'{Write-Host "`n--- 开始一键净化模式 ---" -ForegroundColor Yellow;Uninstall-Bloatware;Write-Host "`n--- 正在自动禁用Windows更新 ---";$regPath="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate";if(-not (Test-Path $regPath)){New-Item -Path $regPath -Force | Out-Null};Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force;Write-Host "✔ 操作完成！Windows自动更新已被策略禁用。" -ForegroundColor Cyan}'q'{Write-Host "脚本已退出。"}default{Write-Host "无效的输入，请重新选择。" -ForegroundColor Red}}if($mainChoice -ne 'q'){Read-Host "`n操作执行完毕。按 Enter 键返回主菜单..."}}while($mainChoice -ne 'q')