import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_manage/models/client_model.dart';

import '../../utils/global.dart';

class EditClientView extends StatefulWidget {
  final Client client;
  final Function(Client) onClientUpdated; // Add this line

  const EditClientView(
      {super.key,
      required this.client,
      required this.onClientUpdated}); // Update constructor

  @override
  EditClientViewState createState() => EditClientViewState();
}

class EditClientViewState extends State<EditClientView> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _selectedImage = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _clientNameController.text = widget.client.clientName;
    _emailController.text = widget.client.email;
    _shopAddressController.text = widget.client.shopAddress ?? '';
    _contactController.text = widget.client.contact;
    _selectedImage = widget.client.imageUrl ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image.path; // Update the selected image path
      });
    }
  }

  void _saveChanges() {
    // Validate the fields before updating
    if (_clientNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a client name')),
      );
      return;
    }

    // Update the client details
    Client updatedClient = Client(
      id: widget.client.id,
      clientName: _clientNameController.text,
      email: _emailController.text,
      contact: _contactController.text,
      imageUrl:
          _selectedImage.isNotEmpty ? _selectedImage : widget.client.imageUrl,
      shopAddress: _shopAddressController.text,
    );

    // Find and replace the existing client in the global list
    int index =
        Global.clients.indexWhere((client) => client.id == widget.client.id);
    if (index != -1) {
      Global.clients[index] = updatedClient;
    }

    widget.onClientUpdated(updatedClient); // Notify parent about the update

    Navigator.of(context).pop(); // Close the edit screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _clientNameController,
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a client name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shopAddressController,
                  decoration: const InputDecoration(labelText: 'Shop Address'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
                const SizedBox(height: 12),
                _selectedImage.isNotEmpty
                    ? Image.file(File(_selectedImage),
                        height: 100) // Display selected image
                    : const SizedBox(
                        height: 100), // Placeholder for image if none selected
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
