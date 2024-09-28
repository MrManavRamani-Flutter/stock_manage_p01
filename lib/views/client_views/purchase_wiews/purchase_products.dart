import 'package:flutter/material.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';

class PurchaseProduct extends StatefulWidget {
  final String clientId;

  const PurchaseProduct({super.key, required this.clientId});

  @override
  PurchaseProductState createState() => PurchaseProductState();
}

class PurchaseProductState extends State<PurchaseProduct> {
  final Map<String, int> productQuantities = {};
  final Map<String, double> productPayments = {};
  final double minPaymentPercentage = 0.15; // Minimum payment is 15%
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    for (var product in Global.products) {
      productQuantities[product.id] = 0;
      productPayments[product.id] = 0.0; // Initialize payment amounts
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

    return WillPopScope(
      onWillPop: () async {
        // Call the method to reload data before popping
        _reloadData();
        return true; // Allow pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Purchase Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

                              // Handle quantity changes
                              onQuantityChanged: (newQuantity) {
                                setState(() {
                                  productQuantities[product.id] = newQuantity;
                                  _calculateTotalAmount();
                                });
                              },

                              // Handle payment changes
                              paymentChanged: (payment) {
                                setState(() {
                                  productPayments[product.id] = payment;
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
                "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    if (totalAmount > 0) {
      bool isValidPayment = true;

      productQuantities.forEach((productId, quantity) {
        if (quantity > 0) {
          Product product =
              Global.products.firstWhere((p) => p.id == productId);
          double minPayment = product.price * minPaymentPercentage * quantity;
          double maxPayment = product.price * quantity;

          double payment = productPayments[productId] ?? 0.0;

          // Validate payment
          if (payment < minPayment || payment > maxPayment) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Payment for ${product.name} must be between \$${minPayment.toStringAsFixed(2)} and \$${maxPayment.toStringAsFixed(2)}.'),
              ),
            );
            isValidPayment = false;
            // Return early to prevent further processing
            return;
          }

          // Validate stock
          if (product.stock >= quantity && isValidPayment) {
            double remainingPayment = (product.price * quantity) - payment;

            Purchase newPurchase = Purchase(
              clientId: widget.clientId,
              productId: productId,
              totalAmount: product.price * quantity,
              totalPayment: payment,
              pendingPayment: remainingPayment > 0 ? remainingPayment : 0,
              stock: quantity,
            );

            // Update stock
            product.stock -= quantity;

            // Add the purchase to the Global.purchases list
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

      if (isValidPayment) {
        Navigator.pop(context); // Only navigate if all conditions are satisfied
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product to purchase.'),
        ),
      );
    }
  }

  // Method to reload data
  void _reloadData() {
    // Update Global data or refresh data from a database or API
    setState(() {
      // This can be a call to fetch fresh data
      // For example, if you are fetching products again:
      Global.products = fetchUpdatedProducts(); // Assuming this function exists
    });
  }

  // Mock function to represent fetching updated products
  List<Product> fetchUpdatedProducts() {
    // Implement your logic to fetch the latest products
    return Global.products; // Return updated products, here it's a mock
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<double> paymentChanged;

  const ProductDetails({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    required this.paymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    double minPayment =
        product.price * 0.15 * quantity; // Minimum payment (15% of total)
    double maxPayment =
        product.price * quantity; // Maximum payment based on quantity

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
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
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
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText:
                          'Payment (Min: \$${minPayment.toStringAsFixed(2)}, Max: \$${maxPayment.toStringAsFixed(2)})',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      double payment = double.tryParse(value) ?? 0.0;
                      paymentChanged(payment);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (quantity > 0)
              Text(
                'Total for ${product.name}: \$${(product.price * quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
