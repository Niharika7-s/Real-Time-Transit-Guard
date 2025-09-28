# RTG Vendor App - Local Setup Guide

This guide helps you run the RTG Vendor App without Firebase, using a local backend server instead.

## 🚀 Quick Start

### 1. Start Local Backend Server
```bash
# Option 1: Use the batch file (Windows)
start-local-backend.bat

# Option 2: Manual setup
cd local_backend
npm install
npm start
```

The backend will run at `http://localhost:3000`

### 2. Run Flutter App
```bash
# Option 1: Use local main (recommended)
flutter run lib/main_local.dart

# Option 2: Use original main (with Firebase fallback)
flutter run
```

## 📋 Prerequisites

1. **Node.js**: Download from [nodejs.org](https://nodejs.org/)
2. **Flutter**: Make sure Flutter is installed and configured
3. **Android Studio/VS Code**: For running the app

## 🔧 Local Backend Features

The local backend provides:

- **Recommendations API**: `/recommendations?retailerId=xxx&limit=10`
- **Events API**: `POST /events` for logging user interactions
- **Analytics**: `/analytics` for viewing event data
- **Health Check**: `/health` for server status

## 📱 App Features

- ✅ **Product Catalog**: 20+ sample products
- ✅ **Shopping Cart**: Add/remove items, quantity management
- ✅ **Order Management**: Place and track orders
- ✅ **Recommendations**: AI-powered product suggestions
- ✅ **Local Storage**: All data stored locally with Hive
- ✅ **Real-time Tracking**: Socket.io tracking server
- ✅ **Payment Flow**: Complete checkout process

## 🛠️ Troubleshooting

### Backend Issues
- Make sure port 3000 is not in use
- Check if Node.js is installed: `node --version`
- Check if npm is installed: `npm --version`

### Flutter Issues
- Run `flutter doctor` to check Flutter setup
- Run `flutter pub get` to install dependencies
- Make sure you're using the correct main file

### Recommendations Not Loading
- Ensure backend server is running
- Check network connectivity
- App will fallback to offline recommendations if backend is unavailable

## 🔄 Switching Between Firebase and Local

### Use Local Backend (Current Setup)
```bash
flutter run lib/main_local.dart
```

### Use Firebase (Original)
```bash
flutter run lib/main.dart
```

## 📊 Testing the Setup

1. **Test Backend**: Visit `http://localhost:3000/health`
2. **Test Recommendations**: Visit `http://localhost:3000/recommendations?retailerId=test123`
3. **Test App**: Run the Flutter app and try adding items to cart

## 🎯 Next Steps

1. Start the local backend server
2. Run the Flutter app with local main
3. Test all features (cart, orders, recommendations)
4. Customize the product catalog as needed
5. Modify the recommendation logic in `local_backend/server.js`

## 📞 Support

If you encounter any issues:
1. Check the console logs for error messages
2. Ensure all prerequisites are installed
3. Verify the backend server is running
4. Check the Flutter app logs for any errors

The app is designed to work offline with fallback recommendations, so it should work even if the backend is temporarily unavailable.
