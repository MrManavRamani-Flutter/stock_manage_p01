import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';

import '../models/warehouse_model.dart';
import '../utils/global.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class WarehousesView extends StatefulWidget {
  const WarehousesView({super.key});

  @override
  State<WarehousesView> createState() => _WarehousesViewState();
}

class _WarehousesViewState extends State<WarehousesView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Warehouse> _filteredWarehouses = [];

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

  void _addWarehouse() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Warehouse'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Warehouse Name',
                  hintText: 'Enter warehouse name',
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter warehouse location',
                ),
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
                if (_nameController.text.isEmpty ||
                    _locationController.text.isEmpty) {
                  // Show a message if the input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter all fields')),
                  );
                } else {
                  setState(() {
                    Global.warehouses.add(
                      Warehouse(
                        name: _nameController.text,
                        location: _locationController.text,
                      ),
                    );
                    _nameController.clear();
                    _locationController.clear();
                    _searchController.clear();
                    _filterWarehouses(); // Update the filtered list after adding a new warehouse
                  });
                  Navigator.of(context).pop();
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
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Warehouses',
        buttonText: 'Add',
        onButtonPressed: _addWarehouse,
      ),
      drawer: const Sidebar(),
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
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Warehouses...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: const Icon(Icons.search),
                ),
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredWarehouses.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredWarehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = _filteredWarehouses[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(warehouse.name),
                          subtitle: Text(warehouse.location),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No warehouses found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
