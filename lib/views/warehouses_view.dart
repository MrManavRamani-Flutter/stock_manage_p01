import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_sidebar.dart';

class WarehousesView extends StatelessWidget {
  const WarehousesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Warehouses',
        buttonText: '',
        onButtonPressed: () {},
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Replace with ListView for dynamic data
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Warehouse 1'),
                    subtitle: Text('Dallas, TX'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Warehouse 2'),
                    subtitle: Text('Chicago, IL'),
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
