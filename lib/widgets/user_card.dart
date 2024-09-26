import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ClientCard extends StatelessWidget {
  final String clientName;
  final String email;
  final String imageUrl;

  const ClientCard({
    super.key,
    required this.clientName,
    required this.email,
    this.imageUrl = './assets/img/users/user_1.png',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: _getImageProvider(imageUrl),
        ),
        title: Text(
          clientName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(
            color: AppColors.gray,
          ),
        ),
        onTap: () {
          // Navigate to user details page
        },
      ),
    );
  }

  // Determine the correct ImageProvider based on file path or asset path
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty || !File(imageUrl).existsSync()) {
      return const AssetImage(
          './assets/img/users/user_1.png'); // Default asset image
    } else {
      return FileImage(File(imageUrl)); // Load file image
    }
  }
}
