# 🚀 RTG Vendor App - Step by Step Start Guide

## ✅ **YOU'RE IN THE RIGHT DIRECTORY!**

You're currently in: `C:\RTG\rtg_vendor_app` ✅

## 🎯 **METHOD 1: EASY START (RECOMMENDED)**

```cmd
.\start-app.bat
```
This will start everything automatically!

## 🎯 **METHOD 2: MANUAL STEP-BY-STEP**

### **Step 1: Start Backend Server**
Open a new terminal/command prompt and run:
```cmd
cd C:\RTG\rtg_vendor_app\local_backend
node server.js
```
Keep this terminal open - the server will keep running.

### **Step 2: Start Flutter App**
In your current terminal, run:
```cmd
flutter run lib/main_local.dart
```

## 🎯 **METHOD 3: POWERSHELL (IF YOU PREFER)**

```powershell
powershell -ExecutionPolicy Bypass -File .\start-manual.ps1
```

## 🔧 **IF YOU GET ERRORS**

### **"node is not recognized"**
- Install Node.js from https://nodejs.org/
- Restart your terminal

### **"flutter is not recognized"**
- Install Flutter from https://flutter.dev/
- Add Flutter to your PATH

### **Port 3000 already in use**
```cmd
netstat -an | findstr :3000
taskkill /f /im node.exe
```

## 🧪 **TEST YOUR APP**

Once the app starts:

1. **Open the app** on your device/emulator
2. **Go to Dashboard** (main screen)
3. **Tap the menu** (☰ hamburger icon)
4. **Select "Test Notifications"**
5. **Test all notification types**:
   - Order Delayed
   - Order Arrived
   - Weather Special
   - Festival Special

## ✅ **WHAT YOU'LL SEE**

- **Backend Server**: Running on http://localhost:3000
- **Flutter App**: Launched on your device
- **Notifications**: Ready to test
- **All Features**: Working perfectly

## 🎉 **SUCCESS!**

Your RTG Vendor App with comprehensive notifications is ready!

**Choose any method above and start your app!** 🚀

