import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        buttonText: '',
        onButtonPressed: () {},
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            CategoryCard(categoryName: 'Central Components', productCount: 5),
            CategoryCard(categoryName: 'Peripherals', productCount: 3),
            CategoryCard(categoryName: 'Connectors', productCount: 2),
            CategoryCard(categoryName: 'Body', productCount: 4),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final int productCount;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoryName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('$productCount products'),
          ],
        ),
      ),
    );
  }
}
