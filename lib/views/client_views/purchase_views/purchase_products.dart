import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/views/client_views/client_details.dart';

class PurchaseProduct extends StatefulWidget {
  const PurchaseProduct({super.key});

  @override
  PurchaseProductState createState() => PurchaseProductState();
}

class PurchaseProductState extends State<PurchaseProduct> {
  String? selectedClientId;
  final Map<String, int> productQuantities = {};
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    for (var product in Global.products) {
      productQuantities[product.id] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Product>> categorizedProducts = {};
    for (var product in Global.products) {
      categorizedProducts
          .putIfAbsent(product.categoryId, () => [])
          .add(product);
    }

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          'Purchase Products',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Client:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              hint: const Text('Choose Client'),
              value: selectedClientId,
              items: Global.clients.map((client) {
                return DropdownMenuItem(
                  value: client.id,
                  child: Text(client.clientName),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedClientId = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Products:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categorizedProducts.keys.length,
                itemBuilder: (context, categoryIndex) {
                  String categoryId =
                      categorizedProducts.keys.elementAt(categoryIndex);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryId,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categorizedProducts[categoryId]!.length,
                        itemBuilder: (context, productIndex) {
                          Product product =
                              categorizedProducts[categoryId]![productIndex];
                          return ProductDetails(
                            product: product,
                            quantity: productQuantities[product.id]!,
                            onQuantityChanged: (newQuantity) {
                              setState(() {
                                productQuantities[product.id] = newQuantity;
                                _calculateTotalAmount();
                              });
                            },
                          );
                        },
                      ),
                      const Divider(thickness: 1),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Amount: Rs. ${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _performPurchase();
              },
              child: const Text("Submit Purchase"),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateTotalAmount() {
    totalAmount = 0.0;
    productQuantities.forEach((productId, quantity) {
      if (quantity > 0) {
        Product product = Global.products.firstWhere((p) => p.id == productId);
        totalAmount += product.price * quantity;
      }
    });
    setState(() {});
  }

  void _performPurchase() {
    if (selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client.')),
      );
      return;
    }

    if (totalAmount > 0) {
      productQuantities.forEach((productId, quantity) {
        if (quantity > 0) {
          Product product =
              Global.products.firstWhere((p) => p.id == productId);

          if (product.stock >= quantity) {
            double totalPayment = product.price * quantity;

            Purchase newPurchase = Purchase(
              purchaseId: 'PCH${Global.purchases.length + 1}',
              // Unique purchaseId
              clientId: selectedClientId!,
              productId: productId,
              totalAmount: totalPayment,
              totalPayment: 0.0,
              pendingPayment: totalPayment,
              stock: quantity,
            );

            // Update stock
            product.stock -= quantity;

            // Add purchase to the Global.purchases list
            Global.purchases.add(newPurchase);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Not enough stock for ${product.name}.'),
              ),
            );
          }
        }
      });

      final selectedClient =
          Global.clients.firstWhere((client) => client.id == selectedClientId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClientDetails(client: selectedClient),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product to purchase.'),
        ),
      );
    }
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetails({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Description: ${product.description}'),
            const SizedBox(height: 8),
            Text('Price: Rs. ${product.price.toStringAsFixed(2)}'),
            Text('Available Stock: ${product.stock}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 0) {
                          onQuantityChanged(quantity - 1);
                        }
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (quantity < product.stock) {
                          onQuantityChanged(quantity + 1);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (quantity > 0)
              Text(
                'Total for ${product.name}: Rs. ${(product.price * quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
