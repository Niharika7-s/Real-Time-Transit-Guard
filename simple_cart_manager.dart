import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

class SimpleCartManager {
  static final List<Map<String, dynamic>> _cartItems = [];
  static final List<VoidCallback> _listeners = [];
  static const String _cartBoxName = 'simpleCartBox';

  // Add a listener for cart changes
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  // Remove a listener
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  static void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Load cart items from Hive
  static Future<void> _loadFromHive() async {
    try {
      debugPrint('🔄 Loading from Hive...');
      if (!Hive.isBoxOpen(_cartBoxName)) {
        debugPrint('🔄 Opening Hive box: $_cartBoxName');
        await Hive.openBox(_cartBoxName);
      }
      final Box box = Hive.box(_cartBoxName);
      debugPrint('🔄 Hive box opened, contains ${box.length} items');
      _cartItems.clear();
      for (final item in box.values) {
        try {
          if (item is Map) {
            // Convert to proper Map<String, dynamic> type
            final Map<String, dynamic> cartItem = <String, dynamic>{};
            for (final entry in item.entries) {
              cartItem[entry.key.toString()] = entry.value;
            }
            _cartItems.add(cartItem);
            debugPrint('🔄 Loaded item: ${cartItem['name']}');
          } else {
            debugPrint('⚠️ Skipping non-map item: ${item.runtimeType}');
          }
        } catch (e) {
          debugPrint('⚠️ Skipping invalid cart item: $e');
        }
      }
      debugPrint('📦 Loaded ${_cartItems.length} items from Hive');
    } catch (e) {
      debugPrint('❌ Error loading from Hive: $e');
    }
  }

  // Save cart items to Hive
  static Future<void> _saveToHive() async {
    try {
      if (!Hive.isBoxOpen(_cartBoxName)) {
        await Hive.openBox(_cartBoxName);
      }
      final Box box = Hive.box(_cartBoxName);
      await box.clear();
      for (final item in _cartItems) {
        await box.add(item);
      }
      debugPrint('💾 Saved ${_cartItems.length} items to Hive');
    } catch (e) {
      debugPrint('❌ Error saving to Hive: $e');
    }
  }

  // Add product to cart
  static Future<void> addProduct(Product product) async {
    try {
      debugPrint('🛒 Adding product to simple cart: ${product.name}');
      debugPrint('🛒 Product details: id=${product.id}, price=${product.price}, unit=${product.unit}');
      
      // Load current items from Hive
      await _loadFromHive();
      debugPrint('🛒 Current cart items before adding: ${_cartItems.length}');
      
      // Check if product already exists
      int existingIndex = -1;
      for (int i = 0; i < _cartItems.length; i++) {
        if (_cartItems[i]['id'] == product.id) {
          existingIndex = i;
          break;
        }
      }
      
      if (existingIndex >= 0) {
        // Update quantity
        final currentQty = double.tryParse(_cartItems[existingIndex]['quantity'].toString()) ?? 1;
        _cartItems[existingIndex]['quantity'] = (currentQty + 1).toString();
        debugPrint('✅ Updated quantity for ${product.name} to ${_cartItems[existingIndex]['quantity']}');
      } else {
        // Add new product
        final cartItem = <String, dynamic>{
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': '1',
          'unit': product.unit,
          'category': product.category,
        };
        _cartItems.add(cartItem);
        debugPrint('✅ Added new product ${product.name} to simple cart');
        debugPrint('✅ Cart item details: $cartItem');
      }
      
      debugPrint('🛒 Cart items after adding: ${_cartItems.length}');
      
      // Save to Hive
      await _saveToHive();
      debugPrint('🛒 Saved to Hive, notifying listeners');
      _notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding to simple cart: $e');
    }
  }

  // Get all cart items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    await _loadFromHive();
    return List.from(_cartItems);
  }

  // Get cart item count
  static Future<int> getCartItemCount() async {
    await _loadFromHive();
    return _cartItems.length;
  }

  // Remove item from cart
  static Future<void> removeItem(int index) async {
    await _loadFromHive();
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      await _saveToHive();
      _notifyListeners();
    }
  }

  // Clear cart
  static Future<void> clearCart() async {
    _cartItems.clear();
    await _saveToHive();
    _notifyListeners();
  }

  // Calculate total
  static double calculateTotal() {
    double total = 0;
    for (var item in _cartItems) {
      final qty = double.tryParse(item['quantity'].toString()) ?? 1;
      total += (item['price'] as num).toDouble() * qty;
    }
    return total;
  }
}
