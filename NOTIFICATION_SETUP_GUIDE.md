# 🔔 RTG Vendor App - Notification System Setup Guide

## ✅ **NOTIFICATION FEATURES IMPLEMENTED**

### **1. 📦 Order Notifications**
- **Order Delayed**: Notifies when order is delayed with reason
- **Order Arrived**: Notifies when order has been delivered
- **Automatic Triggering**: Integrated into checkout process

### **2. 🌤️ Weather-Based Notifications**
- **Playful Messages**: Weather-specific food suggestions
- **Daily Scheduling**: Appears at 10 AM daily
- **Weather Types**: Rainy, Sunny, Cloudy, Snowy, Default
- **Sample Messages**:
  - Rainy: "Why not order some biscuits with your tea for such good rainy weather? ☔"
  - Sunny: "Bright sunny day! Perfect for some fresh, healthy food! ☀️"
  - Cloudy: "Cloudy day, clear choice - order some amazing food! ☁️"

### **3. 🎉 Festival Notifications**
- **Major Festivals**: Diwali, Christmas, Eid, Holi, New Year, Valentine's Day, etc.
- **Special Messages**: Festival-specific food recommendations
- **Daily Check**: Scans for festivals every day at 9 AM
- **Sample Messages**:
  - Diwali: "🪔 Diwali Special! Light up your celebrations with our festive food collection!"
  - Christmas: "🎄 Christmas Special! Celebrate with our holiday menu!"

## 🚀 **HOW TO USE**

### **Testing Notifications**
1. **Open the app** and go to **Dashboard**
2. **Tap the menu** (hamburger icon)
3. **Select "Test Notifications"**
4. **Test different notification types**:
   - Order Delayed
   - Order Arrived
   - Weather Special
   - Festival Special

### **Real Notifications**
- **Order Notifications**: Automatically triggered when you place an order
- **Weather Notifications**: Appear daily at 10 AM (if weather API is configured)
- **Festival Notifications**: Appear on special days at 9 AM

## ⚙️ **CONFIGURATION**

### **Weather API Setup (Optional)**
To get real weather data instead of default messages:

1. **Get Free API Key**:
   - Visit [OpenWeatherMap](https://openweathermap.org/api)
   - Sign up for free account
   - Get your API key

2. **Update API Key**:
   - Open `lib/services/notification_service.dart`
   - Find line: `static const String _weatherApiKey = 'YOUR_WEATHER_API_KEY_HERE';`
   - Replace with your actual API key

### **Android Permissions**
For Android, add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.INTERNET" />
```

### **iOS Permissions**
For iOS, add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## 📱 **NOTIFICATION TYPES**

### **Order Notifications**
- **ID Range**: 1001-1002
- **Channel**: "RTG Vendor Notifications"
- **Priority**: High
- **Auto-triggered**: Yes (on order placement)

### **Weather Notifications**
- **ID Range**: 2000-2999
- **Channel**: "RTG Vendor Notifications"
- **Priority**: High
- **Scheduled**: Daily at 10 AM

### **Festival Notifications**
- **ID Range**: 3000-3999
- **Channel**: "RTG Vendor Notifications"
- **Priority**: High
- **Scheduled**: Daily at 9 AM

### **Scheduled Notifications**
- **ID Range**: 4000-4999
- **Channel**: "RTG Scheduled Notifications"
- **Priority**: High
- **Repeat**: Daily

## 🎯 **CUSTOMIZATION**

### **Adding New Weather Messages**
Edit `lib/services/notification_service.dart`:
```dart
static final Map<String, List<String>> _weatherMessages = {
  'rainy': [
    "Your custom rainy message here! ☔",
    // Add more messages...
  ],
  // Add more weather types...
};
```

### **Adding New Festivals**
Edit the `_festivals` map in `notification_service.dart`:
```dart
static final Map<String, DateTime> _festivals = {
  'Your Festival': DateTime(2025, month, day),
  // Add more festivals...
};
```

### **Customizing Order Messages**
Edit the notification methods in `notification_service.dart`:
```dart
static Future<void> showOrderDelayedNotification({
  required String orderId,
  required String delayReason,
}) async {
  // Customize the message here
}
```

## 🔧 **TROUBLESHOOTING**

### **Notifications Not Appearing**
1. **Check Permissions**: Ensure notification permissions are granted
2. **Check App State**: Notifications work in background
3. **Check Logs**: Look for error messages in debug console

### **Weather Notifications Not Working**
1. **Check API Key**: Ensure weather API key is configured
2. **Check Internet**: Weather data requires internet connection
3. **Check Fallback**: App uses default messages if API fails

### **Festival Notifications Not Working**
1. **Check Date**: Festival dates are hardcoded for 2025
2. **Check Time**: Notifications appear at scheduled times
3. **Check Logs**: Look for festival detection logs

## 📊 **MONITORING**

### **Debug Logs**
Look for these log messages:
- `✅ Notification service initialized`
- `🔔 Notification sent: [title]`
- `⏰ Notification scheduled: [title] at [time]`
- `❌ Error showing weather notification: [error]`

### **Test All Features**
1. **Place an order** → Check for order notifications
2. **Use Test Center** → Test all notification types
3. **Check scheduled** → Wait for daily notifications
4. **Check festivals** → Test on special days

## 🎉 **SUCCESS!**

Your RTG Vendor App now has a comprehensive notification system that:
- ✅ Notifies about order delays and arrivals
- ✅ Sends weather-based playful food suggestions
- ✅ Celebrates festivals with special offers
- ✅ Works in background and foreground
- ✅ Provides easy testing interface

**Enjoy your enhanced app experience!** 🚀

