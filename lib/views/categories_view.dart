import 'package:flutter/cupertino.dart';
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
    _showCategoryDialog(
      title: 'Add Category',
      onSubmit: (name, productCount) {
        setState(() {
          final newCategory = Category(
            name: name,
            productCount: int.tryParse(productCount) ?? 0,
          );
          Global.categories.add(newCategory);
          _filterCategories();
        });
      },
    );
  }

  void _editCategory(int index) {
    final category = _filteredCategories[index];
    _showCategoryDialog(
      title: 'Edit Category',
      name: category.name,
      productCount: category.productCount.toString(),
      onSubmit: (name, productCount) {
        setState(() {
          Global.categories[index] = Category(
            name: name,
            productCount: int.tryParse(productCount) ?? 0,
          );
          _filterCategories();
        });
      },
    );
  }

  void _deleteCategory(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  Global.categories.removeAt(index);
                  _filterCategories();
                });
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryDialog({
    required String title,
    String? name,
    String? productCount,
    required Function(String name, String productCount) onSubmit,
  }) {
    if (name != null) _nameController.text = name;
    if (productCount != null) _productCountController.text = productCount;

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Category Name',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _productCountController,
                placeholder: 'Product Count',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                _nameController.clear();
                _productCountController.clear();
                setState(() {});
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _productCountController.text.isNotEmpty) {
                  onSubmit(_nameController.text, _productCountController.text);
                  _nameController.clear();
                  _productCountController.clear();
                  Navigator.of(context).pop();
                } else {
                  // Show a message if the input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter all fields')),
                  );
                }
              },
              child: const Text('Submit'),
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
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category List
            Expanded(
              child: _filteredCategories.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              _filteredCategories[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                '${_filteredCategories[index].productCount} products'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editCategory(index),
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteCategory(index),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
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
