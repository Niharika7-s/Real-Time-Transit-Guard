@echo off
echo ========================================
echo Starting RTG Vendor App with Notifications
echo ========================================
echo.

echo 1. Starting backend server...
start "Backend Server" cmd /k "cd /d %~dp0local_backend && node server.js"

echo 2. Waiting for backend to start...
timeout /t 3 /nobreak >nul

echo 3. Testing backend connection...
curl -s http://localhost:3000/health >nul
if %errorlevel% equ 0 (
    echo ✅ Backend server is running
) else (
    echo ❌ Backend server failed to start
    pause
    exit /b 1
)

echo 4. Starting Flutter app...
echo.
echo ========================================
echo App is starting... Check your device/emulator
echo ========================================
echo.

flutter run lib/main_local.dart

pause

