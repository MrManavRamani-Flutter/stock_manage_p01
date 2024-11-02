import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/category_model.dart';
import 'package:stock_manage/models/warehouse_model.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/views/warehouse_view/category_product_view.dart';
import 'package:stock_manage/widgets/custom_sidebar.dart';

class WarehousesView extends StatefulWidget {
  const WarehousesView({super.key});

  @override
  State<WarehousesView> createState() => _WarehousesViewState();
}

class _WarehousesViewState extends State<WarehousesView> {
  final TextEditingController _searchController = TextEditingController();
  List<Warehouse> _filteredWarehouses = [];
  Warehouse? _selectedWarehouse;

  @override
  void initState() {
    super.initState();
    _filteredWarehouses = Global.warehouses;
    _searchController.addListener(_filterWarehouses);
  }

  void _filterWarehouses() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredWarehouses = Global.warehouses.where((warehouse) {
        return warehouse.name.toLowerCase().contains(query) ||
            warehouse.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onWarehouseSelected(Warehouse warehouse) {
    setState(() {
      _selectedWarehouse = warehouse;
    });
  }

  Future<void> _showAddWarehouseDialog() async {
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Warehouse'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Warehouse Name'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Global.warehouses.add(
                    Warehouse(
                      id: 'W${Global.warehouses.length + 1}',
                      name: nameController.text,
                      location: locationController.text,
                      categories: [],
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    _refreshWarehouseData();
  }

  Future<void> _showAddCategoryDialog(Warehouse warehouse) async {
    final categoryNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: categoryNameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final categoryName = categoryNameController.text.trim();
                if (categoryName.isNotEmpty) {
                  setState(() {
                    warehouse.categories.add(
                      Category(
                        id: 'C${warehouse.categories.length + 1}',
                        name: categoryName,
                        totalProducts: 0,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                  _refreshWarehouseData();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _refreshWarehouseData() {
    setState(() {
      _filteredWarehouses = Global.warehouses;
    });
  }

  void _incrementProductCount(String warehouseId, String categoryId) {
    setState(() {
      final warehouse =
          Global.warehouses.firstWhere((wh) => wh.id == warehouseId);
      final category =
          warehouse.categories.firstWhere((cat) => cat.id == categoryId);
      category.totalProducts += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Warehouses',
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          InkWell(
            onTap: _showAddWarehouseDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
              decoration: BoxDecoration(
                // color: AppColors
                //     .primaryColor, // Replace with your desired background color
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: const Row(
                mainAxisSize:
                    MainAxisSize.min, // Size only as much as the content needs
                children: [
                  Icon(Icons.add, color: AppColors.white), // Icon color
                  SizedBox(width: 8.0), // Spacing between icon and text
                  Text(
                    'Add Warehouse',
                    style: TextStyle(
                        color: AppColors.white, fontSize: 16.0), // Text styling
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(searchController: _searchController),
            const SizedBox(height: 16),
            _WarehouseList(
              warehouses: _filteredWarehouses,
              onWarehouseSelected: _onWarehouseSelected,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _WarehouseDetail(
                selectedWarehouse: _selectedWarehouse,
                onAddCategory: _showAddCategoryDialog,
                onIncrementProductCount: _incrementProductCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for the Search Bar
class _SearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const _SearchBar({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search Warehouses...',
          prefixIcon: const Icon(Icons.search, color: AppColors.gray),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// Widget for the horizontally scrollable Warehouse List
class _WarehouseList extends StatelessWidget {
  final List<Warehouse> warehouses;
  final Function(Warehouse) onWarehouseSelected;

  const _WarehouseList({
    required this.warehouses,
    required this.onWarehouseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = warehouses[index];
          return GestureDetector(
            onTap: () => onWarehouseSelected(warehouse),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        size: 40, color: AppColors.primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      warehouse.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      warehouse.location,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget for displaying Warehouse Details and Categories
class _WarehouseDetail extends StatelessWidget {
  final Warehouse? selectedWarehouse;
  final Function(Warehouse) onAddCategory;
  final Function(String, String) onIncrementProductCount;

  const _WarehouseDetail({
    required this.selectedWarehouse,
    required this.onAddCategory,
    required this.onIncrementProductCount,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedWarehouse == null) {
      return const Center(child: Text('Select a warehouse to view details.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedWarehouse!.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => onAddCategory(selectedWarehouse!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Change color as desired
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize
                      .min, // Size only as much as the content needs
                  children: [
                    Icon(Icons.add, color: Colors.white), // Icon color
                    SizedBox(width: 8.0), // Spacing between icon and text
                    Text(
                      'Add Category',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.0), // Text styling
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: selectedWarehouse!.categories.length,
            itemBuilder: (context, index) {
              final category = selectedWarehouse!.categories[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductView(
                          warehouseId: selectedWarehouse!.id,
                          categoryId: category.id,
                          onProductAdded: () => onIncrementProductCount(
                              selectedWarehouse!.id, category.id),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category,
                          size: 40,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Products: ${category.totalProducts}',
                                style: const TextStyle(
                                  color: AppColors.gray,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
