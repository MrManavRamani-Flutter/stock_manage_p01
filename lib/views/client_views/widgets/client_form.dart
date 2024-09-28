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
        });

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
    _selectedImage = ''; // Reset the image path
  }

  @override
  Widget build(BuildContext context) {
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
            _textField(_contactController, 'Contact', true),
            const SizedBox(height: 12),
            _textField(_shopAddressController, 'Shop Address'),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _pickImage, child: const Text('Pick Image')),
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

  TextFormField _textField(TextEditingController controller, String label,
      [bool isRequired = false]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
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
}
