import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_manage/models/client_model.dart';

import '../../utils/global.dart';

class EditClientView extends StatefulWidget {
  final Client client;
  final Function(Client) onClientUpdated;

  const EditClientView({
    Key? key,
    required this.client,
    required this.onClientUpdated,
  }) : super(key: key);

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
    _initializeFields();
  }

  // Initialize text fields with existing client data
  void _initializeFields() {
    _clientNameController.text = widget.client.clientName;
    _emailController.text = widget.client.email;
    _shopAddressController.text = widget.client.shopAddress ?? '';
    _contactController.text = widget.client.contact;
    _selectedImage = widget.client.imageUrl ?? '';
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image.path; // Store the picked image path
      });
    }
  }

  // Save the changes made to the client
  void _saveChanges() {
    if (_clientNameController.text.isEmpty) {
      _showSnackbar('Please enter a client name');
      return;
    }

    final updatedClient = Client(
      id: widget.client.id,
      clientName: _clientNameController.text,
      email: _emailController.text,
      contact: _contactController.text,
      imageUrl:
          _selectedImage.isNotEmpty ? _selectedImage : widget.client.imageUrl,
      shopAddress: _shopAddressController.text,
    );

    _updateClientInGlobalList(updatedClient);
    widget.onClientUpdated(updatedClient);
    Navigator.of(context).pop(); // Close the view
  }

  // Update the client in the global list
  void _updateClientInGlobalList(Client updatedClient) {
    final index =
        Global.clients.indexWhere((client) => client.id == widget.client.id);
    if (index != -1) {
      Global.clients[index] =
          updatedClient; // Replace the old client with the updated one
    }
  }

  // Show a snackbar with the provided message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_clientNameController, 'Client Name',
                    'Please enter a client name'),
                const SizedBox(height: 12),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 12),
                _buildTextField(_shopAddressController, 'Shop Address'),
                const SizedBox(height: 12),
                _buildTextField(_contactController, 'Contact'),
                const SizedBox(height: 12),
                _buildImagePreview(),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a text field with validation message if needed
  Widget _buildTextField(TextEditingController controller, String label,
      [String? errorMessage]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        errorText: errorMessage != null && controller.text.isEmpty
            ? errorMessage
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  // Preview the selected image
  Widget _buildImagePreview() {
    return _selectedImage.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_selectedImage),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: const Center(child: Text('No Image Selected')),
          );
  }
}
