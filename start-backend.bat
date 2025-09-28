@echo off
echo Starting RTG Local Backend Server...
cd /d "%~dp0local_backend"
echo Current directory: %CD%
echo Installing dependencies...
call npm install
echo Starting server...
node server.js
pause

