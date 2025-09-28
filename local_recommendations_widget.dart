import 'package:flutter/material.dart';
import '../services/local_recommendation_service.dart';
import '../models/product.dart';
import '../utils/simple_cart_manager.dart';

class LocalRecommendationsWidget extends StatefulWidget {
  final String retailerId;
  const LocalRecommendationsWidget({super.key, required this.retailerId});

  @override
  State<LocalRecommendationsWidget> createState() => _LocalRecommendationsWidgetState();
}

class _LocalRecommendationsWidgetState extends State<LocalRecommendationsWidget> {
  late Future<List<Product>> _futureRecs;
  final LocalRecommendationService _service = LocalRecommendationService();

  @override
  void initState() {
    super.initState();
    _futureRecs = _loadRecs();
  }

  Future<List<Product>> _loadRecs() async {
    try {
      final recommendations = await _service.getRecommendations(widget.retailerId);
      
      // Log impressions for analytics
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logImpressions(recommendations);
      });
      
      return recommendations;
    } catch (e) {
      debugPrint('Error loading recommendations: $e');
      rethrow;
    }
  }

  Future<void> _logImpressions(List<Product> recs) async {
    try {
      // Log each recommendation as an impression
      for (final rec in recs) {
        await _service.logEvent(
          retailerId: widget.retailerId,
          type: 'product_impression',
          productId: rec.id,
          metadata: {'reason': 'recommended'},
        );
      }
    } catch (e) {
      debugPrint('Error logging impressions: $e');
      // Don't throw - this is a background operation
    }
  }

  Future<void> _quickAdd(Product product) async {
    try {
      debugPrint('🔥 ADD BUTTON PRESSED for ${product.name}');
      debugPrint('🔥 Product details: id=${product.id}, name=${product.name}, price=${product.price}');
      
      // Use simple cart manager directly - it's more reliable
      await SimpleCartManager.addProduct(product);
      debugPrint('🔥 SimpleCartManager.addProduct completed for ${product.name}');
      
      // Show success message immediately
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
        );
        debugPrint('🔥 Success message shown for ${product.name}');
      }
      
      // Try to log event (don't wait for it to complete)
      _service.logEvent(
        retailerId: widget.retailerId,
        type: 'add_to_cart',
        productId: product.id,
        metadata: {'source': 'recommendation'},
      ).catchError((e) => debugPrint('Failed to log event: $e'));
      
    } catch (e) {
      debugPrint('❌ Error adding to cart: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to add ${product.name} to cart'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _futureRecs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading recommendations...'),
                ],
              ),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 32),
                  SizedBox(height: 8),
                  Text('Error loading recommendations'),
                  SizedBox(height: 4),
                  Text('${snapshot.error}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          );
        }
        
        final recs = snapshot.data ?? [];
        debugPrint('🔥 Recommendations loaded: ${recs.length} items');
        if (recs.isNotEmpty) {
          for (int i = 0; i < recs.length; i++) {
            debugPrint('🔥 Recommendation ${i + 1}: ${recs[i].name} - ${recs[i].price}');
          }
        }
        
        if (recs.isEmpty) {
          debugPrint('🔥 No recommendations available');
          return SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recommend_outlined, color: Colors.grey, size: 32),
                  SizedBox(height: 8),
                  Text('No recommendations available'),
                ],
              ),
            ),
          );
        }
        
        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recs.length,
            itemBuilder: (context, i) {
              final product = recs[i];
              return Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[100]!, Colors.grey[200]!],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      // Product Details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _quickAdd(product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal[600],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    minimumSize: Size(0, 20),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
