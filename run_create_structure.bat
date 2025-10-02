@echo off
setlocal

REM Resolve the folder this BAT lives in (with trailing backslash)
set "SCRIPT_DIR=%~dp0"

REM Run PowerShell in a new console that stays open (cmd /k),
REM launching the PS1 beside this BAT. All paths are quoted.
start "ShowPagesSetup" cmd /k ^
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%run_create_structure.ps1"

endlocal
