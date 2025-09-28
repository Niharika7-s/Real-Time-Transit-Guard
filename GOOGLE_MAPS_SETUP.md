# Google Maps Setup Instructions

## Why is the map blank?
The Google Maps is showing blank because you need to configure a valid Google Maps API key.

## How to Fix:

### Step 1: Get a Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS (if building for iOS)
4. Go to "Credentials" → "Create Credentials" → "API Key"
5. Copy your API key

### Step 2: Add the API Key to Your App
1. Open `android/app/src/main/AndroidManifest.xml`
2. Find this line:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />
   ```
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE" />
   ```

### Step 3: Restart Your App
1. Stop the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Run `flutter run` again

## Important Notes:
- **Never commit your API key to public repositories**
- Consider using environment variables for production apps
- The API key should be restricted to your app's package name for security

## Test API Key:
You can test if your API key works by running the app and checking if the map loads properly. If you see the warning message at the top of the map, the API key is not configured correctly.

## Quick Fix for "Looking for Connection" Issue:
If you see "Looking for connection..." message in the tracking screen:

1. **For immediate testing:** The app now has **fallback tracker simulation** - if WebSocket is not connected, the app will run a demo driver movement automatically.

2. **For real-time tracking:** Start your own tracking server:
   ```bash
   cd tracking_server
   npm install
   npm start
   ```
   
3. **Connection Status:**
   - ✅ **Green "Live tracking active"** = Connected to WebSocket server
   - 📍 **Blue "Offline mode (Demo)"** = Using fallback simulation
   - ⏳ **"Looking for connection"** = Will fallback after 2-3 seconds

## Alternative for Testing:
The app will automatically fall back to demo simulation if WebSocket is not available. No code changes needed.

