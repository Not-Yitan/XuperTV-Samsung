@echo off
setlocal EnableExtensions
title Xuper TV - Servidor MODO TV ANTIGUA (H.264)
cd /d "%~dp0"

echo.
echo   ================================================================
echo      Servidor de Xuper TV (para Samsung y Roku)
echo   ================================================================
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo   [X] No encuentro Node.js.
    echo       Instalalo con:  winget install OpenJS.NodeJS.LTS
    echo       o desde https://nodejs.org  y vuelve a abrir este archivo.
    echo.
    pause
    exit /b 1
)

rem ffmpeg: del sistema (PATH) o ffmpeg.exe dentro de la carpeta server
set "FFMPEG_PATH="
for /f "delims=" %%F in ('where ffmpeg 2^>nul') do if not defined FFMPEG_PATH set "FFMPEG_PATH=%%F"
if not defined FFMPEG_PATH if exist "%~dp0server\ffmpeg.exe" set "FFMPEG_PATH=%~dp0server\ffmpeg.exe"
if not defined FFMPEG_PATH (
    echo   [!] No encuentro ffmpeg: funciona la reproduccion normal,
    echo       pero no el "Modo fluido".  Instalalo con:
    echo       winget install Gyan.FFmpeg
    echo.
)

rem Modo TV antigua: convierte todo el video a H.264 (usa bastante CPU)
set "XUPER_TRANSCODE=1"
set "XUPER_FORCE_RELAY=1"
if not defined FFMPEG_PATH (
    echo   [X] Este modo necesita ffmpeg:  winget install Gyan.FFmpeg
    pause
    exit /b 1
)

rem IP del PC: se puede pasar como argumento si se detecta mal
if not "%~1"=="" set "XUPER_PUBLIC_HOST=%~1"

echo   Deja esta ventana abierta mientras uses la app en la TV.
echo   Si pide permiso el Firewall de Windows, pulsa "Permitir acceso".
echo.
node "%~dp0server\server.js"
echo.
pause
