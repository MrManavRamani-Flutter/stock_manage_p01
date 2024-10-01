import 'package:flutter/material.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';

class PurchaseDetailsList extends StatefulWidget {
  final List<Purchase> purchases;

  const PurchaseDetailsList({
    super.key,
    required this.purchases,
  });

  @override
  PurchaseDetailsListState createState() => PurchaseDetailsListState();
}

class PurchaseDetailsListState extends State<PurchaseDetailsList> {
  final List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(List.generate(widget.purchases.length, (_) => false));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.purchases.length,
      itemBuilder: (context, index) {
        final purchase = widget.purchases[widget.purchases.length - index - 1];
        final product = _getProductById(purchase.productId);

        return _buildProductCard(
          productImage: 'assets/img/products/tiles_1.jpeg',
          productName: product.name,
          totalAmount: 'Rs. ${purchase.totalAmount.toStringAsFixed(2)}',
          totalPayment: 'Rs. ${purchase.totalPayment.toStringAsFixed(2)}',
          pendingPayment: 'Rs. ${purchase.pendingPayment.toStringAsFixed(2)}',
          stock: '${purchase.stock} units',
          isSelected: _selectedItems[index],
          isPaymentCompleted: purchase.pendingPayment == 0, // New parameter
        );
      },
    );
  }

  Product _getProductById(String productId) {
    return Global.products.firstWhere(
      (prod) => prod.id == productId,
      orElse: () => Product(
        id: 'unknown',
        name: 'Unknown Product',
        price: 0.0,
        stock: 0,
        description: 'No Description',
        createdAt: DateTime.now(),
        wornLimitStock: 0,
        categoryId: 'N/A',
      ),
    );
  }

  Widget _buildProductCard({
    required String productImage,
    required String productName,
    required String totalAmount,
    required String totalPayment,
    required String pendingPayment,
    required String stock,
    required bool isSelected,
    required bool isPaymentCompleted, // New parameter to check payment status
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(productImage, width: 60, height: 60, fit: BoxFit.cover),
            const SizedBox(width: 20),
            Expanded(
              child: _buildProductInfo(
                productName: productName,
                totalAmount: totalAmount,
                totalPayment: totalPayment,
                pendingPayment: pendingPayment,
                stock: stock,
              ),
            ),
            // Payment status icon on the right
            Icon(
              isPaymentCompleted ? Icons.check_circle : Icons.pending,
              color: isPaymentCompleted ? Colors.green : Colors.red,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Column _buildProductInfo({
    required String productName,
    required String totalAmount,
    required String totalPayment,
    required String pendingPayment,
    required String stock,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(productName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Total Amount: $totalAmount"),
        Text("Total Payment: $totalPayment"),
        Text("Pending Payment: $pendingPayment"),
        Text("Stock: $stock"),
      ],
    );
  }
}
