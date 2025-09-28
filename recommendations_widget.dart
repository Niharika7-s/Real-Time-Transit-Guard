import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../utils/simple_cart_manager.dart';

class Recommendation {
  final String id;
  final String name;
  final String category;
  final double price;
  final String reason;

  Recommendation({required this.id, required this.name, required this.category, required this.price, required this.reason});

  factory Recommendation.fromJson(Map<String, dynamic> j) => Recommendation(
    id: j['id'] ?? '',
    name: j['name'] ?? '',
    category: j['category'] ?? '',
    price: (j['price'] ?? 0).toDouble(),
    reason: j['reason'] ?? '',
  );
}

class RecommendationsWidget extends StatefulWidget {
  final String retailerId;
  const RecommendationsWidget({super.key, required this.retailerId});

  @override
  State<RecommendationsWidget> createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  late Future<List<Recommendation>> _futureRecs;
  // Firebase Functions base URL using the actual project ID from firebase_options.dart
  final String functionsBase = 'https://asia-south1-rtg-b-be4b4.cloudfunctions.net';

  @override
  void initState() {
    super.initState();
    _futureRecs = _loadRecs();
  }

  Future<String> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // not signed in
      return '';
    }
    return await user.getIdToken() ?? '';
  }

  Future<List<Recommendation>> _loadRecs() async {
    try {
      final token = await _getIdToken();
      final url = Uri.parse('$functionsBase/recommendations?retailerId=${widget.retailerId}&limit=10&testMode=true'); // remove testMode in prod
      final resp = await http.get(
        url, 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
      );
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch recommendations: ${resp.statusCode} - ${resp.body}');
      }
      
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final recommendations = (body['recommendations'] as List)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList();
      
      // log impressions now
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logImpressions(recommendations);
      });
      
      return recommendations;
    } catch (e) {
      debugPrint('Error loading recommendations: $e');
      rethrow;
    }
  }

  Future<void> _logImpressions(List<Recommendation> recs) async {
    try {
      final token = await _getIdToken();
      final url = Uri.parse('$functionsBase/events?testMode=true'); // remove testMode later
      
      // Batch the requests for better performance
      final futures = recs.map((rec) async {
        final body = {
          'retailerId': widget.retailerId,
          'type': 'product_impression',
          'productId': rec.id,
          'metadata': {'reason': rec.reason}
        };
        
        try {
          await http.post(
            url, 
            headers: {
              'Content-Type': 'application/json', 
              'Authorization': 'Bearer $token'
            }, 
            body: jsonEncode(body)
          );
        } catch (e) {
          debugPrint('Failed to log impression for ${rec.id}: $e');
          // Continue with other requests even if one fails
        }
      });
      
      await Future.wait(futures);
    } catch (e) {
      debugPrint('Error logging impressions: $e');
      // Don't throw - this is a background operation
    }
  }

  Future<void> _quickAdd(Recommendation recommendation) async {
    try {
      // Use SimpleCartManager for consistent cart management
      final product = Product(
        id: recommendation.id,
        name: recommendation.name,
        price: recommendation.price,
        unit: 'kg',
        category: recommendation.category,
        description: recommendation.reason,
      );
      
      await SimpleCartManager.addProduct(product);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recommendation.name} added to cart'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
        );
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recommendation>>(
      future: _futureRecs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        final recs = snapshot.data ?? [];
        if (recs.isEmpty) return Text('No recommendations yet');
        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recs.length,
            itemBuilder: (context, i) {
              final r = recs[i];
              return Container(
                width: 180,
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
                          height: 80,
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
                            children: [
                              Text(
                                r.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹${r.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                r.reason,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _quickAdd(r),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal[600],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: TextStyle(fontSize: 11),
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
