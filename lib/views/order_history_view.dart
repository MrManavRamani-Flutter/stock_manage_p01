import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  OrderHistoryViewState createState() => OrderHistoryViewState();
}

class OrderHistoryViewState extends State<OrderHistoryView> {
  // Mock data for orders
  List<Map<String, String>> orders = [
    {"orderID": "DS50-790", "status": "Complete", "date": "April 20, 2023"},
    {"orderID": "ERO-COMP", "status": "Pending", "date": "April 18, 2023"},
    {"orderID": "3DPI-981", "status": "Shipped", "date": "April 16, 2023"},
    {"orderID": "ERO-WG2", "status": "Cancelled", "date": "April 15, 2023"},
    // Add more orders here...
  ];

  List<Map<String, String>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    // Initially, display all orders
    filteredOrders = orders;
  }

  // Filter the list based on search input
  void _filterOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order['orderID']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order History',
        buttonText: '',
        onButtonPressed: () {},
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) => _filterOrders(value),
              decoration: InputDecoration(
                hintText: 'Search Orders...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray),
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
                          orderID: order['orderID']!,
                          status: order['status']!,
                          date: order['date']!,
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
