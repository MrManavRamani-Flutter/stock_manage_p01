import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/views/employee_views/employee_detail_view.dart';
import 'package:stock_manage/widgets/custom_sidebar.dart';

class EmployeeView extends StatelessWidget {
  const EmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Employees',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.primaryColor),
            label: const Text(
              'Add',
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
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search employees...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
                onChanged: (value) {
                  // Handle search functionality
                },
              ),
            ),
            const SizedBox(height: 16),

            // Employee List
            Expanded(
              child: ListView.builder(
                itemCount: Global
                    .employees.length, // Replace with your list of employees
                itemBuilder: (context, index) {
                  final employee = Global.employees[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(employee.imageUrl), // Employee image
                      ),
                      title: Text(employee.name), // Employee name
                      subtitle: Text(employee.role), // Employee role
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EmployeeDetailView(employee: employee),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
