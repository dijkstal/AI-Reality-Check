@echo off
title AI Reality Check - KERNLIJN
cd /d "%~dp0"

echo.
echo  ============================================
echo   AI Reality Check - KERNLIJN
echo  ============================================
echo.

REM --- Probeer Python (meest gangbaar) ---
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo  Server gestart op http://localhost:3000
    echo  Druk op Ctrl+C om te stoppen.
    echo.
    start "" "http://localhost:3000"
    python -m http.server 3000
    goto :einde
)

python3 --version >nul 2>&1
if %errorlevel% == 0 (
    echo  Server gestart op http://localhost:3000
    echo  Druk op Ctrl+C om te stoppen.
    echo.
    start "" "http://localhost:3000"
    python3 -m http.server 3000
    goto :einde
)

REM --- Probeer Node.js / npx serve ---
where npx >nul 2>&1
if %errorlevel% == 0 (
    echo  Server gestart op http://localhost:3000
    echo  Druk op Ctrl+C om te stoppen.
    echo.
    start "" "http://localhost:3000"
    npx serve -p 3000 .
    goto :einde
)

REM --- Noodoplossing: open direct als bestand ---
echo  Geen lokale server gevonden (Python of Node.js niet geinstalleerd).
echo  De app wordt direct geopend in je browser.
echo  Let op: sommige deelfuncties werken mogelijk niet via file://
echo.
start "" "index.html"

:einde
