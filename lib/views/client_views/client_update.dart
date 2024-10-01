import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_manage/models/client_model.dart';

import '../../utils/global.dart';

class EditClientView extends StatefulWidget {
  final Client client;
  final Function(Client) onClientUpdated;

  const EditClientView({
    super.key,
    required this.client,
    required this.onClientUpdated,
  });

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

  void _initializeFields() {
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
        _selectedImage = image.path;
      });
    }
  }

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
    Navigator.of(context).pop();
  }

  void _updateClientInGlobalList(Client updatedClient) {
    final index =
        Global.clients.indexWhere((client) => client.id == widget.client.id);
    if (index != -1) {
      Global.clients[index] = updatedClient;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

  Widget _buildTextField(TextEditingController controller, String label,
      [String? errorMessage]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorMessage != null && controller.text.isEmpty
            ? errorMessage
            : null,
      ),
    );
  }

  Widget _buildImagePreview() {
    return _selectedImage.isNotEmpty
        ? Image.file(File(_selectedImage), height: 100)
        : const SizedBox(height: 100);
  }
}
