class RecommendationRules {
  // Map where key = product name, value = list of recommended products
  static final Map<String, List<Map<String, String>>> recommendations = {
    // Rice & Grains
    "Basmati Rice – 5kg": [
      {"name": "Sona Masoori Rice – 25kg", "price": "₹1250"},
      {"name": "Wheat Flour – 10kg", "price": "₹460"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Salt – 1kg", "price": "₹18"},
    ],
    "Sona Masoori Rice – 25kg": [
      {"name": "Basmati Rice – 5kg", "price": "₹520"},
      {"name": "Wheat Flour – 10kg", "price": "₹460"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Dal – 1kg", "price": "₹130"},
    ],
    "Wheat Flour – 10kg": [
      {"name": "Basmati Rice – 5kg", "price": "₹520"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Sugar – 5kg", "price": "₹230"},
      {"name": "Salt – 1kg", "price": "₹18"},
    ],
    "Maida – 5kg": [
      {"name": "Wheat Flour – 10kg", "price": "₹460"},
      {"name": "Sugar – 5kg", "price": "₹230"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Baking Soda – 100g", "price": "₹20"},
    ],

    // Lentils & Dals
    "Toor Dal – 5kg": [
      {"name": "Moong Dal – 1kg", "price": "₹130"},
      {"name": "Chana Dal – 2kg", "price": "₹220"},
      {"name": "Basmati Rice – 5kg", "price": "₹520"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
    ],
    "Moong Dal – 1kg": [
      {"name": "Toor Dal – 5kg", "price": "₹720"},
      {"name": "Chana Dal – 2kg", "price": "₹220"},
      {"name": "Rice", "price": "₹520"},
      {"name": "Spices", "price": "₹100"},
    ],

    // Cooking Essentials
    "Sugar – 5kg": [
      {"name": "Salt – 1kg", "price": "₹18"},
      {"name": "Tea – 250g", "price": "₹160"},
      {"name": "Coffee – 100g", "price": "₹170"},
      {"name": "Milk – 1L", "price": "₹52"},
    ],
    "Salt – 1kg": [
      {"name": "Sugar – 5kg", "price": "₹230"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Spices", "price": "₹100"},
      {"name": "Rice", "price": "₹520"},
    ],
    "Cooking Oil – 5L": [
      {"name": "Basmati Rice – 5kg", "price": "₹520"},
      {"name": "Dal – 1kg", "price": "₹130"},
      {"name": "Salt – 1kg", "price": "₹18"},
      {"name": "Spices", "price": "₹100"},
    ],

    // Spices
    "Red Chili Powder – 500g": [
      {"name": "Turmeric Powder – 500g", "price": "₹90"},
      {"name": "Coriander Powder – 500g", "price": "₹100"},
      {"name": "Garam Masala – 100g", "price": "₹60"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
    ],
    "Turmeric Powder – 500g": [
      {"name": "Red Chili Powder – 500g", "price": "₹180"},
      {"name": "Coriander Powder – 500g", "price": "₹100"},
      {"name": "Cumin Seeds – 200g", "price": "₹95"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
    ],

    // Packaged Foods
    "Maggi Noodles – 12-pack": [
      {"name": "Knorr Soup – pack", "price": "₹90"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Vegetables", "price": "₹50"},
      {"name": "Spices", "price": "₹100"},
    ],
    "Parle-G Biscuits – 1 pack": [
      {"name": "Tea – 250g", "price": "₹160"},
      {"name": "Milk – 1L", "price": "₹52"},
      {"name": "Coffee – 100g", "price": "₹170"},
      {"name": "Sugar – 5kg", "price": "₹230"},
    ],
    "Bourbon Biscuits – 120g": [
      {"name": "Tea – 250g", "price": "₹160"},
      {"name": "Coffee – 100g", "price": "₹170"},
      {"name": "Milk – 1L", "price": "₹52"},
      {"name": "Parle-G Biscuits – 1 pack", "price": "₹10"},
    ],

    // Fresh Produce
    "Tomatoes – 1kg": [
      {"name": "Onions – 1kg", "price": "₹30"},
      {"name": "Potatoes – 1kg", "price": "₹25"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Spices", "price": "₹100"},
    ],
    "Onions – 1kg": [
      {"name": "Tomatoes – 1kg", "price": "₹28"},
      {"name": "Potatoes – 1kg", "price": "₹25"},
      {"name": "Garlic – 1kg", "price": "₹120"},
      {"name": "Ginger – 500g", "price": "₹60"},
    ],
    "Potatoes – 1kg": [
      {"name": "Tomatoes – 1kg", "price": "₹28"},
      {"name": "Onions – 1kg", "price": "₹30"},
      {"name": "Cooking Oil – 5L", "price": "₹750"},
      {"name": "Spices", "price": "₹100"},
    ],

    // Dairy Products
    "Amul Milk – 1L": [
      {"name": "Curd – 500g", "price": "₹35"},
      {"name": "Butter – 100g", "price": "₹48"},
      {"name": "Cheese Slices – 10 pack", "price": "₹130"},
      {"name": "Tea – 250g", "price": "₹160"},
    ],
    "Butter – 100g": [
      {"name": "Amul Milk – 1L", "price": "₹52"},
      {"name": "Cheese Slices – 10 pack", "price": "₹130"},
      {"name": "Bread", "price": "₹30"},
      {"name": "Jam – 500g", "price": "₹160"},
    ],
    "Cheese Slices – 10 pack": [
      {"name": "Butter – 100g", "price": "₹48"},
      {"name": "Amul Milk – 1L", "price": "₹52"},
      {"name": "Bread", "price": "₹30"},
      {"name": "Tomatoes – 1kg", "price": "₹28"},
    ],

    // Beverages
    "Tea – 250g": [
      {"name": "Sugar – 5kg", "price": "₹230"},
      {"name": "Milk – 1L", "price": "₹52"},
      {"name": "Biscuits", "price": "₹25"},
      {"name": "Coffee – 100g", "price": "₹170"},
    ],
    "Coffee – 100g": [
      {"name": "Sugar – 5kg", "price": "₹230"},
      {"name": "Milk – 1L", "price": "₹52"},
      {"name": "Tea – 250g", "price": "₹160"},
      {"name": "Biscuits", "price": "₹25"},
    ],
    "Coca-Cola – 2L": [
      {"name": "Pepsi – 500ml", "price": "₹35"},
      {"name": "Thums Up – 1.25L", "price": "₹70"},
      {"name": "Bisleri Water – 1L", "price": "₹18"},
      {"name": "Snacks", "price": "₹20"},
    ],

    // Personal Care
    "Lifebuoy Soap – 4 pack": [
      {"name": "Shampoo – 650ml", "price": "₹280"},
      {"name": "Detergent Powder – 1kg", "price": "₹115"},
      {"name": "Body Wash – 250ml", "price": "₹125"},
      {"name": "Handwash – 200ml", "price": "₹85"},
    ],
    "Shampoo – 650ml": [
      {"name": "Soap – 4 pack", "price": "₹90"},
      {"name": "Body Wash – 250ml", "price": "₹125"},
      {"name": "Handwash – 200ml", "price": "₹85"},
      {"name": "Deodorant", "price": "₹180"},
    ],
    "Detergent Powder – 1kg": [
      {"name": "Soap – 4 pack", "price": "₹90"},
      {"name": "Fabric Softener", "price": "₹120"},
      {"name": "Bleach", "price": "₹60"},
      {"name": "Washing Machine Cleaner", "price": "₹80"},
    ],

    // Cleaning Products
    "Surf Excel Detergent – 1kg": [
      {"name": "Rin Bar – 4 pack", "price": "₹45"},
      {"name": "Fabric Softener", "price": "₹120"},
      {"name": "Bleach", "price": "₹60"},
      {"name": "Stain Remover", "price": "₹90"},
    ],
    "Vim Dishwashing Bar – 200g": [
      {"name": "Dishwashing Liquid", "price": "₹85"},
      {"name": "Kitchen Cleaner", "price": "₹95"},
      {"name": "Sponge", "price": "₹25"},
      {"name": "Scrubber", "price": "₹20"},
    ],
    "Harpic Toilet Cleaner – 500ml": [
      {"name": "Toilet Brush", "price": "₹150"},
      {"name": "Floor Cleaner – 500ml", "price": "₹95"},
      {"name": "Room Freshener", "price": "₹55"},
      {"name": "Disinfectant", "price": "₹120"},
    ],

    // Fallback recommendations for common items
    "Bread": [
      {"name": "Butter – 100g", "price": "₹48"},
      {"name": "Jam – 500g", "price": "₹160"},
      {"name": "Cheese Slices – 10 pack", "price": "₹130"},
      {"name": "Milk – 1L", "price": "₹52"},
    ],
    "Eggs": [
      {"name": "Milk – 1L", "price": "₹52"},
      {"name": "Butter – 100g", "price": "₹48"},
      {"name": "Bread", "price": "₹30"},
      {"name": "Cheese Slices – 10 pack", "price": "₹130"},
    ],
  };

  // Get recommendations for a specific product
  static List<Map<String, String>> getRecommendations(String productName) {
    // Try exact match first
    if (recommendations.containsKey(productName)) {
      return recommendations[productName]!;
    }
    
    // Try partial match for more flexibility
    for (String key in recommendations.keys) {
      if (productName.toLowerCase().contains(key.toLowerCase()) || 
          key.toLowerCase().contains(productName.toLowerCase())) {
        return recommendations[key]!;
      }
    }
    
    // Return empty list if no recommendations found
    return [];
  }

  // Get recommendations based on cart contents
  static List<Map<String, String>> getCartRecommendations(List<String> cartProducts) {
    Set<Map<String, String>> allRecommendations = {};
    
    for (String product in cartProducts) {
      List<Map<String, String>> productRecs = getRecommendations(product);
      allRecommendations.addAll(productRecs);
    }
    
    // Remove products that are already in cart
    List<Map<String, String>> filteredRecs = allRecommendations
        .where((rec) => !cartProducts.any((cartProduct) => 
            rec['name']!.toLowerCase().contains(cartProduct.toLowerCase()) ||
            cartProduct.toLowerCase().contains(rec['name']!.toLowerCase())))
        .toList();
    
    // Return top 5 unique recommendations
    return filteredRecs.take(5).toList();
  }
}


