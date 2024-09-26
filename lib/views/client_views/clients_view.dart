import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_manage/views/client_views/client_details.dart';

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
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String _selectedImage = ''; // Store selected image path
  List<Client> filteredClients = [];

  @override
  void initState() {
    super.initState();
    filteredClients = Global.clients; // Initialize with global clients
  }

  // Filter clients based on search input
  void _filterClients(String query) {
    setState(() {
      filteredClients = Global.clients
          .where((client) =>
              client.clientName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final file =
                      await picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final file =
                      await picker.pickImage(source: ImageSource.camera);
                  Navigator.of(context).pop(file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      // Check if the file exists
      final file = File(pickedFile.path);
      if (await file.exists()) {
        setState(() {
          _selectedImage = pickedFile.path;
        });
      } else {
        // Handle the case where the file doesn't exist
        print('Image file does not exist: ${pickedFile.path}');
        // Optionally, show a message to the user
      }
    }
  }

  void _addClient() {
    // Clear previous data
    _clearControllers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Client',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: _clientForm(),
          actions: _dialogActions(onSubmit: () {
            final newClient = Client(
              clientName: _clientNameController.text,
              email: _emailController.text,
              imageUrl: _selectedImage.isNotEmpty
                  ? _selectedImage
                  : './assets/img/clients/client_1.png',
              shopAddress: _shopAddressController.text,
            );
            Global.clients.add(newClient);
            _filterClients('');
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  Widget _clientForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _textField(_clientNameController, 'Client Name', true),
            const SizedBox(height: 12),
            _textField(_emailController, 'Email', true),
            const SizedBox(height: 12),
            _textField(_shopAddressController, 'Shop Address'),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _pickImage, child: const Text('Pick Image')),
            const SizedBox(height: 12),
            _imagePreview(),
          ],
        ),
      ),
    );
  }

  List<Widget> _dialogActions({required VoidCallback onSubmit}) {
    return [
      TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel')),
      ElevatedButton(onPressed: onSubmit, child: const Text('Add')),
    ];
  }

  void _clearControllers() {
    _clientNameController.clear();
    _emailController.clear();
    _shopAddressController.clear();
    _selectedImage = '';
  }

  TextFormField _textField(TextEditingController controller, String label,
      [bool isRequired = false, TextInputType? inputType]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _imagePreview() {
    return _selectedImage.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(_selectedImage),
                height: 100, width: 100, fit: BoxFit.cover),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('./assets/img/users/user_1.png',
                height: 100, width: 100, fit: BoxFit.cover),
          );
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
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.primaryColor),
            label: const Text(
              'Add',
              style: TextStyle(color: AppColors.primaryColor),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(100),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
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
                onChanged: (query) => _filterClients(query),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredClients.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ClientDetails(),
                                  ));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: _selectedImage.isNotEmpty
                                      ? FileImage(File(client.imageUrl))
                                      : const AssetImage(
                                          './assets/img/users/user_1.png',
                                        ),
                                ),
                                title: Text(client.clientName),
                                subtitle: Text(client.email),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No Clients found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
