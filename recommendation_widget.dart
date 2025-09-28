import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/recommendation_rules.dart';
import '../models/product.dart';
import '../utils/simple_cart_manager.dart';

class RecommendationWidget extends StatefulWidget {
  final String? currentProduct;
  final List<String>? cartProducts;

  const RecommendationWidget({
    super.key,
    this.currentProduct,
    this.cartProducts,
  });

  @override
  State<RecommendationWidget> createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  late Box cartBox;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box('cartBox');
  }

  void _addToCart(Map<String, String> product) async {
    try {
      debugPrint('🛒 Adding ${product['name']} to cart');
      
      // Use SimpleCartManager for consistent cart management
      final productObj = Product(
        id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
        name: product['name']!,
        price: _parsePrice(product['price']!),
        unit: 'unit',
        category: 'Recommended',
        description: 'Recommended product',
      );
      
      await SimpleCartManager.addProduct(productObj);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product['name']} added to cart!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      debugPrint('✅ Successfully added ${product['name']} to cart');
    } catch (e) {
      debugPrint('❌ Error adding to cart: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item to cart'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _parsePrice(String priceString) {
    // Remove ₹ and convert to double
    String cleanPrice = priceString.replaceAll('₹', '').replaceAll(',', '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  List<Map<String, String>> _getRecommendations() {
    // Always show some recommendations for testing
    List<Map<String, String>> recommendations = [];
    
    if (widget.currentProduct != null) {
      // Get recommendations for specific product
      debugPrint('🎯 Getting recommendations for specific product: ${widget.currentProduct}');
      recommendations = RecommendationRules.getRecommendations(widget.currentProduct!);
    } else if (widget.cartProducts != null && widget.cartProducts!.isNotEmpty) {
      // Get recommendations based on cart contents
      debugPrint('🛒 Getting recommendations based on provided cart products: ${widget.cartProducts}');
      recommendations = RecommendationRules.getCartRecommendations(widget.cartProducts!);
    } else {
      // Get cart products from Hive and recommend based on that
      final cartItems = cartBox.values.toList();
      List<String> cartProductNames = cartItems.map((item) => item['name'].toString()).toList();
      debugPrint('📦 Cart has ${cartItems.length} items: $cartProductNames');
      recommendations = RecommendationRules.getCartRecommendations(cartProductNames);
      debugPrint('💡 Generated ${recommendations.length} recommendations from cart');
    }
    
    // Fallback recommendations if none found
    if (recommendations.isEmpty) {
      debugPrint('🔄 No recommendations found, using fallback recommendations');
      recommendations = [
        {"name": "Basmati Rice – 5kg", "price": "₹520"},
        {"name": "Cooking Oil – 5L", "price": "₹750"},
        {"name": "Salt – 1kg", "price": "₹18"},
        {"name": "Sugar – 5kg", "price": "₹230"},
        {"name": "Milk – 1L", "price": "₹52"},
      ];
    }
    
    debugPrint('💡 Final recommendations count: ${recommendations.length}');
    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cartBox.listenable(),
      builder: (context, Box box, _) {
        final recommendations = _getRecommendations();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recommended for you",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final product = recommendations[index];
                return Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _addToCart(product),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Icon
                            Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(height: 8),
                            
                            // Product Name
                            Text(
                              product['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            
                            // Product Price
                            Text(
                              product['price']!,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            
                            // Add to Cart Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _addToCart(product),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade600,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  'Add',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
