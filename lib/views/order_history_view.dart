import 'dart:async'; // Import for Timer

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
  final TextEditingController _statusController = TextEditingController();
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

  // Method called whenever search text changes
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterOrders(_searchController.text);
    });
  }

  // Filter orders based on search input
  void _filterOrders(String query) {
    setState(() {
      filteredOrders = Global.orders
          .where((order) =>
              order.orderID.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addOrder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _orderIDController,
                decoration: const InputDecoration(labelText: 'Order ID'),
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
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
                  final newOrder = Order(
                    orderID: _orderIDController.text,
                    status: _statusController.text,
                    date: _dateController.text,
                  );
                  Global.orders.add(newOrder);
                  _orderIDController.clear();
                  _statusController.clear();
                  _dateController.clear();
                  _filterOrders(''); // Refresh the filtered list
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
    _orderIDController.dispose();
    _statusController.dispose();
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

  const OrderCard({
    super.key,
    required this.orderID,
    required this.status,
    required this.date,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderID',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: $status', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Date: $date', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
