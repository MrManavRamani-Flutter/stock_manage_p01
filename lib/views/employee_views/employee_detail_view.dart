import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/views/employee_views/employee_edit_view.dart';

class EmployeeDetailView extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailView({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(employee.name,
            style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final updatedEmployee = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditEmployeeView(employee: employee),
                ),
              );

              if (updatedEmployee != null) {
                Navigator.of(context)
                    .pop(updatedEmployee); // Return updated employee
              }
            },
            icon: const Icon(Icons.edit, color: AppColors.primaryColor),
            label: const Text('Edit',
                style: TextStyle(color: AppColors.primaryColor)),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(100),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Center(
                child: Text(employee.name,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87))),
            const SizedBox(height: 8),
            Center(
                child: Text(employee.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey))),
            const SizedBox(height: 8),
            Center(
                child: Text(employee.contactNumber,
                    style: const TextStyle(fontSize: 16, color: Colors.grey))),
            const SizedBox(height: 24),
            Column(
              children: [
                _buildFullWidthCountColumn(
                    'Present', employee.presentCount, Colors.green.shade100),
                const SizedBox(height: 16),
                _buildFullWidthCountColumn('Leave (With)',
                    employee.absentWithLeaveCount, Colors.orange.shade100),
                const SizedBox(height: 16),
                _buildFullWidthCountColumn('Leave (Without)',
                    employee.absentWithoutLeaveCount, Colors.red.shade100),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthCountColumn(
      String label, int count, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(count.toString(),
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
