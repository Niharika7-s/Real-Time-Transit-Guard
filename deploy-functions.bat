@echo off
echo Installing Firebase Functions dependencies...
cd functions
npm install
if %errorlevel% neq 0 (
    echo Error installing dependencies. Please run: npm install -g firebase-tools
    pause
    exit /b 1
)

echo.
echo Deploying Firebase Functions...
cd ..
firebase deploy --only functions
if %errorlevel% neq 0 (
    echo Error deploying functions. Please check your Firebase project setup.
    pause
    exit /b 1
)

echo.
echo Functions deployed successfully!
echo Check the Firebase Console for your function URLs.
pause




