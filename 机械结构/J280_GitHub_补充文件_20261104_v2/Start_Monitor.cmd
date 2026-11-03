@echo off
setlocal
cd /d "%~dp0"
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

if not exist "host\monitor\clean_monitor.py" (
    echo Missing host\monitor\clean_monitor.py.
    echo Copy the complete host package into host, preserving monitor and config.
    echo See docs\UPLOAD_CHECKLIST.md.
    pause
    exit /b 2
)

if exist "%~dp0.venv\Scripts\python.exe" (
    set "J280_PYTHON=%~dp0.venv\Scripts\python.exe"
    set "J280_PYTHON_ARGS="
    goto python_ready
)
where py >nul 2>nul
if not errorlevel 1 (
    set "J280_PYTHON=py"
    set "J280_PYTHON_ARGS=-3"
    goto python_ready
)
where python >nul 2>nul
if not errorlevel 1 (
    set "J280_PYTHON=python"
    set "J280_PYTHON_ARGS="
    goto python_ready
)
echo Python 3 was not found. Install Python with Tcl/Tk support.
pause
exit /b 3

:python_ready
"%J280_PYTHON%" %J280_PYTHON_ARGS% -c "import sys, tkinter, serial; assert sys.version_info.major == 3"
if errorlevel 1 (
    echo Python, tkinter or pyserial is not ready.
    echo Install requirements.txt with the same Python interpreter.
    echo See docs\BUILD_AND_RUN.md.
    pause
    exit /b 4
)

cd /d "%~dp0host"
"%J280_PYTHON%" %J280_PYTHON_ARGS% -X utf8 "monitor\clean_monitor.py"
set "J280_MONITOR_RC=%ERRORLEVEL%"
if not "%J280_MONITOR_RC%"=="0" (
    echo Monitor exit code: %J280_MONITOR_RC%
    pause
)
exit /b %J280_MONITOR_RC%
