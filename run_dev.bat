@echo off
echo ===========================================
echo       PSYCHOLOGY APP DEV LAUNCHER
echo ===========================================
echo.

echo [1/2] Starting Backend Server...
start "Backend Server" cmd /k "cd backend && nodemon src/index.js"

echo [2/2] Starting Flutter App (Windows)...
cd flutter_app
flutter run -d windows

echo.
echo ===========================================
echo       Session Finished.
echo ===========================================
pause
