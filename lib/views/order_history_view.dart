import 'dart:async'; // Import for Timer

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../utils/global.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  OrderHistoryViewState createState() => OrderHistoryViewState();
}

class OrderHistoryViewState extends State<OrderHistoryView> {
  final TextEditingController _orderIDController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Order> filteredOrders = [];
  Timer? _debounce; // Timer for debouncing search input

  @override
  void initState() {
    super.initState();
    filteredOrders = Global.orders;
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterOrders(_searchController.text);
    });
  }

  void _filterOrders(String query) {
    setState(() {
      filteredOrders = Global.orders
          .where((order) =>
              order.orderID.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addOrder() {
    _showOrderDialog(
      title: 'Add Order',
      onSubmit: (orderID, status, date) {
        setState(() {
          final newOrder = Order(
            orderID: orderID,
            status: status,
            date: date,
          );
          Global.orders.add(newOrder);
          _filterOrders(''); // Refresh the filtered list
        });
      },
    );
  }

  void _editOrder(int index) {
    final order = filteredOrders[index];
    _showOrderDialog(
      title: 'Edit Order',
      orderID: order.orderID,
      status: order.status,
      date: order.date,
      onSubmit: (orderID, status, date) {
        setState(() {
          Global.orders[Global.orders.indexOf(order)] = Order(
            orderID: orderID,
            status: status,
            date: date,
          );
          _filterOrders(''); // Refresh the filtered list
        });
      },
    );
  }

  void _deleteOrder(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Order'),
          content: const Text('Are you sure you want to delete this order?'),
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
                  Global.orders.removeAt(index);
                  _filterOrders(''); // Refresh the filtered list
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

  void _showOrderDialog({
    required String title,
    String? orderID,
    String? status,
    String? date,
    required Function(String orderID, String status, String date) onSubmit,
  }) {
    // Set initial values for text fields
    _orderIDController.text = orderID ?? '';
    _dateController.text = date ?? '';

    // Validate and use the status parameter to set selectedStatus, otherwise use the first status from the list
    String? selectedStatus =
        orderStatusList.contains(status) ? status : orderStatusList.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _orderIDController,
                      decoration: const InputDecoration(hintText: 'Order ID'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedStatus,
                      isExpanded: true,
                      hint: const Text('Select Status'),
                      items: orderStatusList.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(hintText: 'Date'),
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _dateController.text =
                              '${selectedDate.toLocal()}'.split(' ')[0];
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _orderIDController.clear();
                    _dateController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_orderIDController.text.isNotEmpty &&
                        selectedStatus != null &&
                        _dateController.text.isNotEmpty) {
                      onSubmit(
                        _orderIDController.text,
                        selectedStatus!,
                        _dateController.text,
                      );
                      _orderIDController.clear();
                      _dateController.clear();
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter all fields')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _orderIDController.dispose();
    _dateController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel(); // Dispose the debounce timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order History',
        buttonText: 'Add',
        onButtonPressed: _addOrder,
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
                  hintText: 'Search Orders...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // List of orders
            Expanded(
              child: filteredOrders.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return OrderCard(
                          orderID: order.orderID,
                          status: order.status,
                          date: order.date,
                          onEdit: () => _editOrder(index),
                          onDelete: () => _deleteOrder(index),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No orders found'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final String orderID;
  final String status;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OrderCard({
    super.key,
    required this.orderID,
    required this.status,
    required this.date,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: $orderID',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Status: $status'),
                const SizedBox(height: 4),
                Text('Date: $date'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.gray),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// List of order statuses
const List<String> orderStatusList = [
  'Pending',
  'Processing',
  'Shipped',
  'Delivered',
  'Cancelled',
  'Returned',
];
