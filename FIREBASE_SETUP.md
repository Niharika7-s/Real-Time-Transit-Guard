# Firebase Setup Guide for RTG Vendor App

## ✅ Completed Steps

1. **SHA-1 Fingerprint**: `19:01:6D:CF:B0:48:A6:45:EC:60:F6:4E:B8:7A:77:C9:9D:59:58:86`
2. **Firebase dependencies** added to pubspec.yaml
3. **Firebase initialization** added to main.dart
4. **Cloud Functions** created with recommendations and events endpoints
5. **Recommendations widget** integrated into login page

## 🔧 Next Steps

### 1. Firebase Console Setup
- [ ] Add SHA-1 fingerprint to Firebase Console
- [ ] Download google-services.json and place in `android/app/`
- [ ] Enable Firestore Database
- [ ] Set up Firestore security rules

### 2. Deploy Cloud Functions
```bash
# Option 1: Use the batch file
deploy-functions.bat

# Option 2: Manual commands
cd functions
npm install
cd ..
firebase deploy --only functions
```

### 3. Update Function URLs
After deploying, update `lib/widgets/recommendations_widget.dart`:
- Replace `YOUR_PROJECT` with your actual Firebase project ID
- Get the function URLs from Firebase Console → Functions

### 4. Create Sample Data
In Firestore Console, create these collections:

**products collection:**
```
Document ID: p101
Fields:
- name: "Sugar 5kg" (string)
- category: "Staples" (string) 
- price: 250 (number)
- distributorId: "d1" (string)
- createdAt: (timestamp - now)
```

**orders collection:**
```
Document ID: o1
Fields:
- retailerId: "r123" (string)
- productIds: ["p101", "p205"] (array)
- totalAmount: 800 (number)
- placedAt: (timestamp - now)
```

### 5. Test the App
```bash
flutter run
```

## 🔗 Function URLs
After deployment, your functions will be available at:
- Recommendations: `https://asia-south1-YOUR_PROJECT.cloudfunctions.net/recommendations`
- Events: `https://asia-south1-YOUR_PROJECT.cloudfunctions.net/events`

## 🧪 Testing
You can test the functions directly:
```bash
# Test recommendations (replace YOUR_PROJECT)
curl "https://asia-south1-YOUR_PROJECT.cloudfunctions.net/recommendations?retailerId=r123&testMode=true"

# Test events
curl -X POST "https://asia-south1-YOUR_PROJECT.cloudfunctions.net/events?testMode=true" \
  -H "Content-Type: application/json" \
  -d '{"retailerId":"r123", "type":"product_impression", "productId":"p101", "metadata":{}}'
```

## 📱 App Features
- ✅ Firebase Authentication (anonymous for testing)
- ✅ Real-time recommendations
- ✅ Event logging (impressions, add to cart)
- ✅ Google Maps integration
- ✅ Route drawing
- ✅ WebSocket connectivity