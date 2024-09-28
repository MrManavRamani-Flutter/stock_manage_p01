import 'package:flutter/material.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';

class PurchaseDetailsList extends StatelessWidget {
  final List<Purchase> purchases;

  const PurchaseDetailsList({super.key, required this.purchases});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        Product product = Global.products.firstWhere(
          (prod) => prod.id == purchases[index].productId,
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

        return _buildProductCard(
          productImage: 'assets/img/products/tiles_1.jpeg',
          productName: product.name,
          totalAmount: '\$${purchases[index].totalAmount.toStringAsFixed(2)}',
          totalPayment: '\$${purchases[index].totalPayment.toStringAsFixed(2)}',
          pendingPayment:
              '\$${purchases[index].pendingPayment.toStringAsFixed(2)}',
          stock: '${purchases[index].stock} units',
        );
      },
    );
  }

  Widget _buildProductCard({
    required String productImage,
    required String productName,
    required String totalAmount,
    required String totalPayment,
    required String pendingPayment,
    required String stock,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(productImage, width: 60, height: 60, fit: BoxFit.cover),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Total Amount: $totalAmount"),
                  Text("Total Payment: $totalPayment"),
                  Text("Pending Payment: $pendingPayment"),
                  Text("Stock: $stock"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
