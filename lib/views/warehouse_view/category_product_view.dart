import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/utils/global.dart';

class CategoryProductView extends StatefulWidget {
  final String warehouseId;
  final String categoryId;
  final VoidCallback onProductAdded;

  const CategoryProductView({
    super.key,
    required this.warehouseId,
    required this.categoryId,
    required this.onProductAdded,
  });

  @override
  CategoryProductViewState createState() => CategoryProductViewState();
}

class CategoryProductViewState extends State<CategoryProductView> {
  void _addProduct(BuildContext context) {
    final productNameController = TextEditingController();
    final productStockController = TextEditingController();
    final productPriceController = TextEditingController();
    final productDescriptionController = TextEditingController();
    final productWornLimitStockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: productStockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: productPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: productDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: productWornLimitStockController,
                  decoration: const InputDecoration(
                    labelText: 'Worn Limit Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final productName = productNameController.text;
                final stock = int.tryParse(productStockController.text) ?? 0;
                final price =
                    double.tryParse(productPriceController.text) ?? 0.0;
                final description = productDescriptionController.text;
                final wornLimitStock =
                    int.tryParse(productWornLimitStockController.text) ?? 0;

                if (productName.isNotEmpty && stock > 0 && price > 0) {
                  Global.products.add(
                    Product(
                      id: 'P${Global.products.length + 1}',
                      name: productName,
                      price: price,
                      stock: stock,
                      description: description,
                      createdAt: DateTime.now(),
                      wornLimitStock: wornLimitStock,
                      categoryId: widget.categoryId,
                      warehouseId: widget.warehouseId,
                    ),
                  );

                  widget
                      .onProductAdded(); // Notify that a product has been added
                  Navigator.of(context).pop();
                  setState(() {}); // Update the UI to reflect the new product
                } else {
                  // Show a snack bar if the input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill in all fields correctly!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter products by categoryId and warehouseId
    final filteredProducts = Global.products
        .where((product) =>
            product.categoryId == widget.categoryId &&
            product.warehouseId == widget.warehouseId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Products',
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          InkWell(
            onTap: () => _addProduct(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
              decoration: BoxDecoration(
                color: AppColors
                    .primaryColor, // Replace with your desired background color
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: const Row(
                mainAxisSize:
                    MainAxisSize.min, // Size only as much as the content needs
                children: [
                  Icon(Icons.add, color: Colors.white), // Icon color
                  SizedBox(width: 8.0), // Spacing between icon and text
                  Text(
                    'Add Product',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16.0), // Text styling
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: filteredProducts.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stock: ${product.stock}'),
                          Text('Price: \$${product.price.toStringAsFixed(2)}'),
                          Text('Description: ${product.description}'),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text('No products found for this category.'),
              ),
      ),
    );
  }
}
