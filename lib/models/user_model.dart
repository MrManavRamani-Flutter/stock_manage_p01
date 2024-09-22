class Product {
  final String name;
  final int quantity;

  Product({
    required this.name,
    required this.quantity,
  });
}

class User {
  final String userName;
  final String email;
  final String imageUrl;
  final String? shopAddress;
  final int? totalPurchases;
  final int? returnStock;
  final String? contactInfo;
  final List<Product>? productsPurchased;

  User({
    required this.userName,
    required this.email,
    required this.imageUrl,
    this.shopAddress,
    this.totalPurchases,
    this.returnStock,
    this.contactInfo,
    this.productsPurchased,
  });
}
