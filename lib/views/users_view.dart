import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/user_card.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Users',
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16.0),
        //     child: Icon(Icons.notifications),
        //   ),
        // ],
        buttonText: '', onButtonPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Add User Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.gray),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to add user screen
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add User',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Users List
            Expanded(
              child: ListView(
                children: const [
                  UserCard(
                    userName: 'Alma Mambery',
                    email: 'alma.mambery@example.com',
                    imageUrl: './assets/img/users/user_1.png',
                  ),
                  UserCard(
                    userName: 'Elisa Moraes',
                    email: 'elisa.moraes@example.com',
                    imageUrl: './assets/img/users/user_1.png',
                  ),
                  UserCard(
                    userName: 'Hugo Saavedra',
                    email: 'hugo.saavedra@example.com',
                    imageUrl: './assets/img/users/user_1.png',
                  ),
                  UserCard(
                    userName: 'Ivan Coripe',
                    email: 'ivan.coripe@example.com',
                    imageUrl: './assets/img/users/user_1.png',
                  ),
                  UserCard(
                    userName: 'Fatima Delgadio',
                    email: 'fatima.delgadio@example.com',
                    imageUrl: './assets/img/users/user_1.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
