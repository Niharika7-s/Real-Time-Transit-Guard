import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  
  // Weather API key (you can get a free one from OpenWeatherMap)
  static const String _weatherApiKey = 'YOUR_WEATHER_API_KEY_HERE';
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  // Festival dates for 2024-2025
  static final Map<String, DateTime> _festivals = {
    'New Year': DateTime(2025, 1, 1),
    'Valentine\'s Day': DateTime(2025, 2, 14),
    'Holi': DateTime(2025, 3, 14),
    'Eid al-Fitr': DateTime(2025, 3, 30),
    'Ram Navami': DateTime(2025, 4, 6),
    'Good Friday': DateTime(2025, 4, 18),
    'Easter': DateTime(2025, 4, 20),
    'Akshaya Tritiya': DateTime(2025, 5, 1),
    'Eid al-Adha': DateTime(2025, 6, 6),
    'Raksha Bandhan': DateTime(2025, 8, 12),
    'Krishna Janmashtami': DateTime(2025, 8, 26),
    'Ganesh Chaturthi': DateTime(2025, 9, 7),
    'Onam': DateTime(2025, 9, 15),
    'Dussehra': DateTime(2025, 10, 2),
    'Diwali': DateTime(2025, 10, 20),
    'Karva Chauth': DateTime(2025, 10, 31),
    'Dhanteras': DateTime(2025, 11, 1),
    'Christmas': DateTime(2025, 12, 25),
    'Sankranti': DateTime(2026, 1, 14),
  };
  
  // Weather-based notification messages
  static final Map<String, List<String>> _weatherMessages = {
    'rainy': [
      "Why not order some biscuits with your tea for such good rainy weather? ☔",
      "Perfect weather for some hot snacks! Order now and stay cozy! 🌧️",
      "Rainy day calls for comfort food! Check out our warm meals! 🍲",
      "Stay dry and well-fed! Order some delicious food for this rainy day! ☔",
      "Nothing beats rainy weather with some hot, fresh food! Order now! 🌧️",
    ],
    'sunny': [
      "Bright sunny day! Perfect for some fresh, healthy food! ☀️",
      "Sunshine and good food go hand in hand! Order something delicious! 🌞",
      "Beautiful day calls for beautiful food! Check out our fresh options! ☀️",
      "Sunny weather, sunny mood! Order some amazing food! 🌞",
      "Great weather for a great meal! Order now! ☀️",
    ],
    'cloudy': [
      "Cloudy day, clear choice - order some amazing food! ☁️",
      "Perfect weather for comfort food! Order something delicious! ☁️",
      "Cloudy skies, bright flavors! Check out our menu! ☁️",
      "Great day for some great food! Order now! ☁️",
      "Cloudy weather, sunny taste! Order something special! ☁️",
    ],
    'snowy': [
      "Snowy day calls for warm, hearty food! Order now! ❄️",
      "Stay warm with some hot, delicious food! Order today! ❄️",
      "Perfect weather for comfort food! Check out our warm meals! ❄️",
      "Snow outside, warmth inside! Order some amazing food! ❄️",
      "Cold weather, hot food! Order now and stay cozy! ❄️",
    ],
    'default': [
      "Great day for great food! Order something delicious! 😊",
      "Perfect time to treat yourself! Check out our menu! 🍽️",
      "Why not order something special today? Order now! ✨",
      "Good food, good mood! Order something amazing! 😋",
      "Time for some delicious food! Order now! 🍕",
    ],
  };
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Android initialization settings
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _initialized = true;
    debugPrint('✅ Notification service initialized');
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // Handle notification tap - you can navigate to specific pages
  }
  
  // Order delay notification
  static Future<void> showOrderDelayedNotification({
    required String orderId,
    required String delayReason,
  }) async {
    await _showNotification(
      id: 1001,
      title: 'Order Delayed',
      body: 'Your order #$orderId is delayed due to $delayReason. We apologize for the inconvenience.',
      payload: 'order_delayed:$orderId',
    );
  }
  
  // Order arrived notification
  static Future<void> showOrderArrivedNotification({
    required String orderId,
    required String deliveryAddress,
  }) async {
    await _showNotification(
      id: 1002,
      title: 'Order Delivered! 🎉',
      body: 'Your order #$orderId has arrived at $deliveryAddress. Enjoy your meal!',
      payload: 'order_arrived:$orderId',
    );
  }
  
  // Weather-based notification
  static Future<void> showWeatherBasedNotification() async {
    try {
      final weather = await _getCurrentWeather();
      final weatherType = _getWeatherType(weather);
      final messages = _weatherMessages[weatherType] ?? _weatherMessages['default']!;
      
      // Pick a random message
      final randomMessage = messages[DateTime.now().millisecondsSinceEpoch % messages.length];
      
      await _showNotification(
        id: 2000 + DateTime.now().day, // Different ID each day
        title: 'Weather Special! 🌤️',
        body: randomMessage,
        payload: 'weather_special',
      );
    } catch (e) {
      debugPrint('❌ Error showing weather notification: $e');
    }
  }
  
  // Festival notification
  static Future<void> showFestivalNotification() async {
    final today = DateTime.now();
    final todayString = '${today.month}-${today.day}';
    
    debugPrint('🎉 Checking for festivals on $todayString');
    
    for (final entry in _festivals.entries) {
      final festivalDate = entry.value;
      final festivalString = '${festivalDate.month}-${festivalDate.day}';
      
      debugPrint('🎉 Checking festival: ${entry.key} on $festivalString');
      
      if (todayString == festivalString) {
        debugPrint('🎉 Found festival match: ${entry.key}');
        await _showNotification(
          id: 3000 + today.day,
          title: '${entry.key} Special! 🎉',
          body: _getFestivalMessage(entry.key),
          payload: 'festival:${entry.key}',
        );
        break;
      }
    }
    
    // If no festival found, show a test festival notification
    debugPrint('🎉 No festival found for today, showing test festival notification');
    await _showNotification(
      id: 3999,
      title: 'Test Festival Special! 🎉',
      body: 'This is a test festival notification to verify the system is working!',
      payload: 'festival:test',
    );
  }
  
  // Schedule daily weather notifications
  static Future<void> scheduleDailyWeatherNotifications() async {
    // Schedule for 10 AM daily
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 10, 0);
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(const Duration(days: 1));
    }
    
    await _scheduleNotification(
      id: 4000,
      title: 'Daily Weather Special',
      body: 'Check out today\'s weather-based recommendations!',
      scheduledDate: scheduledTime,
      repeatInterval: RepeatInterval.daily,
    );
  }
  
  // Schedule festival notifications (check daily)
  static Future<void> scheduleFestivalNotifications() async {
    // Schedule for 9 AM daily to check for festivals
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 9, 0);
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(const Duration(days: 1));
    }
    
    await _scheduleNotification(
      id: 4001,
      title: 'Festival Check',
      body: 'Checking for special festival offers...',
      scheduledDate: scheduledTime,
      repeatInterval: RepeatInterval.daily,
    );
  }
  
  // Helper method to show notification
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rtg_vendor_channel',
      'RTG Vendor Notifications',
      channelDescription: 'Notifications for RTG Vendor App',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
    debugPrint('🔔 Notification sent: $title');
  }
  
  // Helper method to schedule notification
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rtg_vendor_scheduled',
      'RTG Scheduled Notifications',
      channelDescription: 'Scheduled notifications for RTG Vendor App',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    debugPrint('⏰ Notification scheduled: $title at $scheduledDate');
  }
  
  // Get current weather
  static Future<Map<String, dynamic>> _getCurrentWeather() async {
    try {
      // Using a default location (Delhi) for demo
      const lat = 28.6139;
      const lon = 77.2090;
      
      final response = await http.get(
        Uri.parse('$_weatherBaseUrl?lat=$lat&lon=$lon&appid=$_weatherApiKey&units=metric'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Weather API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Weather API error: $e');
      // Return default weather data
      return {
        'weather': [{'main': 'Clear'}],
        'main': {'temp': 25.0},
      };
    }
  }
  
  // Get weather type from API response
  static String _getWeatherType(Map<String, dynamic> weatherData) {
    try {
      final weather = weatherData['weather'] as List;
      final main = weather[0]['main'] as String;
      
      switch (main.toLowerCase()) {
        case 'rain':
        case 'drizzle':
        case 'thunderstorm':
          return 'rainy';
        case 'clear':
          return 'sunny';
        case 'clouds':
          return 'cloudy';
        case 'snow':
          return 'snowy';
        default:
          return 'default';
      }
    } catch (e) {
      return 'default';
    }
  }
  
  // Get festival-specific message
  static String _getFestivalMessage(String festival) {
    switch (festival) {
      case 'Diwali':
        return '🪔 Diwali Special! Light up your celebrations with our festive food collection! Order now for special discounts!';
      case 'Christmas':
        return '🎄 Christmas Special! Celebrate with our holiday menu! Order now for festive treats!';
      case 'Eid al-Fitr':
        return '🌙 Eid Mubarak! Celebrate with our special Eid collection! Order now for traditional delicacies!';
      case 'Holi':
        return '🎨 Holi Special! Add colors to your celebrations with our vibrant food collection!';
      case 'New Year':
        return '🎊 New Year Special! Start the year with amazing food! Order now for special offers!';
      case 'Valentine\'s Day':
        return '💕 Valentine\'s Special! Celebrate love with our romantic dinner collection!';
      case 'Dussehra':
        return '🦸 Dussehra Special! Celebrate victory with our special food collection!';
      case 'Sankranti':
        return '🌾 Sankranti Special! Celebrate harvest with our traditional food collection!';
      default:
        return '🎉 $festival Special! Celebrate with our special food collection! Order now for exclusive offers!';
    }
  }
  
  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ All notifications cancelled');
  }
  
  // Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('🗑️ Notification $id cancelled');
  }
}
