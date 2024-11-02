import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/category_model.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/utils/global.dart';

class CategoryProductView extends StatefulWidget {
  final Category category;

  const CategoryProductView({required this.category, super.key});

  @override
  CategoryProductViewState createState() => CategoryProductViewState();
}

class CategoryProductViewState extends State<CategoryProductView> {
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = Global.products
        .where((product) => product.categoryId == widget.category.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add product logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Products...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _filteredProducts = Global.products
                        .where((product) =>
                            product.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) &&
                            product.categoryId == widget.category.id)
                        .toList();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ListTile(
                          leading: Image.network(
                            'https://via.placeholder.com/50',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(product.name),
                          subtitle: Text('Stock: ${product.stock}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
