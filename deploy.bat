@echo off
echo Setting up Firebase Functions...
echo.

echo Installing dependencies...
cd functions
npm install
if %errorlevel% neq 0 (
    echo Error: npm not found or failed to install dependencies
    echo Please ensure Node.js and npm are installed
    echo You can download Node.js from: https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.

echo Deploying Firebase Functions...
cd ..
firebase deploy --only functions
if %errorlevel% neq 0 (
    echo.
    echo Error deploying functions. Please check:
    echo 1. Firebase CLI is installed: npm install -g firebase-tools
    echo 2. You are logged in: firebase login
    echo 3. Your project is selected: firebase use --add
    pause
    exit /b 1
)

echo.
echo ✅ Functions deployed successfully!
echo.
echo Your function URLs:
echo - Recommendations: https://asia-south1-YOUR_PROJECT.cloudfunctions.net/recommendations
echo - Events: https://asia-south1-YOUR_PROJECT.cloudfunctions.net/events
echo.
echo Replace YOUR_PROJECT with your actual Firebase project ID
pause




