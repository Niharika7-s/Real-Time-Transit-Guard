# 🚀 RTG Vendor App - Simple Start Commands

## ✅ **EASIEST WAY TO START**

### **Method 1: Use the Batch File (Simplest)**
```cmd
start-app.bat
```
Just double-click this file or run it in Command Prompt.

### **Method 2: PowerShell Script**
```powershell
powershell -ExecutionPolicy Bypass -File .\start-manual.ps1
```

### **Method 3: Manual Step-by-Step**

#### **Step 1: Start Backend Server**
```powershell
cd local_backend
node server.js
```
Keep this terminal open - the server will keep running.

#### **Step 2: Open New Terminal and Start Flutter**
```powershell
cd C:\RTG\rtg_vendor_app
flutter run lib/main_local.dart
```

## 🔧 **IF YOU GET ERRORS**

### **PowerShell Execution Policy Error**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Then try the PowerShell script again.

### **Port 3000 Already in Use**
```cmd
netstat -an | findstr :3000
taskkill /f /im node.exe
```
Then start the backend again.

### **Flutter Not Found**
```cmd
flutter doctor
flutter clean
flutter pub get
```

## 🎯 **WHAT HAPPENS WHEN YOU START**

1. **Backend Server** starts on `http://localhost:3000`
2. **Health Check** confirms server is running
3. **Flutter App** launches on your device/emulator
4. **Notifications** are ready to test

## 🧪 **TEST NOTIFICATIONS**

Once the app is running:
1. **Dashboard** → **Menu** (☰) → **"Test Notifications"**
2. **Test all types**:
   - Order Delayed
   - Order Arrived
   - Weather Special
   - Festival Special

## ✅ **SUCCESS!**

Your app will have:
- ✅ Backend server running
- ✅ Flutter app launched
- ✅ Notifications working
- ✅ All features ready

**Choose any method above and start your app!** 🚀

