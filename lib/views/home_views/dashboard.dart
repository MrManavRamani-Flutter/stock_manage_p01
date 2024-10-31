import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/sales_data_model.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/widgets/custom_sidebar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedYear = DateTime.now().year;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    years = _getYears();
    if (!years.contains(selectedYear)) {
      selectedYear = years.isNotEmpty ? years.last : DateTime.now().year;
    }
  }

  List<int> _getYears() {
    final uniqueYears =
        Global.purchases.map((purchase) => purchase.createdAt.year).toSet();
    return uniqueYears.toList()..sort();
  }

  List<SalesData> getMonthlySalesData() {
    Map<int, double> monthlySales = {};
    for (var purchase in Global.purchases) {
      if (purchase.createdAt.year == selectedYear) {
        final month = purchase.createdAt.month;
        monthlySales[month] = (monthlySales[month] ?? 0) + purchase.totalAmount;
      }
    }

    if (monthlySales.isEmpty) {
      return List.generate(12, (index) => SalesData((index + 1).toDouble(), 0));
    }

    return monthlySales.entries
        .map((entry) => SalesData(entry.key.toDouble(), entry.value))
        .toList();
  }

  Widget _buildGraphSection() {
    final salesData = getMonthlySalesData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sales Over Time",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildYearDropdown(),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(text: 'Month'),
              interval: 1,
              labelFormat: '{value}',
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Sales Amount'),
              labelFormat: '{value}\$',
            ),
            series: <ChartSeries>[
              LineSeries<SalesData, double>(
                dataSource: salesData,
                xValueMapper: (SalesData sales, _) => sales.time,
                yValueMapper: (SalesData sales, _) => sales.sales,
                color: Colors.blue,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x: point.y\$',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButton<int>(
      value: selectedYear,
      onChanged: (newYear) {
        setState(() {
          selectedYear = newYear!;
        });
      },
      items: years.map((year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: _buildAppBar(),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: const Text(
        "Dashboard",
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
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
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
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
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(count.toString(), style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
            "Employees",
            Global.employees.map((employee) => ListTile(
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
                ))),
        _buildSection(
            "Warehouses",
            Global.warehouses.map((warehouse) => ListTile(
                  title: Text(warehouse.name),
                  subtitle: Text("Location: ${warehouse.location}"),
                  trailing: Text("Categories: ${warehouse.categories.length}"),
                ))),
        _buildSection(
            "Orders",
            Global.orders.map((order) => ListTile(
                  title: Text("Order ID: ${order.orderID}"),
                  subtitle: Text("Status: ${order.status}"),
                  trailing: Text("Date: ${order.date}"),
                ))),
        _buildSection(
            "Clients",
            Global.clients.map((client) => ListTile(
                  leading: client.imageUrl!.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(client.imageUrl!))
                      : CircleAvatar(child: Text(client.clientName[0])),
                  title: Text(client.clientName),
                  subtitle: Text(client.email),
                  trailing: Text("Contact: ${client.contact}"),
                ))),
        _buildSection(
            "Products",
            Global.products.map((product) => ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      "Stock: ${product.stock} | Price: \$${product.price}"),
                  trailing: Text("Category: ${product.categoryId}"),
                ))),
        _buildSection(
            "Purchases",
            Global.purchases.map((purchase) => ListTile(
                  title: Text("Purchase ID: ${purchase.purchaseId}"),
                  subtitle: Text(
                      "Client ID: ${purchase.clientId} | Product ID: ${purchase.productId}"),
                  trailing: Text(
                      "Pending: \$${purchase.pendingPayment} / Total: \$${purchase.totalAmount}"),
                ))),
      ],
    );
  }

  Widget _buildSection(String title, Iterable<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items,
        const SizedBox(height: 20),
      ],
    );
  }
}
