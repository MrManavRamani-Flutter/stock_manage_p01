import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/category_model.dart';
import '../utils/global.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productCountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Category> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = Global.categories;
    _searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredCategories = Global.categories.where((category) {
        final name = category.name.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: _productCountController,
                decoration: const InputDecoration(labelText: 'Product Count'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newCategory = Category(
                    name: _nameController.text,
                    productCount:
                        int.tryParse(_productCountController.text) ?? 0,
                  );
                  Global.categories.add(newCategory);
                  _nameController.clear();
                  _productCountController.clear();
                  _filterCategories(); // Update the filtered list after adding a new category
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _productCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        buttonText: 'Add',
        onButtonPressed: _addCategory,
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
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
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Categories...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category Grid
            Expanded(
              child: _filteredCategories.isNotEmpty
                  ? CategoryGrid(categories: _filteredCategories)
                  : const Center(
                      child: Text('No categories found'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          categoryName: categories[index].name,
          productCount: categories[index].productCount,
        );
      },
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
