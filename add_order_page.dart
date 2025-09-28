import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_catalog.dart';
import '../models/product.dart';
import '../utils/simple_cart_manager.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final TextEditingController searchController = TextEditingController();
  final qtyControllers = <int, TextEditingController>{};
  final Box cartBox = Hive.box('cartBox');
  
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = ProductCatalog.items;
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = ProductCatalog.items.where((item) => 
        item['name'].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void addToCart(Map<String, dynamic> item, int index) async {
    final qty = qtyControllers[index]?.text ?? '1';
    final quantity = double.tryParse(qty) ?? 1.0;
    
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    // Create Product object and use SimpleCartManager
    final product = Product(
      id: item['id'] ?? 'catalog_${DateTime.now().millisecondsSinceEpoch}',
      name: item['name'],
      price: (item['price'] as num).toDouble(),
      unit: item['unit'],
      category: item['category'],
      description: item['description'] ?? '',
    );

    // Add the product to cart using SimpleCartManager
    await SimpleCartManager.addProduct(product);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart')),
    );
    
    // Clear the quantity field
    qtyControllers[index]?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Items"),
        backgroundColor: Colors.purple.shade600,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterItems,
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                qtyControllers[index] ??= TextEditingController(text: '1');
                
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text('₹${item['price']}/${item['unit']} • ${item['category']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: qtyControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Qty',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => addToCart(item, index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            minimumSize: Size(40, 40),
                          ),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    for (final controller in qtyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
