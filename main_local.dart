import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_page.dart';
import 'services/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Hive.initFlutter();
    await Hive.openBox('cartBox');    // stores cart items (each entry = Map)
    await Hive.openBox('ordersBox');  // stores placed orders (each entry = Map)
    await Hive.openBox('simpleCartBox');  // stores simple cart items
    debugPrint('✅ Hive local storage initialized successfully');
    
    // Initialize notification system
    await NotificationManager.initialize();
    debugPrint('✅ Notification system initialized');
    
    // App initialized successfully
    debugPrint('🚀 RTG Vendor App initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing app: $e');
    // Continue anyway - the app can still work without persistence
  }
  
  runApp(const RTGApp());
}

class RTGApp extends StatelessWidget {
  const RTGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTG Vendor Portal (Local)',
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
