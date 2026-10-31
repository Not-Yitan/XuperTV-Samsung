@echo off
setlocal EnableExtensions
title Xuper TV - Configurar la app de Samsung
cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
    echo   [X] Falta Node.js:  winget install OpenJS.NodeJS.LTS
    pause
    exit /b 1
)

set "IP=%~1"
if "%IP%"=="" set /p "IP=  IP de este PC (ej. 192.168.1.95): "
if "%IP%"=="" exit /b 1
set "PORT=%~2"
if "%PORT%"=="" set "PORT=8910"

node "%~dp0configurar.js" %IP% %PORT%
if errorlevel 1 (
    pause
    exit /b 1
)
echo.
echo   Ahora abre la carpeta "tizen" en Tizen Studio e instalala en la TV.
echo.
pause
