class Product {
  final String id;
  final String name;
  final double price; // Price of the product
  int stock; // Stock quantity
  final String description; // Description of the product
  final DateTime createdAt; // Creation date of the product
  final int wornLimitStock; // Minimum stock limit before a warning is triggered
  final String categoryId; // Category ID to which the product belongs

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.createdAt,
    required this.wornLimitStock,
    required this.categoryId,
  });
}
