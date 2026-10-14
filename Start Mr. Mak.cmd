@echo off
setlocal
set "MRMAK_LAUNCH_ROOT=%~dp0"
set "MRMAK_LOCAL_ROOT="
for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File "%MRMAK_LAUNCH_ROOT%scripts\prepare-local-workspace.ps1"`) do set "MRMAK_LOCAL_ROOT=%%I"
if not defined MRMAK_LOCAL_ROOT (
  echo Could not prepare the private local workspace. The app was not started.
  pause
  exit /b 1
)
if exist "%LOCALAPPDATA%\Mr. Mak Workspace\mrmak-workspace.exe" (
  start "" "%LOCALAPPDATA%\Mr. Mak Workspace\mrmak-workspace.exe" --repo "%MRMAK_LOCAL_ROOT%"
  exit /b 0
)
if exist "%MRMAK_LAUNCH_ROOT%src-tauri\target\release\mrmak-workspace.exe" (
  start "" "%MRMAK_LAUNCH_ROOT%src-tauri\target\release\mrmak-workspace.exe" --repo "%MRMAK_LOCAL_ROOT%"
  exit /b 0
)
echo Install Mr. Mak Workspace from this project's GitHub Releases.
echo Or build with: powershell -NoProfile -ExecutionPolicy Bypass -File Setup.ps1 -Mode Desktop
echo See docs\getting-started.md for agent-guided setup.
pause
