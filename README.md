# Qwipo Firebase Functions Setup

This directory contains the Firebase Cloud Functions for the RTG Vendor App as specified in the guide.

## 📁 Structure
```
qwipo-fns/
├── firebase.json          # Firebase configuration
├── functions/
│   ├── package.json       # Node.js dependencies
│   └── index.js          # Cloud Functions code
├── deploy.bat            # Windows deployment script
└── README.md             # This file
```

## 🚀 Quick Setup

### 1. Install Dependencies
```bash
cd functions
npm install
```

### 2. Deploy Functions
```bash
# Option 1: Use the batch file (Windows)
deploy.bat

# Option 2: Manual deployment
firebase deploy --only functions
```

## 🔧 Prerequisites

1. **Node.js**: Download from [nodejs.org](https://nodejs.org/)
2. **Firebase CLI**: `npm install -g firebase-tools`
3. **Firebase Login**: `firebase login`
4. **Project Selection**: `firebase use --add` (select your project)

## 📋 Functions Created

### 1. Recommendations Function
- **Endpoint**: `/recommendations`
- **Method**: GET
- **Parameters**: `retailerId`, `limit` (optional)
- **Features**: AI-powered product recommendations based on purchase history

### 2. Events Function
- **Endpoint**: `/events`
- **Method**: POST
- **Body**: `{ retailerId, type, productId, metadata }`
- **Features**: Logs user interactions (views, cart additions, purchases)

## 🧪 Testing

### Test Recommendations
```bash
curl "https://asia-south1-YOUR_PROJECT.cloudfunctions.net/recommendations?retailerId=r123&testMode=true"
```

### Test Events
```bash
curl -X POST "https://asia-south1-YOUR_PROJECT.cloudfunctions.net/events?testMode=true" \
  -H "Content-Type: application/json" \
  -d '{"retailerId":"r123", "type":"product_impression", "productId":"p101", "metadata":{}}'
```

## 🔗 Integration

After deployment, update your Flutter app:
1. Get your function URLs from Firebase Console
2. Update `lib/widgets/recommendations_widget.dart`
3. Replace `YOUR_PROJECT` with your actual Firebase project ID

## 📊 Firestore Schema

### Collections Required:
- **products**: Product catalog
- **orders**: Order history
- **events**: User interaction logs
- **retailers**: Retailer information (optional)

### Sample Data:
See the main `FIREBASE_SETUP.md` for sample data creation.




