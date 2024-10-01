import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stock_manage/models/client_model.dart';

class ClientInfoCard extends StatelessWidget {
  final Client client;

  const ClientInfoCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Client Image
            CircleAvatar(
              radius: 40,
              backgroundImage: _getImageProvider(client.imageUrl),
            ),
            const SizedBox(width: 20),
            // Client Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${client.clientName}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Shop: ${client.shopAddress ?? 'N/A'}"),
                  const SizedBox(height: 8),
                  Text("Email: ${client.email}"),
                  const SizedBox(height: 8),
                  Text(
                      "Contact: ${client.contact ?? 'N/A'}"), // Added null check for contact
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the image provider based on the image URL
  ImageProvider<Object> _getImageProvider(String? imageUrl) {
    // Check if the imageUrl is a valid file path
    if (imageUrl != null && File(imageUrl).existsSync()) {
      return FileImage(File(imageUrl)); // Show file image
    } else {
      return const AssetImage(
          'assets/img/users/user_1.png'); // Default asset image
    }
  }
}
