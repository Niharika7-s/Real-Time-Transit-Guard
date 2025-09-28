@echo off
echo ========================================
echo RTG Vendor App - Connection Test
echo ========================================
echo.

echo 1. Testing localhost backend connection...
curl -s http://localhost:3000/health
if %errorlevel% equ 0 (
    echo ✅ localhost:3000 - HEALTH CHECK PASSED
) else (
    echo ❌ localhost:3000 - HEALTH CHECK FAILED
)
echo.

echo 2. Testing recommendations API...
curl -s "http://localhost:3000/recommendations?retailerId=test123&limit=3"
if %errorlevel% equ 0 (
    echo ✅ localhost:3000 - RECOMMENDATIONS API WORKING
) else (
    echo ❌ localhost:3000 - RECOMMENDATIONS API FAILED
)
echo.

echo 3. Testing Android emulator URL (expected to fail on desktop)...
curl -s http://10.0.2.2:3000/health
if %errorlevel% equ 0 (
    echo ✅ 10.0.2.2:3000 - ANDROID EMULATOR URL WORKING
) else (
    echo ⚠️ 10.0.2.2:3000 - ANDROID EMULATOR URL FAILED (expected on desktop)
)
echo.

echo 4. Checking if backend server is running...
netstat -an | findstr :3000
if %errorlevel% equ 0 (
    echo ✅ Backend server is running on port 3000
) else (
    echo ❌ Backend server is NOT running on port 3000
)
echo.

echo ========================================
echo Connection test completed!
echo ========================================
pause

