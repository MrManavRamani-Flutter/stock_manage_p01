import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/employee_model.dart';

class EmployeeDetailView extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailView({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          employee.name,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // Handle edit functionality
            },
            icon: const Icon(Icons.edit, color: AppColors.primaryColor),
            label: const Text(
              'Edit',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(employee.imageUrl),
              ),
            ),
            const SizedBox(height: 16),

            // Employee Name
            Center(
              child: Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Employee Email
            Center(
              child: Text(
                employee.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Employee Contact Number
            Center(
              child: Text(
                employee.contactNumber,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Counts Section - Present, Absent with Leave, Absent without Leave
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

  // Helper widget for displaying the count sections with background color and full width
  Widget _buildFullWidthCountColumn(
      String label, int count, Color backgroundColor) {
    return Container(
      width: double.infinity, // Takes full width
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
