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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_clientNameController, 'Client Name',
                isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(_emailController, 'Email', isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(_contactController, 'Contact', isRequired: true),
            const SizedBox(height: 12),
            _buildTextField(_shopAddressController, 'Shop Address'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addClient,
              child: const Text('Add Client'),
            ),
          ],
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
          _selectedImage = pickedFile.path; // Use the selected image
        });
      }
    } else {
      setState(() {
        _selectedImage = ''; // Reset if no image is selected
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
      _selectedImage = ''; // Reset the image path
    });
  }

  TextFormField _buildTextField(TextEditingController controller, String label,
      {bool isRequired = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'Please enter a $label' : null
          : null,
    );
  }
}
