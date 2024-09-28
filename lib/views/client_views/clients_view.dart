import 'package:flutter/material.dart';
import 'package:stock_manage/views/client_views/client_details.dart';
import 'package:stock_manage/views/client_views/widgets/client_form.dart';
import 'package:stock_manage/views/client_views/widgets/client_list_item.dart';

import '../../constants/app_colors.dart';
import '../../models/client_model.dart';
import '../../utils/global.dart';
import '../../widgets/custom_sidebar.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  List<Client> filteredClients = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredClients = List.from(
        Global.clients); // Initialize with a copy of the original list
  }

  void _filterClients(String query) {
    setState(() {
      _searchQuery = query;
      filteredClients = Global.clients.where((client) {
        final matchesName =
            client.clientName.toLowerCase().contains(query.toLowerCase());
        final matchesEmail =
            client.email.toLowerCase().contains(query.toLowerCase());
        return matchesName || matchesEmail;
      }).toList();
    });
  }

  void _addClient(Client client) {
    Global.clients.add(client);
    _filterClients(''); // Reset filter after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Clients',
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Client'),
                    content: ClientForm(onSubmit: _addClient),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Clients...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
                onChanged: _filterClients,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  final client = filteredClients[index];
                  return ClientListItem(
                    client: client,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => ClientDetails(client: client),
                      ))
                          .then((value) {
                        // Refresh the clients list after coming back from ClientDetails
                        setState(() {
                          filteredClients = List.from(Global.clients);
                        });
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
