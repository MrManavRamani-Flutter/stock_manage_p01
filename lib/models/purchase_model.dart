class Purchase {
  final String purchaseId;
  final String clientId;
  final String productId;
  final double totalAmount;
  double totalPayment;
  double pendingPayment;
  final int stock;
  DateTime createdAt;

  Purchase({
    required this.purchaseId,
    required this.clientId,
    required this.productId, // Include in constructor
    required this.totalAmount,
    required this.totalPayment, // Now mutable
    required this.pendingPayment, // Now mutable
    required this.stock,
    required this.createdAt, // Initialize here
  });
}
