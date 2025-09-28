Write-Host "========================================" -ForegroundColor Green
Write-Host "Starting RTG Vendor App Manually" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Starting backend server..." -ForegroundColor Blue
Start-Process powershell -ArgumentList "-Command", "cd 'C:\RTG\rtg_vendor_app\local_backend'; node server.js" -WindowStyle Normal

Write-Host "2. Waiting for backend to start..." -ForegroundColor Blue
Start-Sleep -Seconds 3

Write-Host "3. Testing backend connection..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend server is running" -ForegroundColor Green
    } else {
        Write-Host "❌ Backend server failed to start" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} catch {
    Write-Host "❌ Backend server failed to start" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "4. Starting Flutter app..." -ForegroundColor Blue
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "App is starting... Check your device/emulator" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

flutter run lib/main_local.dart

