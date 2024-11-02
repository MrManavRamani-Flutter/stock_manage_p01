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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryNameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
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
                final categoryName = categoryNameController.text.trim();
                if (categoryName.isNotEmpty) {
                  setState(() {
                    warehouse.categories.add(
                      Category(
                        id: 'C${warehouse.categories.length + 1}',
                        // Generate a unique ID
                        name: categoryName,
                        totalProducts: 0, // Set initial total products to 0
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Warehouses',
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: _showAddWarehouseDialog,
          ),
        ],
      ),
      drawer: const Sidebar(),
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
                    const Icon(Icons.location_on, size: 40, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      warehouse.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(warehouse.location, textAlign: TextAlign.center),
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

// Widget for displaying Warehouse details and its categories
class _WarehouseDetail extends StatelessWidget {
  final Warehouse? selectedWarehouse;
  final Future<void> Function(Warehouse) onAddCategory;

  const _WarehouseDetail({
    required this.selectedWarehouse,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedWarehouse == null) {
      return const Center(
        child: Text(
          'Select a warehouse to view details',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => onAddCategory(selectedWarehouse!),
          icon: const Icon(Icons.add),
          label: const Text('Add Category'),
          style:
              ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
        ),
        const SizedBox(height: 16),
        ...selectedWarehouse!.categories.map((category) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductView(category: category),
              ),
            ),
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Total Products: ${category.totalProducts}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ),
          );
        }),
      ],
    );
  }
}
