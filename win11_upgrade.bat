@echo off
title Windows 11 Upgrade
color 0A

set "root=C:\Win11Upgrade"
set "zip=%root%\Win11Upgrade.zip"
set "url=https://github.com/kountilya/Win11InPlaceUpgrade/archive/refs/heads/main.zip"
set "extract=%root%\Win11InPlaceUpgrade-main"
set "ps1=%extract%\Install.ps1"

mkdir "%root%" >nul 2>&1

echo Downloading package...
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
    "Invoke-WebRequest -Uri '%url%' -OutFile '%zip%' -UseBasicParsing"

echo Extracting...
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
    "Expand-Archive -Path '%zip%' -DestinationPath '%root%' -Force"

echo Starting upgrade...
powershell -ExecutionPolicy Bypass -NoProfile -File "%ps1%"
