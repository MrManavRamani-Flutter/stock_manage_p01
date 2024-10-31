import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
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
        final name = warehouse.name.toLowerCase();
        final location = warehouse.location.toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onWarehouseSelected(Warehouse warehouse) {
    setState(() {
      _selectedWarehouse = warehouse;
    });
  }

  Widget _buildWarehouseDetail() {
    if (_selectedWarehouse == null) {
      return const Center(
        child: Text(
          'Select a warehouse to view details',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final categories = _selectedWarehouse!
        .categories; // Assuming the warehouse model has categories

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((category) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductView(category: category),
              ),
            );
          },
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.network(category.imageUrl,
                  width: 50, height: 50), // Assuming category has an image URL
              title: Text(category.name),
              subtitle: Text(
                  'Total Products: ${category.totalProducts}'), // Assuming totalProducts field
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddWarehouseDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    showDialog(
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add the warehouse to the list
                Global.warehouses.add(
                  Warehouse(
                    id: 'W${Global.warehouses.length + 1}', // Generate a new id
                    name: nameController.text,
                    location: locationController.text,
                    categories: [], // Empty list for categories initially
                  ),
                );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Warehouses',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showAddWarehouseDialog(context),
            icon: const Icon(Icons.add, color: AppColors.primaryColor),
            label: const Text(
              'Add',
              style: TextStyle(color: AppColors.primaryColor),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(100),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  hintText: 'Search Warehouses...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Scrollable List of Warehouses
            SizedBox(
              height: 150, // Adjust as per design
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filteredWarehouses.length,
                itemBuilder: (context, index) {
                  final warehouse = _filteredWarehouses[index];
                  return GestureDetector(
                    onTap: () => _onWarehouseSelected(warehouse),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 150, // Adjust size as per design
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                size: 40, color: Colors.blue),
                            const SizedBox(height: 8),
                            Text(
                              warehouse.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(warehouse.location,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildWarehouseDetail(),
            ),
          ],
        ),
      ),
    );
  }
}
