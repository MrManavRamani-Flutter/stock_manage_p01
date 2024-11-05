import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/views/employee_views/employee_detail_view.dart';
import 'package:stock_manage/widgets/custom_sidebar.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  EmployeeViewState createState() => EmployeeViewState();
}

class EmployeeViewState extends State<EmployeeView> {
  List<Employee> filteredEmployees =
      Global.employees; // Start with all employees
  final TextEditingController searchController = TextEditingController();

  // Function to filter employees based on search query
  void searchEmployee(String query) {
    setState(() {
      filteredEmployees = query.isEmpty
          ? Global.employees // Show all employees if query is empty
          : Global.employees
              .where((employee) =>
                  employee.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  // Function to add a new employee
  void addEmployee(Employee newEmployee) {
    setState(() {
      Global.employees.add(newEmployee); // Update global employee list
      filteredEmployees = Global.employees; // Refresh filtered list
    });
  }

  // Function to generate a unique Employee ID
  String generateEmployeeId() {
    return 'EMP${Global.employees.length + 1}'; // Simple ID generation
  }

  // Function to display the dialog for adding a new employee
  void showAddEmployeeDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, 'Employee Name'),
                _buildTextField(roleController, 'Role'),
                _buildTextField(emailController, 'Email'),
                _buildTextField(contactController, 'Contact Number'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call addEmployee with the input values and generate ID
                addEmployee(Employee(
                  id: generateEmployeeId(), // Set ID automatically
                  name: nameController.text,
                  role: roleController.text,
                  email: emailController.text,
                  contactNumber: contactController.text,
                ));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to build a TextField
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
    );
  }

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
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed:
                showAddEmployeeDialog, // Show dialog for adding a new employee
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildEmployeeList(),
          ],
        ),
      ),
    );
  }

  // Helper function to build the search field
  Widget _buildSearchField() {
    return Container(
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search employees...',
          prefixIcon: const Icon(Icons.search, color: AppColors.gray),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gray),
          ),
        ),
        onChanged: searchEmployee, // Call search function on change
      ),
    );
  }

  // Helper function to build the employee list
  Widget _buildEmployeeList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredEmployees.length, // Use filtered list
        itemBuilder: (context, index) {
          final employee = filteredEmployees[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(employee.name), // Employee name
              subtitle: Text(employee.role), // Employee role
              onTap: () async {
                // Navigate to the employee detail view
                final updatedEmployee = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EmployeeDetailView(employee: employee),
                  ),
                );

                if (updatedEmployee != null) {
                  setState(() {
                    // Refresh the employee list after edit
                    filteredEmployees = Global.employees;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
