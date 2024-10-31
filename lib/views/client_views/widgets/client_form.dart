import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_manage/models/client_model.dart';
import 'package:stock_manage/utils/global.dart';

class ClientForm extends StatefulWidget {
  final Function(Client) onSubmit;

  const ClientForm({super.key, required this.onSubmit});

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedImage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Client',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(_clientNameController, 'Client Name',
                  isRequired: true),
              const SizedBox(height: 12),
              _buildTextField(_emailController, 'Email', isRequired: true),
              const SizedBox(height: 12),
              _buildTextField(_contactController, 'Contact', isRequired: true),
              const SizedBox(height: 12),
              _buildTextField(_shopAddressController, 'Shop Address'),
              const SizedBox(height: 20),
              if (_selectedImage.isNotEmpty)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(File(_selectedImage)),
                )
              else
                const Icon(Icons.person, size: 80, color: Colors.grey),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addClient,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add Client', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
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
              _buildImageSourceOption(picker, ImageSource.gallery, 'Gallery'),
              _buildImageSourceOption(picker, ImageSource.camera, 'Camera'),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (await file.exists()) {
        setState(() {
          _selectedImage = pickedFile.path;
        });
      }
    } else {
      setState(() {
        _selectedImage = '';
      });
    }
  }

  ListTile _buildImageSourceOption(
      ImagePicker picker, ImageSource source, String title) {
    return ListTile(
      leading: Icon(source == ImageSource.camera
          ? Icons.camera_alt
          : Icons.photo_library),
      title: Text(title),
      onTap: () async {
        final file = await picker.pickImage(source: source);
        Navigator.of(context).pop(file);
      },
    );
  }

  void _addClient() {
    if (_formKey.currentState?.validate() ?? false) {
      final newClient = Client(
        id: (Global.clients.length + 1).toString(),
        clientName: _clientNameController.text,
        email: _emailController.text,
        contact: _contactController.text,
        imageUrl: _selectedImage.isNotEmpty ? _selectedImage : '',
        shopAddress: _shopAddressController.text,
      );

      widget.onSubmit(newClient);
      _clearControllers();
      Navigator.of(context).pop();
    }
  }

  void _clearControllers() {
    _clientNameController.clear();
    _emailController.clear();
    _contactController.clear();
    _shopAddressController.clear();
    setState(() {
      _selectedImage = '';
    });
  }

  TextFormField _buildTextField(TextEditingController controller, String label,
      {bool isRequired = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      validator: isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'Please enter a $label' : null
          : null,
    );
  }
}
