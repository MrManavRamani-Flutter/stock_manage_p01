import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stock_manage/utils/global.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildGraphSection(),
            const SizedBox(height: 20),
            _buildDetailedSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to the Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "Overview of your stock management",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard("Employees", Global.employees.length),
        _buildStatCard("Warehouses", Global.warehouses.length),
        _buildStatCard("Orders", Global.orders.length),
        _buildStatCard("Clients", Global.clients.length),
        _buildStatCard("Products", Global.products.length),
      ],
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(count.toString(), style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sales Over Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 3),
                    const FlSpot(1, 4),
                    const FlSpot(2, 2),
                    const FlSpot(3, 5),
                  ],
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmployeeSection(),
        _buildWarehouseSection(),
        _buildOrderSection(),
        _buildClientSection(),
        _buildProductSection(),
        _buildPurchaseSection(),
      ],
    );
  }

  Widget _buildEmployeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Employees",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.employees.map((employee) => ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(employee.imageUrl)),
              title: Text(employee.name),
              subtitle: Text('${employee.role} | ${employee.email}'),
              trailing: Column(
                children: [
                  Text("Present: ${employee.presentCount}"),
                  Text(
                      "Absent: ${employee.absentWithLeaveCount + employee.absentWithoutLeaveCount}"),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildWarehouseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Warehouses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.warehouses.map((warehouse) => ListTile(
              title: Text(warehouse.name),
              subtitle: Text("Location: ${warehouse.location}"),
              trailing: Text("Categories: ${warehouse.categories.length}"),
            )),
      ],
    );
  }

  Widget _buildOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.orders.map((order) => ListTile(
              title: Text("Order ID: ${order.orderID}"),
              subtitle: Text("Status: ${order.status}"),
              trailing: Text("Date: ${order.date}"),
            )),
      ],
    );
  }

  Widget _buildClientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Clients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.clients.map((client) => ListTile(
              leading: client.imageUrl!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(client.imageUrl!))
                  : CircleAvatar(child: Text(client.clientName[0])),
              title: Text(client.clientName),
              subtitle: Text(client.email),
              trailing: Text("Contact: ${client.contact}"),
            )),
      ],
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.products.map((product) => ListTile(
              title: Text(product.name),
              subtitle: Text(
                  "Price: \$${product.price.toStringAsFixed(2)} | Stock: ${product.stock}"),
              trailing: Text("Warning Stock: ${product.wornLimitStock}"),
            )),
      ],
    );
  }

  Widget _buildPurchaseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Purchases",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...Global.purchases.map((purchase) => ListTile(
              title: Text("Purchase ID: ${purchase.purchaseId}"),
              subtitle:
                  Text("Total: \$${purchase.totalAmount.toStringAsFixed(2)}"),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Paid: \$${purchase.totalPayment.toStringAsFixed(2)}"),
                  Text(
                      "Pending: \$${purchase.pendingPayment.toStringAsFixed(2)}"),
                ],
              ),
            )),
      ],
    );
  }
}
