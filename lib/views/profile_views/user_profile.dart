import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/utils/global.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      // drawer: const Sidebar(), // Assuming Sidebar is defined elsewhere
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Login Information
            Row(
              children: [
                _buildUserImage(),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username', // Replace with actual username
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('Role: User Role'),
                      // Replace with actual role
                      Text('Email: user@example.com'),
                      // Replace with actual email
                      Text('Contact: +1234567890'),
                      // Replace with actual contact
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Implement edit profile functionality
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 30),
            // Statistics Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.7,
                children: [
                  _buildStatCard(
                      'Employees Count', Global.employees.length.toString()),
                  _buildStatCard(
                      'Warehouse Count', Global.warehouses.length.toString()),
                  _buildStatCard(
                      'Product Count', Global.products.length.toString()),
                  _buildStatCard(
                      'Order Count', Global.orders.length.toString()),
                  _buildStatCard(
                      'Client Count', Global.clients.length.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(2, 2),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/img/users/user_1.png'),
          // Replace with your image
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: Text(
          'U', // Placeholder character or symbol for missing images
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
