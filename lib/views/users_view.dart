import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../models/user_model.dart';
import '../utils/global.dart';
import '../widgets/custom_appbar.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // TextEditingController for additional user details
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _totalPurchasesController =
      TextEditingController();
  final TextEditingController _returnStockController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String _selectedImage = ''; // Store selected image path
  List<User> filteredUsers = [];
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    filteredUsers = Global.users; // Initialize with global users
  }

  // Filter users based on search input
  void _filterUsers(String query) {
    setState(() {
      filteredUsers = Global.users
          .where((user) =>
              user.userName.toLowerCase().contains(query.toLowerCase()))
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

  void _addUser() {
    // Clear previous data
    _clearControllers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add User',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: _userForm(),
          actions: _dialogActions(onSubmit: () {
            final newUser = User(
              userName: _userNameController.text,
              email: _emailController.text,
              imageUrl: _selectedImage.isNotEmpty
                  ? _selectedImage
                  : './assets/img/users/user_1.png',
              shopAddress: _shopAddressController.text,
              totalPurchases: int.tryParse(_totalPurchasesController.text) ?? 0,
              returnStock: int.tryParse(_returnStockController.text) ?? 0,
              contactInfo: _contactInfoController.text,
              productsPurchased: [], // Initialize or populate as needed
            );
            Global.users.add(newUser);
            _filterUsers('');
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  Widget _userForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _textField(_userNameController, 'User Name', true),
            const SizedBox(height: 12),
            _textField(_emailController, 'Email', true),
            const SizedBox(height: 12),
            _textField(_shopAddressController, 'Shop Address'),
            const SizedBox(height: 12),
            _textField(_totalPurchasesController, 'Total Purchases', false,
                TextInputType.number),
            const SizedBox(height: 12),
            _textField(_returnStockController, 'Return Stock', false,
                TextInputType.number),
            const SizedBox(height: 12),
            _textField(_contactInfoController, 'Contact Info'),
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
    _userNameController.clear();
    _emailController.clear();
    _shopAddressController.clear();
    _totalPurchasesController.clear();
    _returnStockController.clear();
    _contactInfoController.clear();
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

  // Delete user
  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Global.users.removeAt(index);
                  _filterUsers(''); // Refresh the filtered list
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editUser(int index) {
    final user = filteredUsers[index];

    // Set initial values in controllers
    _userNameController.text = user.userName;
    _emailController.text = user.email;
    _shopAddressController.text = user.shopAddress ?? '';
    _totalPurchasesController.text = user.totalPurchases?.toString() ?? '';
    _returnStockController.text = user.returnStock?.toString() ?? '';
    _contactInfoController.text = user.contactInfo ?? '';
    _selectedImage = user.imageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Edit User',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: _userForm(),
          actions: _dialogActions(onSubmit: () {
            setState(() {
              Global.users[index] = User(
                userName: _userNameController.text,
                email: _emailController.text,
                imageUrl: _selectedImage.isNotEmpty
                    ? _selectedImage
                    : './assets/img/users/user_1.png',
                shopAddress: _shopAddressController.text,
                totalPurchases:
                    int.tryParse(_totalPurchasesController.text) ?? 0,
                returnStock: int.tryParse(_returnStockController.text) ?? 0,
                contactInfo: _contactInfoController.text,
              );
              _filterUsers('');
            });
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User',
        buttonText: 'Add',
        onButtonPressed: _addUser,
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
                  hintText: 'Search Users...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray),
                  ),
                ),
                onChanged: (query) => _filterUsers(query),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final isExpanded = _expandedIndex == index;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: _selectedImage.isNotEmpty
                                      ? FileImage(File(user.imageUrl))
                                      : const AssetImage(
                                          './assets/img/users/user_1.png',
                                        ),
                                ),
                                title: Text(user.userName),
                                subtitle: Text(user.email),
                                trailing: IconButton(
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _expandedIndex = isExpanded
                                          ? -1
                                          : index; // Toggle expansion
                                    });
                                  },
                                ),
                              ),
                              if (isExpanded)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.gray.withOpacity(0.2),
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.store,
                                                  color:
                                                      AppColors.primaryColor),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Shop Address: ${user.shopAddress}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone,
                                                  color:
                                                      AppColors.primaryColor),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Contact: ${user.contactInfo}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.shopping_cart,
                                                  color:
                                                      AppColors.primaryColor),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Total Purchases: ${user.totalPurchases}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.replay,
                                                  color:
                                                      AppColors.primaryColor),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Return Stock: ${user.returnStock}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                              thickness: 1,
                                              color: AppColors.gray),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Products Purchased:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: (user.productsPurchased ??
                                                    [])
                                                .map((product) => Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.arrow_right,
                                                              color: AppColors
                                                                  .primaryColor),
                                                          const SizedBox(
                                                              width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              '${product.name} (Qty: ${product.quantity})',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: AppColors
                                                                    .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () =>
                                                    _editUser(index),
                                                icon: const Icon(Icons.edit,
                                                    color: AppColors.white),
                                                label: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton.icon(
                                                onPressed: () =>
                                                    _deleteUser(index),
                                                icon: const Icon(Icons.delete,
                                                    color: AppColors.white),
                                                label: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No Users found',
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
