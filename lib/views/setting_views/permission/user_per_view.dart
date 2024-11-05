import 'package:flutter/material.dart';
import 'package:stock_manage/models/user_model.dart';
import 'package:stock_manage/utils/global.dart';

import 'edit_user_screen.dart'; // Import the edit screen

class UserPermissionsScreen extends StatefulWidget {
  const UserPermissionsScreen({super.key});

  @override
  State<UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  // Method to refresh user data
  void _refreshUserData() {
    setState(() {
      // Assume Global.users is updated elsewhere when editing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Permissions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Global.users.length,
                itemBuilder: (context, index) {
                  User user = Global.users[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor:
                            Colors.grey[300], // Background color for the avatar
                        child: Text(
                          user.username.isNotEmpty
                              ? user.username[0].toUpperCase()
                              : '?', // First letter of username or '?' if empty
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black), // Customize text style
                        ),
                      ),
                      title: Text(
                        user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Role: ${user.role}'),
                          Text(
                              'Status: ${user.status == 1 ? 'Logged In' : 'Not Logged In'}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final shouldRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );

                          if (shouldRefresh == true) {
                            _refreshUserData(); // Refresh when returning from edit screen
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
