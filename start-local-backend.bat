@echo off
echo Starting RTG Local Backend Server...
echo.

cd local_backend

echo Installing dependencies...
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

echo Starting local backend server...
echo The server will run at http://localhost:3000
echo Press Ctrl+C to stop the server
echo.

npm start

pause
