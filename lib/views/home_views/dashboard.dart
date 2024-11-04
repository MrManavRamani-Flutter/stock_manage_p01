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
  int? selectedYear;
  int? selectedMonth;
  List<int> years = [];
  List<int> months = List.generate(12, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    years = _getYears();
  }

  List<int> _getYears() {
    final uniqueYears =
        Global.purchases.map((purchase) => purchase.createdAt.year).toSet();
    return uniqueYears.toList()..sort();
  }

  List<SalesData> getFilteredSalesData() {
    Map<double, double> filteredSales = {}; // Use double as key type

    for (var purchase in Global.purchases) {
      bool yearMatches =
          selectedYear == null || purchase.createdAt.year == selectedYear;
      bool monthMatches =
          selectedMonth == null || purchase.createdAt.month == selectedMonth;

      if (yearMatches && monthMatches) {
        double timeKey; // Change type to double

        // Determine data grouping based on filter selection
        if (selectedMonth != null) {
          // Month selected, show day-wise data
          timeKey = purchase.createdAt.day.toDouble(); // Use day as double
        } else if (selectedYear != null) {
          // Year selected, show month-wise data
          timeKey = purchase.createdAt.month.toDouble(); // Use month as double
        } else {
          // Default to year-wise if all selected
          timeKey = purchase.createdAt.year.toDouble(); // Use year as double
        }

        filteredSales[timeKey] =
            (filteredSales[timeKey] ?? 0) + purchase.totalAmount;
      }
    }

    // Sort the filtered sales data based on timeKey
    var sortedSales = filteredSales.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Return the processed sales data
    return sortedSales
        .map((entry) => SalesData(
            entry.key, entry.value)) // This line maps to SalesData objects
        .toList();
  }

  Widget _buildGraphSection() {
    final salesData = getFilteredSalesData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sales Over Time",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildFilterSection(),
        const SizedBox(height: 10),
        if (salesData.isEmpty)
          Center(
            child: Text(
              'No sales data available for the selected filters.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        AspectRatio(
          aspectRatio: 1.5,
          child: SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(
                text: selectedMonth != null
                    ? 'Days'
                    : 'Months', // Update label based on selection
              ),
              interval: 1,
              labelFormat: '{value}',
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Sales Amount'),
              labelFormat: '{value} Rs.',
            ),
            series: <ChartSeries>[
              LineSeries<SalesData, double>(
                // Change the xValueMapper type to double
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
              format: 'point.x: point.y Rs.',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDropdown(
          label: 'Year',
          value: selectedYear,
          items: years,
          onChanged: (int? newYear) {
            setState(() {
              selectedYear = newYear;
              selectedMonth = null; // Reset month when year changes
            });
          },
        ),
        _buildDropdown(
          label: 'Month',
          value: selectedMonth,
          items: months,
          onChanged: (int? newMonth) {
            setState(() {
              selectedMonth = newMonth;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        DropdownButton<int>(
          value: value,
          onChanged: onChanged,
          items: [null, ...items].map((item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Text(item == null ? 'All' : item.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildGraphSection(),
            const SizedBox(height: 20),
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
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to the Dashboard",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Overview of your stock management",
          style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
