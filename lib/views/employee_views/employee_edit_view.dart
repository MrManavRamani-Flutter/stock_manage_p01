import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/utils/global.dart';

class EditEmployeeView extends StatefulWidget {
  final Employee employee;

  const EditEmployeeView({super.key, required this.employee});

  @override
  EditEmployeeViewState createState() => EditEmployeeViewState();
}

class EditEmployeeViewState extends State<EditEmployeeView> {
  late final TextEditingController nameController;
  late final TextEditingController roleController;
  late final TextEditingController emailController;
  late final TextEditingController contactNumberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    roleController = TextEditingController(text: widget.employee.role);
    emailController = TextEditingController(text: widget.employee.email);
    contactNumberController =
        TextEditingController(text: widget.employee.contactNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  void saveChanges() {
    widget.employee.name = nameController.text;
    widget.employee.role = roleController.text;
    widget.employee.email = emailController.text;
    widget.employee.contactNumber = contactNumberController.text;

    // Update the global employee list
    final index =
        Global.employees.indexWhere((emp) => emp.id == widget.employee.id);
    if (index != -1) {
      Global.employees[index] = widget.employee;
    }

    // Show snackbar for feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee details updated!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop(widget.employee); // Return updated employee
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Edit Employee',
            style: TextStyle(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          TextButton(
            onPressed: saveChanges,
            child: const Text('Save',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(nameController, 'Name', Icons.person),
            _buildTextField(roleController, 'Role', Icons.work),
            _buildTextField(emailController, 'Email', Icons.email),
            _buildTextField(
                contactNumberController, 'Contact Number', Icons.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }
}
