import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stock_manage/models/client_model.dart';

class ClientListItem extends StatelessWidget {
  final Client client;
  final Function() onTap;

  const ClientListItem({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: client.imageUrl != ''
            ? CircleAvatar(
                backgroundImage: FileImage(File(client.imageUrl!)),
              )
            : const CircleAvatar(
                backgroundImage: AssetImage('assets/img/users/user_1.png'),
              ),
        title: Text(client.clientName),
        subtitle: Text(client.email),
        onTap: onTap,
      ),
    );
  }
}
