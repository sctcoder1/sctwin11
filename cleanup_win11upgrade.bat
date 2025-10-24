@echo off
title Windows 11 Upgrade Cleanup
color 0A
echo.
echo ===========================================================
echo        Windows 11 Upgrade Cleanup and Finalization
echo ===========================================================

:: --- Ensure admin privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- Remove upgrade working folder ---
set "upgdir=C:\Win11Upgrade"
if exist "%upgdir%" (
    echo Removing %upgdir% ...
    rmdir /s /q "%upgdir%"
) else (
    echo %upgdir% not found, skipping.
)

:: --- Remove Win11_Upgrade.bat from all user desktops ---
echo.
echo Removing Win11_Upgrade.bat from user desktops...
for /d %%A in ("C:\Users\*") do (
    if exist "%%A\Desktop\Win11_Upgrade.bat" (
        echo Deleting %%A\Desktop\Win11_Upgrade.bat ...
        del /f /q "%%A\Desktop\Win11_Upgrade.bat"
    )
)
if exist "C:\Users\Public\Desktop\Win11_Upgrade.bat" (
    echo Deleting from Public Desktop...
    del /f /q "C:\Users\Public\Desktop\Win11_Upgrade.bat"
)

:: --- Uninstall Windows 11 Installation Assistant ---
echo.
echo Uninstalling Windows 11 Installation Assistant...
if exist "C:\Program Files (x86)\WindowsInstallationAssistant\Windows10UpgraderApp.exe" (
    start "" /wait "C:\Program Files (x86)\WindowsInstallationAssistant\Windows10UpgraderApp.exe" /SunValley /ForceUninstall
    echo Uninstall command executed.
) else (
    echo Windows 11 Installation Assistant not found at expected path.
)

:: --- Remove leftover folders ---
echo.
echo Cleaning up leftover folders if any...
rd /s /q "C:\Program Files\Windows 11 Installation Assistant" 2>nul
rd /s /q "C:\Program Files (x86)\Windows 11 Installation Assistant" 2>nul
rd /s /q "%ProgramData%\Microsoft\Windows\Windows 11 Installation Assistant" 2>nul
rd /s /q "C:\Program Files (x86)\WindowsInstallationAssistant" 2>nul

:: --- Schedule self-deletion on reboot ---
echo.
echo Scheduling self-deletion...
set "self=%~f0"
schtasks /create /tn "CleanupDeleteSelf" /sc onstart /ru SYSTEM /rl HIGHEST ^
 /tr "cmd /c del /f /q \"%self%\" & schtasks /delete /tn CleanupDeleteSelf /f" >nul 2>&1

echo.
echo ===========================================================
echo   Cleanup complete. System will reboot in 15 seconds...
echo ===========================================================
timeout /t 15 /nobreak >nul
shutdown /r /t 5 /c "Windows 11 Upgrade cleanup complete. Rebooting..."
exit /b 0
