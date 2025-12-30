@echo off
setlocal EnableExtensions DisableDelayedExpansion

rem 处理 UTF-8 字符
chcp 65001 >nul

rem 始终在脚本所在目录中操作
cd /d "%~dp0"
set "CEMU_DIR=%CD%"
set "CEMU_EXE=%CEMU_DIR%\Cemu.exe"
set "SOURCE_PACK=%CEMU_DIR%\BreathOfTheWild_BetterVR"
set "LOG=%CEMU_DIR%\BetterVR_install.log"
set "ROBOLOG=%CEMU_DIR%\robocopy_debug.log"

call :Log "=== BetterVR 启动器已开始运行 ==="
call :Log "工作目录: %CEMU_DIR%"

rem 1) 硬性要求：Cemu.exe 必须在脚本旁边
if not exist "%CEMU_EXE%" (
  call :Log "错误：在脚本旁边未找到 Cemu.exe。正在退出。"
  call :Popup "在此脚本旁边未找到 Cemu.exe。请将此 .bat 文件放在 Cemu.exe 旁边（或以 Cemu 的文件夹作为工作目录启动），然后重试。" "BetterVR 错误"
  exit /b 1
)

rem 1.5) 检查 Cemu 版本 (要求 2.6+)
powershell -NoProfile -Command "$v=[System.Diagnostics.FileVersionInfo]::GetVersionInfo('%CEMU_EXE%'); if ($v.FileMajorPart -lt 2 -or ($v.FileMajorPart -eq 2 -and $v.FileMinorPart -lt 6)) { exit 1 }"
if errorlevel 1 (
  call :Log "警告：Cemu 版本低于 2.6。"
  call :Popup "警告：您似乎正在使用旧版本的 Cemu。BetterVR 是为 Cemu 2.6 或更高版本设计的。您可能会遇到问题。" "BetterVR 警告"
)

rem 2) 根据 portable/settings.xml/appdata 选择安装目标
set "MODE="
set "TARGET_BASE="

if exist "%CEMU_DIR%\portable\" (
  set "MODE=portable"
  set "TARGET_BASE=%CEMU_DIR%\portable\graphicPacks"
) else if exist "%CEMU_DIR%\settings.xml" (
  set "MODE=settings.xml"
  set "TARGET_BASE=%CEMU_DIR%\graphicPacks"
) else (
  set "MODE=appdata"
  set "TARGET_BASE=%APPDATA%\Cemu\graphicPacks"
)

call :Log "安装模式: %MODE%"
call :Log "目标路径: %TARGET_BASE%"

rem 3) 如果源资源包丢失，记录日志并决定是否继续
if exist "%SOURCE_PACK%\" goto SourcePackFound

call :Log "警告：在 Cemu.exe 旁边未找到源资源包文件夹：%SOURCE_PACK%"

rem 按照要求记录“用户可能手动删除了 graphicPacks”的提示
if "%MODE%"=="portable" goto CheckPortable
if "%MODE%"=="settings.xml" goto CheckSettings
goto CheckAppData

:CheckPortable
if exist "%CEMU_DIR%\portable\" if not exist "%CEMU_DIR%\portable\graphicPacks\" (
  call :Log "注意：portable 文件夹存在，但 portable\graphicPacks 缺失。用户可能手动删除了 graphicPacks 文件夹。"
)
goto CheckDone

:CheckSettings
if exist "%CEMU_DIR%\settings.xml" if not exist "%CEMU_DIR%\graphicPacks\" (
  call :Log "注意：settings.xml 存在，但 graphicPacks 缺失。用户可能手动删除了 graphicPacks 文件夹。"
)
goto CheckDone

:CheckAppData
if not exist "%APPDATA%\Cemu\graphicPacks\" (
  call :Log "注意：%APPDATA%\Cemu\graphicPacks 缺失。用户可能手动删除了 graphicPacks 文件夹。"
)

:CheckDone
call :CheckExistingInstall
if "%FOUND_INSTALL%"=="1" (
  call :Log "信息：在某处发现了现有的 BreathOfTheWild_BetterVR，但源包文件夹丢失。保留现有安装不变。"
  goto LaunchCemu
)

call :Log "错误：在任何已知位置均未找到源包文件夹，也未找到现有安装。"
call :Popup "在 Cemu.exe 旁边未找到 BreathOfTheWild_BetterVR 文件夹，且未安装在任何已知的 graphicPacks 位置。请将 BreathOfTheWild_BetterVR 文件夹放在 Cemu.exe 旁边，然后重试。" "BetterVR 错误"
exit /b 2

:SourcePackFound

rem 4) 确保目标基础文件夹存在
if not exist "%TARGET_BASE%\" (
  mkdir "%TARGET_BASE%" 2>nul
  if errorlevel 1 (
    call :Log "错误：无法创建目标文件夹：%TARGET_BASE%"
    call :Popup "创建 graphicPacks 文件夹失败。请检查权限并重试。" "BetterVR 错误"
    exit /b 3
  )
  call :Log "已创建目标基础文件夹。"
)

rem 5) 删除目标中现有的包文件夹（删除并替换）
set "TARGET_PACK=%TARGET_BASE%\BreathOfTheWild_BetterVR"
if exist "%TARGET_PACK%\" (
  call :Log "信息：正在删除现有的目标包文件夹：%TARGET_PACK%"
  rmdir /s /q "%TARGET_PACK%" 2>nul
)

rem 6) 安装（移动语义）
rem 首先尝试 robocopy /MOVE。如果失败且代码严重（8+），则重试复制后删除。
call :InstallPack "%SOURCE_PACK%" "%TARGET_PACK%"
if %RC% GEQ 8 (
  call :Log "错误：安装失败 (robocopy RC=%RC%)。调试日志保留在：%ROBOLOG%"
  call :Popup "安装 BreathOfTheWild_BetterVR 失败 (robocopy RC=%RC%)。请打开 Cemu.exe 旁边的 robocopy_debug.log 查看具体原因。" "BetterVR 错误"
  exit /b 4
)

call :Log "信息：安装完成。"

:LaunchCemu
rem 7) 设置环境变量并启动 Cemu
set VK_LAYER_PATH=.\;%VK_LAYER_PATH%
set VK_INSTANCE_LAYERS=VK_LAYER_CREMENTIF_bettervr
set VK_LOADER_DEBUG=all
set VK_LOADER_DISABLE_INST_EXT_FILTER=1
set DISABLE_VULKAN_OBS_CAPTURE=1
set DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1

call :Log "正在启动 Cemu.exe"

rem 检查 UAC 状态
set "UAC_DISABLED=0"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" 2>nul | find  "0x0" >NUL
if "%ERRORLEVEL%"=="0" (
  set "UAC_DISABLED=1"
  call :Log "警告：UAC 已禁用 (ConsentPromptBehaviorAdmin=0x0)。"
  call :Popup "警告：用户账户控制 (UAC) 已禁用。这将强制 Cemu 以管理员身份运行，可能会破坏 VR 功能。正在尝试以降低的权限启动。" "BetterVR 警告"
) else (
  call :Log "信息：UAC 已启用。"
)

start "" "%CEMU_EXE%"
exit /b 0


:InstallPack
set "SRC=%~1"
set "DST=%~2"
set "RC=999"

call :Log "信息：正在安装包，从 '%SRC%' 到 '%DST%'"

rem 尝试安装开始时删除旧的调试日志
del /q "%ROBOLOG%" 2>nul

call :Log "信息：Robocopy 第 1 步：移动 (MOVE)"
robocopy "%SRC%" "%DST%" /E /MOVE /R:0 /W:0 /V /LOG:"%ROBOLOG%" >nul
set "RC=%errorlevel%"
call :Log "信息：Robocopy 移动返回码 RC=%RC%"

if %RC% LSS 8 goto InstallSuccess

call :Log "警告：Robocopy 移动失败 (RC=%RC%)。重试：复制然后删除。"

rem 重试前确保目标是干净的
if exist "%DST%\" (
  rmdir /s /q "%DST%" 2>nul
)

call :Log "信息：Robocopy 第 2 步：复制 (COPY)"
robocopy "%SRC%" "%DST%" /E /R:0 /W:0 /V /LOG+:"%ROBOLOG%" >nul
set "RC=%errorlevel%"
call :Log "信息：Robocopy 复制返回码 RC=%RC%"

if %RC% GEQ 8 goto InstallEnd

call :Log "信息：复制成功，正在删除源文件夹以完成移动语义。"
rmdir /s /q "%SRC%" 2>nul

:InstallSuccess
rem 如果整体成功，删除调试日志，只保留错误时的日志
del /q "%ROBOLOG%" 2>nul

:InstallEnd
exit /b


:CheckExistingInstall
set "FOUND_INSTALL=0"
if exist "%CEMU_DIR%\portable\graphicPacks\BreathOfTheWild_BetterVR\" set "FOUND_INSTALL=1"
if exist "%CEMU_DIR%\graphicPacks\BreathOfTheWild_BetterVR\" set "FOUND_INSTALL=1"
if exist "%APPDATA%\Cemu\graphicPacks\BreathOfTheWild_BetterVR\" set "FOUND_INSTALL=1"
exit /b


:Log
>>"%LOG%" echo [%DATE% %TIME%] %1
exit /b


:Popup
set "MSG=%~1"
set "TTL=%~2"

rem 首选 PowerShell 消息框，回退到 mshta 弹窗
powershell -NoProfile -Command ^
  "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show(\"%MSG%\",\"%TTL%\") | Out-Null" 2>nul

if errorlevel 1 (
  mshta "javascript:var sh=new ActiveXObject('WScript.Shell'); sh.Popup('%MSG%',0,'%TTL%',48); close();" >nul 2>&1
)
exit /b