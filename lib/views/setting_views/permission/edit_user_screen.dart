import 'package:flutter/material.dart';
import 'package:stock_manage/models/user_model.dart';
import 'package:stock_manage/utils/global.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  EditUserScreenState createState() => EditUserScreenState();
}

class EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _passwordController;
  late String _role;
  late int _status;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.user.password);
    _role = widget.user.role;
    _status = widget.user.status;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    User updatedUser = User(
      uId: widget.user.uId,
      username: widget.user.username,
      email: widget.user.email,
      password: _passwordController.text,
      phone: widget.user.phone,
      role: _role,
      status: _status,
      createdAt: widget.user.createdAt,
    );

    int index = Global.users.indexWhere((user) => user.uId == updatedUser.uId);
    if (index != -1) {
      Global.users[index] = updatedUser;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update User Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildRoleDropdown(),
              const SizedBox(height: 16),
              _buildStatusDropdown(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full width button
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      obscureText: true,
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _role,
      decoration: InputDecoration(
        labelText: 'User Role',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: ['owner', 'admin', 'guest'].map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _role = value;
          });
        }
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<int>(
      value: _status,
      decoration: InputDecoration(
        labelText: 'User Status',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: const [
        DropdownMenuItem(value: 0, child: Text('Not Logged In')),
        DropdownMenuItem(value: 1, child: Text('Logged In')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _status = value;
          });
        }
      },
    );
  }
}
