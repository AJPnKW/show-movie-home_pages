@echo off
setlocal

REM Resolve the folder this BAT lives in (with trailing backslash)
set "SCRIPT_DIR=%~dp0"

REM Always open a new console that stays open (cmd /k) and run the PS1
start "GenerateIndex" cmd /k ^
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%generate_index_from_docs.ps1"

endlocal
