import 'package:flutter/material.dart';
import 'package:stock_manage/views/setting_views/permission/user_per_view.dart';
import 'package:stock_manage/views/user_auth/login_view.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false; // Track theme state

  // Method to toggle theme
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              _buildCard(
                title: 'Theme',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dark Theme', style: TextStyle(fontSize: 16)),
                    Switch(
                      value: _isDarkTheme,
                      onChanged: (value) => _toggleTheme(),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),

              // User Permissions Section
              _buildCard(
                title: 'User Permissions',
                child: ListTile(
                  title: const Text('User List'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPermissionsScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Additional Options Section
              _buildCard(
                title: 'Additional Options',
                child: Column(
                  children: [
                    _buildListTile('Terms and Conditions', () {
                      // Navigate to Terms and Conditions page
                    }),
                    _buildListTile('Privacy Policy', () {
                      // Navigate to Privacy Policy page
                    }),
                    _buildListTile('Contact Support', () {
                      // Navigate to Contact Support page
                    }),
                    const Divider(),
                    _buildListTile('Logout', () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      // Handle logout functionality
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
