Write-Host "Starting RTG Local Backend Server..." -ForegroundColor Green
Set-Location -Path "$PSScriptRoot\local_backend"
Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
Write-Host "Installing dependencies..." -ForegroundColor Blue
npm install
Write-Host "Starting server..." -ForegroundColor Blue
node server.js

