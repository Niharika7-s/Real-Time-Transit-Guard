import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_page.dart';
import 'firebase_options.dart';
import 'utils/firebase_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
    
    // Initialize Firebase Auth with anonymous sign-in for testing
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final userCredential = await auth.signInAnonymously();
      debugPrint('✅ Anonymous user signed in: ${userCredential.user?.uid}');
    } else {
      debugPrint('✅ User already signed in: ${auth.currentUser?.uid}');
    }
    
    // Run comprehensive Firebase connection tests
    try {
      final testResults = await FirebaseTest.runConnectionTests();
      if (testResults['overall_status'] == 'healthy') {
        debugPrint('✅ All Firebase services are healthy');
      } else {
        debugPrint('⚠️ Firebase services have issues - check logs above');
      }
    } catch (e) {
      debugPrint('⚠️ Firebase connection test failed: $e');
    }
  } catch (e) {
    debugPrint('❌ Error initializing Firebase: $e');
    debugPrint('🔄 App will continue without Firebase features');
    // Continue anyway - the app can still work without Firebase
  }
  
  try {
    await Hive.initFlutter();
    await Hive.openBox('cartBox');    // stores cart items (each entry = Map)
    await Hive.openBox('ordersBox');  // stores placed orders (each entry = Map)
    debugPrint('✅ Hive local storage initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Hive: $e');
    // Continue anyway - the app can still work without persistence
  }
  
  runApp(const RTGApp());
}

class RTGApp extends StatelessWidget {
  const RTGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTG Vendor Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal.shade600,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
