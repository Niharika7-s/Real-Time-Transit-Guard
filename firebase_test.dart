import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/recommendation_service.dart';

class FirebaseTest {
  static Future<Map<String, dynamic>> runConnectionTests() async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Firebase Auth
      final auth = FirebaseAuth.instance;
      results['auth_connected'] = auth.currentUser != null;
      results['auth_user_id'] = auth.currentUser?.uid;
      
      // Test 2: Firestore Connection
      final startTime = DateTime.now();
      try {
        await FirebaseFirestore.instance
            .collection('test')
            .limit(1)
            .get();
        final endTime = DateTime.now();
        results['firestore_connected'] = true;
        results['firestore_latency_ms'] = endTime.difference(startTime).inMilliseconds;
      } catch (e) {
        results['firestore_connected'] = false;
        results['firestore_error'] = e.toString();
      }
      
      // Test 3: Firestore Collections (simplified test)
      try {
        // Try to access a common collection to test permissions
        await FirebaseFirestore.instance
            .collection('products')
            .limit(1)
            .get();
        results['collections_accessible'] = true;
      } catch (e) {
        results['collections_accessible'] = false;
        results['collections_error'] = e.toString();
      }
      
      // Test 4: Network connectivity
      results['network_test'] = await _testNetworkConnectivity();
      
      results['overall_status'] = results['firestore_connected'] == true ? 'healthy' : 'issues';
      
    } catch (e) {
      results['overall_status'] = 'error';
      results['error'] = e.toString();
    }
    
    if (kDebugMode) {
      debugPrint('🔍 Firebase Connection Test Results:');
      results.forEach((key, value) {
        debugPrint('   $key: $value');
      });
    }
    
    return results;
  }
  
  static Future<bool> _testNetworkConnectivity() async {
    try {
      // Simple network test by trying to access Firestore
      await FirebaseFirestore.instance
          .collection('test')
          .limit(1)
          .get()
          .timeout(Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> testRecommendationService() async {
    try {
      debugPrint('🧪 Testing Recommendation Service...');
      
      // Test with a sample retailer ID
      final service = RecommendationService();
      final recommendations = await service.getRecommendations('test_retailer');
      
      debugPrint('✅ Recommendation Service Test Results:');
      debugPrint('   - Recommendations found: ${recommendations.length}');
      debugPrint('   - Sample recommendation: ${recommendations.isNotEmpty ? recommendations.first.name : 'None'}');
      
    } catch (e) {
      debugPrint('❌ Recommendation Service Test Failed: $e');
    }
  }
}
