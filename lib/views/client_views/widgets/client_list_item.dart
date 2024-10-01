import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stock_manage/models/client_model.dart';

class ClientListItem extends StatelessWidget {
  final Client client;
  final VoidCallback onTap;

  const ClientListItem({
    super.key,
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: _buildAvatar(),
        title: Text(client.clientName),
        subtitle: Text(client.email),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundImage: _getImageProvider(),
    );
  }

  ImageProvider<Object> _getImageProvider() {
    if (client.imageUrl != null &&
        client.imageUrl!.isNotEmpty &&
        File(client.imageUrl!).existsSync()) {
      return FileImage(File(client.imageUrl!)); // Show file image
    } else {
      return const AssetImage(
          'assets/img/users/user_1.png'); // Default asset image
    }
  }
}
