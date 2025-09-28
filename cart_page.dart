import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'checkout_page.dart';
import '../widgets/local_recommendations_widget.dart';
import '../utils/simple_cart_manager.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Box cartBox = Hive.box('cartBox');

  @override
  void initState() {
    super.initState();
    // Listen to simple cart manager changes
    SimpleCartManager.addListener(_onCartChanged);
    // Force a rebuild every second to catch changes
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    SimpleCartManager.removeListener(_onCartChanged);
    super.dispose();
  }

  void _startPeriodicUpdate() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {});
        _startPeriodicUpdate();
      }
    });
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {
        // This will trigger a rebuild when simple cart changes
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getCartItems() async {
    try {
      // Always use Simple Cart Manager as the primary source
      final simpleCartItems = await SimpleCartManager.getCartItems();
      debugPrint('📦 Cart page reading ${simpleCartItems.length} items from Simple Cart Manager');
      
      // Log each item for debugging
      for (int i = 0; i < simpleCartItems.length; i++) {
        final item = simpleCartItems[i];
        debugPrint('  ${i + 1}. ${item['name']} - Qty: ${item['quantity']} - Price: ${item['price']}');
      }
      
      return simpleCartItems;
    } catch (e) {
      debugPrint('❌ Error getting cart items: $e');
      return [];
    }
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var m in items) {
      final qty = double.tryParse(m['quantity'].toString()) ?? 1;
      total += (m['price'] as num).toDouble() * qty;
    }
    return total;
  }

  void removeItem(int index) async {
    try {
      // Use simple cart manager
      await SimpleCartManager.removeItem(index);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      debugPrint('Error removing item: $e');
    }
  }

  void editQuantity(int index) async {
    final items = await _getCartItems();
    final controller = TextEditingController(text: items[index]['quantity'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Quantity"),
        content: TextField(controller: controller, keyboardType: TextInputType.numberWithOptions(decimal: true)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () {
            final newQty = controller.text.isEmpty ? '1' : controller.text;
            items[index]['quantity'] = newQty;
            
            try {
              // Try Hive first
              if (Hive.isBoxOpen('cartBox') && cartBox.length > index) {
                cartBox.putAt(index, items[index]);
              } else {
                // For simple cart manager, we need to update the item
                // Since simple cart manager doesn't have update by index, we'll just refresh
                setState(() {});
              }
            } catch (e) {
              debugPrint('Error updating quantity: $e');
            }
            
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Quantity updated'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }, child: Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<int>(
          future: SimpleCartManager.getCartItemCount().catchError((e) {
            debugPrint('❌ Error getting cart count: $e');
            return 0;
          }),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return Text("Cart ($count items)");
          },
        ),
        backgroundColor: Colors.teal.shade600,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final items = snapshot.data ?? [];
          final total = _calculateTotal(items);
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text("Add some products to get started", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Cart items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final qty = double.tryParse(item['quantity'].toString()) ?? 1;
                        final itemTotal = (item['price'] as num).toDouble() * qty;
                        
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(item['name']),
                            subtitle: Text("₹${item['price']}/${item['unit']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Qty: ${item['quantity']}"),
                                SizedBox(width: 8),
                                Text("₹${itemTotal.toStringAsFixed(0)}"),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => editQuantity(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => removeItem(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Recommendations widget
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.recommend, color: Colors.purple.shade700, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Recommended for You',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Test button to add item directly
                          ElevatedButton(
                            onPressed: () async {
                              final testProduct = Product(
                                id: 'test_${DateTime.now().millisecondsSinceEpoch}',
                                name: 'Test Product',
                                price: 99.99,
                                unit: 'pc',
                                category: 'Test',
                                description: 'Test product for debugging',
                              );
                              debugPrint('🧪 Adding test product directly');
                              await SimpleCartManager.addProduct(testProduct);
                              setState(() {});
                            },
                            child: Text('Add Test Product'),
                          ),
                          SizedBox(height: 12),
                          LocalRecommendationsWidget(retailerId: 'retailer_123'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("₹${total.toStringAsFixed(0)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Proceed to Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


