import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
    _showWarehouseDialog(
      title: 'Add Warehouse',
      onSubmit: (name, location) {
        setState(() {
          Global.warehouses.add(Warehouse(name: name, location: location));
          _filterWarehouses();
        });
      },
    );
  }

  void _editWarehouse(int index) {
    final warehouse = _filteredWarehouses[index];
    _showWarehouseDialog(
      title: 'Edit Warehouse',
      name: warehouse.name,
      location: warehouse.location,
      onSubmit: (name, location) {
        setState(() {
          Global.warehouses[index] = Warehouse(name: name, location: location);
          _filterWarehouses();
        });
      },
    );
  }

  void _deleteWarehouse(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Warehouse'),
          content:
              const Text('Are you sure you want to delete this warehouse?'),
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
                  Global.warehouses.removeAt(index);
                  _filterWarehouses();
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

  void _showWarehouseDialog({
    required String title,
    String? name,
    String? location,
    required Function(String name, String location) onSubmit,
  }) {
    if (name != null) _nameController.text = name;
    if (location != null) _locationController.text = location;

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Warehouse Name',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _locationController,
                placeholder: 'Location',
              ),
            ],
          ),
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
                if (_nameController.text.isNotEmpty &&
                    _locationController.text.isNotEmpty) {
                  onSubmit(_nameController.text, _locationController.text);
                  _nameController.clear();
                  _locationController.clear();
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
            Expanded(
              child: _filteredWarehouses.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredWarehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = _filteredWarehouses[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(Icons.location_on,
                                size: 40, color: Colors.blue),
                            title: Text(warehouse.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(warehouse.location),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editWarehouse(index),
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteWarehouse(index),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
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
