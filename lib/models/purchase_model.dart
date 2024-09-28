class Purchase {
  final String clientId;
  final String productId; // Add productId field
  final double totalAmount;
  final double totalPayment;
  final double pendingPayment;
  final int stock;

  Purchase({
    required this.clientId,
    required this.productId, // Include in constructor
    required this.totalAmount,
    required this.totalPayment,
    required this.pendingPayment,
    required this.stock,
  });
}
