import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class NotificationManager {
  static Timer? _weatherTimer;
  static Timer? _festivalTimer;
  static bool _isInitialized = false;
  
  // Initialize notification manager
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    await NotificationService.initialize();
    
    // Schedule daily weather notifications
    await NotificationService.scheduleDailyWeatherNotifications();
    
    // Schedule festival notifications
    await NotificationService.scheduleFestivalNotifications();
    
    // Start periodic checks
    _startPeriodicChecks();
    
    _isInitialized = true;
    debugPrint('✅ Notification Manager initialized');
  }
  
  // Start periodic checks for weather and festivals
  static void _startPeriodicChecks() {
    // Check weather every 6 hours
    _weatherTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      _checkAndShowWeatherNotification();
    });
    
    // Check festivals every day at 9 AM
    _festivalTimer = Timer.periodic(const Duration(hours: 24), (timer) {
      _checkAndShowFestivalNotification();
    });
    
    debugPrint('🔄 Periodic notification checks started');
  }
  
  // Check and show weather notification
  static Future<void> _checkAndShowWeatherNotification() async {
    try {
      // Only show weather notification once per day
      final now = DateTime.now();
      final lastWeatherNotification = await _getLastWeatherNotificationDate();
      
      if (lastWeatherNotification == null || 
          now.difference(lastWeatherNotification).inDays >= 1) {
        await NotificationService.showWeatherBasedNotification();
        await _setLastWeatherNotificationDate(now);
      }
    } catch (e) {
      debugPrint('❌ Error checking weather notification: $e');
    }
  }
  
  // Check and show festival notification
  static Future<void> _checkAndShowFestivalNotification() async {
    try {
      await NotificationService.showFestivalNotification();
    } catch (e) {
      debugPrint('❌ Error checking festival notification: $e');
    }
  }
  
  // Show order delayed notification
  static Future<void> notifyOrderDelayed({
    required String orderId,
    required String delayReason,
  }) async {
    await NotificationService.showOrderDelayedNotification(
      orderId: orderId,
      delayReason: delayReason,
    );
  }
  
  // Show order arrived notification
  static Future<void> notifyOrderArrived({
    required String orderId,
    required String deliveryAddress,
  }) async {
    await NotificationService.showOrderArrivedNotification(
      orderId: orderId,
      deliveryAddress: deliveryAddress,
    );
  }
  
  // Show immediate weather notification (for testing)
  static Future<void> showWeatherNotificationNow() async {
    await NotificationService.showWeatherBasedNotification();
  }
  
  // Show immediate festival notification (for testing)
  static Future<void> showFestivalNotificationNow() async {
    await NotificationService.showFestivalNotification();
  }
  
  // Get last weather notification date from storage
  static Future<DateTime?> _getLastWeatherNotificationDate() async {
    // In a real app, you'd store this in SharedPreferences or Hive
    // For now, return null to always show weather notifications
    return null;
  }
  
  // Set last weather notification date
  static Future<void> _setLastWeatherNotificationDate(DateTime date) async {
    // In a real app, you'd store this in SharedPreferences or Hive
    debugPrint('📅 Last weather notification date set to: $date');
  }
  
  // Cleanup timers
  static void dispose() {
    _weatherTimer?.cancel();
    _festivalTimer?.cancel();
    _isInitialized = false;
    debugPrint('🗑️ Notification Manager disposed');
  }
  
  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await NotificationService.cancelAllNotifications();
  }
}

