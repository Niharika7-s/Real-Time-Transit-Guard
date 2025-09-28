import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class LocalRecommendationService {
  // Local backend URL - try both localhost and 10.0.2.2 for different environments
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator URL first
  static const String emulatorBaseUrl = 'http://localhost:3000'; // Desktop URL second
  
  // Cache for recommendations
  final Map<String, List<Product>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 30); // Longer cache to reduce backend calls
  
  // Track if we've already tried backend connection
  static bool _hasTriedBackend = false;
  static bool _backendAvailable = false;
  
  // FIX: New static field to store the URL that passed the health check
  // This resolves the 'workingUrl' scope issue in getRecommendations.
  static String? _actualWorkingUrl; 

  Future<List<Product>> getRecommendations(String retailerId) async {
    try {
      // Check cache first
      if (_isCacheValid(retailerId)) {
        debugPrint('📦 Returning cached recommendations for $retailerId');
        return _cache[retailerId]!;
      }

      debugPrint('🔍 Fetching fresh recommendations for $retailerId');
      
      // Only try backend connection once per session
      if (!_hasTriedBackend) {
        _hasTriedBackend = true;
        
        // Use a temporary local variable for the check
        String? tempWorkingUrl; 

        try {
          // Try Android emulator URL first (10.0.2.2:3000)
          debugPrint('🔄 Trying Android emulator connection to $baseUrl...');
          final healthResponse = await http.get(
            Uri.parse('$baseUrl/health'),
            headers: {'Content-Type': 'application/json'},
          ).timeout(const Duration(seconds: 3));
          
          if (healthResponse.statusCode == 200) {
            tempWorkingUrl = baseUrl;
            _backendAvailable = true;
            debugPrint('✅ Connected to Android emulator backend');
          }
        } catch (e) {
          debugPrint('⚠️ Android emulator connection failed: $e');
          
          // Try localhost as fallback
          try {
            debugPrint('🔄 Trying localhost connection to $emulatorBaseUrl...');
            final localhostResponse = await http.get(
              Uri.parse('$emulatorBaseUrl/health'),
              headers: {'Content-Type': 'application/json'},
            ).timeout(const Duration(seconds: 3));
            
            if (localhostResponse.statusCode == 200) {
              tempWorkingUrl = emulatorBaseUrl;
              _backendAvailable = true;
              debugPrint('✅ Connected to localhost backend');
            }
          } catch (e2) {
            debugPrint('⚠️ localhost connection failed: $e2');
          }
        }
        
        // Store the result of the check in the static field
        _actualWorkingUrl = tempWorkingUrl; 

        if (_actualWorkingUrl == null) {
          debugPrint('🔄 Backend not available, will use offline recommendations');
        }
      }
      
      // If backend is not available, use offline recommendations
      if (!_backendAvailable || _actualWorkingUrl == null) {
        debugPrint('🔄 Using offline recommendations (backend not available)');
        final fallbackRecs = _getFallbackRecommendations();
        // Cache the fallback recommendations
        _cache[retailerId] = fallbackRecs;
        _cacheTimestamps[retailerId] = DateTime.now();
        return fallbackRecs;
      }
      
      // Fetch recommendations from local backend
      // FIX: Using the class-level static field _actualWorkingUrl
      final response = await http.get(
        Uri.parse('$_actualWorkingUrl/recommendations?retailerId=$retailerId&limit=10'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch recommendations: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final recommendationsData = data['recommendations'] as List<dynamic>;
      
      final recommendations = recommendationsData
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList();

      // Cache the results
      _cache[retailerId] = recommendations;
      _cacheTimestamps[retailerId] = DateTime.now();

      debugPrint('✅ Generated ${recommendations.length} recommendations from local backend');
      return recommendations;

    } catch (e) {
      debugPrint('❌ Error in getRecommendations: $e');
      return _getFallbackRecommendations();
    }
  }

  Future<void> logEvent({
    required String retailerId,
    required String type,
    String? productId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // OPTIMIZATION: Reuse the determined working URL
      final String? workingUrl = _actualWorkingUrl;

      // If the URL hasn't been determined or is null, skip logging.
      // This avoids running two separate health checks.
      if (workingUrl == null) {
        debugPrint('⚠️ Cannot log event. Backend URL not available.');
        return;
      }
      
      final response = await http.post(
        Uri.parse('$workingUrl/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'retailerId': retailerId,
          'type': type,
          'productId': productId,
          'metadata': metadata ?? {},
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        debugPrint('✅ Event logged successfully: $type');
      } else {
        debugPrint('⚠️ Failed to log event: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error logging event: $e');
      // Don't throw - this is a background operation
    }
  }

  List<Product> _getFallbackRecommendations() {
    // Return some default recommendations when no data is available
    return [
      Product(
        id: 'fallback_1',
        name: 'Premium Rice',
        category: 'Grains',
        price: 120.0,
        description: 'High quality premium rice',
        unit: 'kg',
      ),
      Product(
        id: 'fallback_2',
        name: 'Fresh Vegetables',
        category: 'Vegetables',
        price: 80.0,
        description: 'Fresh seasonal vegetables',
        unit: 'kg',
      ),
      Product(
        id: 'fallback_3',
        name: 'Cooking Oil',
        category: 'Cooking Essentials',
        price: 150.0,
        description: 'Pure cooking oil',
        unit: 'liter',
      ),
      Product(
        id: 'fallback_4',
        name: 'Wheat Flour',
        category: 'Grains',
        price: 40.0,
        description: 'Fresh wheat flour',
        unit: 'kg',
      ),
      Product(
        id: 'fallback_5',
        name: 'Sugar',
        category: 'Sweeteners',
        price: 50.0,
        description: 'White granulated sugar',
        unit: 'kg',
      ),
    ];
  }

  bool _isCacheValid(String retailerId) {
    if (!_cache.containsKey(retailerId)) return false;
    
    final timestamp = _cacheTimestamps[retailerId];
    if (timestamp == null) return false;
    
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  // Clear cache when needed
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    debugPrint('🗑️ Recommendation cache cleared');
  }
}
