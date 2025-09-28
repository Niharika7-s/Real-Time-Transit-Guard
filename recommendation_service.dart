import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class RecommendationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Cache for recommendations to avoid repeated calls
  final Map<String, List<Product>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  Future<List<Product>> getRecommendations(String retailerId) async {
    try {
      // Check cache first
      if (_isCacheValid(retailerId)) {
        debugPrint('📦 Returning cached recommendations for $retailerId');
        return _cache[retailerId]!;
      }

      debugPrint('🔍 Fetching fresh recommendations for $retailerId');
      
      // Test Firestore connection first
      try {
        await _db.collection('test').limit(1).get();
      } catch (e) {
        debugPrint('⚠️ Firestore connection failed: $e');
        debugPrint('🔄 Falling back to offline recommendations');
        return _getFallbackRecommendations();
      }
      
      // 1. Get recent orders
      final orderSnap = await _db
          .collection('orders')
          .where('retailerId', isEqualTo: retailerId)
          .orderBy('placedAt', descending: true)
          .limit(10) // Increased limit for better recommendations
          .get();

      if (orderSnap.docs.isEmpty) {
        debugPrint('📭 No orders found for retailer $retailerId');
        return _getFallbackRecommendations();
      }

      final purchasedProductIds = <String>{};
      for (var doc in orderSnap.docs) {
        final data = doc.data();
        final items = data['productIds'] as List<dynamic>? ?? 
                     data['items'] as List<dynamic>? ?? [];
        purchasedProductIds.addAll(items.map((e) => e.toString()));
      }

      debugPrint('🛒 Found ${purchasedProductIds.length} purchased products');

      // 2. Count categories from purchased products
      final catCount = <String, int>{};
      
      // Handle Firestore's 10-item limit for whereIn
      final productIdList = purchasedProductIds.toList();
      final batches = _createBatches(productIdList, 10);
      
      for (final batch in batches) {
        final prodSnap = await _db
            .collection('products')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (var doc in prodSnap.docs) {
          final cat = doc.data()['category'] as String? ?? '';
          if (cat.isNotEmpty) {
            catCount[cat] = (catCount[cat] ?? 0) + 1;
          }
        }
      }

      // 3. Pick preferred category
      String? preferredCat;
      int max = 0;
      catCount.forEach((k, v) {
        if (v > max) {
          max = v;
          preferredCat = k;
        }
      });

      if (preferredCat == null) {
        debugPrint('❌ No preferred category found');
        return _getFallbackRecommendations();
      }

      debugPrint('🎯 Preferred category: $preferredCat (count: $max)');

      // 4. Fetch products in preferred category, exclude already purchased
      Query query = _db
          .collection('products')
          .where('category', isEqualTo: preferredCat)
          .where('isAvailable', isEqualTo: true)
          .limit(15);

      // Apply whereNotIn only if we have products to exclude
      if (purchasedProductIds.isNotEmpty) {
        final excludeBatches = _createBatches(purchasedProductIds.toList(), 10);
        if (excludeBatches.isNotEmpty) {
          query = query.where(FieldPath.documentId, whereNotIn: excludeBatches.first);
        }
      }

      final recSnap = await query.get();

      final recommendations = recSnap.docs
          .map((doc) => Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .where((product) => product.isAvailable)
          .take(10)
          .toList();

      // Cache the results
      _cache[retailerId] = recommendations;
      _cacheTimestamps[retailerId] = DateTime.now();

      debugPrint('✅ Generated ${recommendations.length} recommendations');
      return recommendations;

    } catch (e) {
      debugPrint('❌ Error in getRecommendations: $e');
      return _getFallbackRecommendations();
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
    ];
  }

  bool _isCacheValid(String retailerId) {
    if (!_cache.containsKey(retailerId)) return false;
    
    final timestamp = _cacheTimestamps[retailerId];
    if (timestamp == null) return false;
    
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  List<List<T>> _createBatches<T>(List<T> items, int batchSize) {
    final batches = <List<T>>[];
    for (int i = 0; i < items.length; i += batchSize) {
      final end = (i + batchSize < items.length) ? i + batchSize : items.length;
      batches.add(items.sublist(i, end));
    }
    return batches;
  }

  // Clear cache when needed
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    debugPrint('🗑️ Recommendation cache cleared');
  }
}
