import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_devsouls/auth/user_service.dart';

class EditPerfilScreen extends StatefulWidget {
  const EditPerfilScreen({super.key});

  @override
  _EditPerfilScreenState createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _bankController = TextEditingController();
  final _holderController = TextEditingController();
  final _ifscController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _pickedFile;
  String? _imageUrl;

  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await userService.getUserData();
    if (data != null) {
      setState(() {
        _emailController.text = data['email'] ?? '';
        _passwordController.text = data['personalDetails']?['password'] ?? '';
        _pincodeController.text = data['businessAddress']?['pincode'] ?? '';
        _addressController.text = data['businessAddress']?['address'] ?? '';
        _cityController.text = data['businessAddress']?['city'] ?? '';
        _stateController.text = data['businessAddress']?['state'] ?? '';
        _countryController.text = data['businessAddress']?['country'] ?? '';
        _bankController.text = data['bankDetails']?['accountNumber'] ?? '';
        _holderController.text = data['bankDetails']?['holderName'] ?? '';
        _ifscController.text = data['bankDetails']?['ifscCode'] ?? '';
        _imageUrl = data['photoUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedFile = File(picked.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_pickedFile != null) {
        _imageUrl = await userService.uploadProfileImage(_pickedFile!);
      }

      await userService.updateUserData({
        'email': _emailController.text,
        'photoUrl': _imageUrl,
        'personalDetails': {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
        'businessAddress': {
          'pincode': _pincodeController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
        },
        'bankDetails': {
          'accountNumber': _bankController.text,
          'holderName': _holderController.text,
          'ifscCode': _ifscController.text,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado exitosamente!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white24,
      ),
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color.fromARGB(255, 15, 172, 106),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 42, 109, 91),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _pickedFile != null
                        ? FileImage(_pickedFile!)
                        : (_imageUrl != null
                                  ? NetworkImage(_imageUrl!)
                                  : const AssetImage(
                                      'assets/img/default_profile.png',
                                    ))
                              as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    'Cambiar foto de perfil',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _emailController,
                  'Correo electrónico',
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _passwordController,
                  'Contraseña',
                  type: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 16),
                _buildTextField(_pincodeController, 'Código Postal'),
                const SizedBox(height: 16),
                _buildTextField(_addressController, 'Dirección'),
                const SizedBox(height: 16),
                _buildTextField(_cityController, 'Ciudad'),
                const SizedBox(height: 16),
                _buildTextField(_stateController, 'Estado'),
                const SizedBox(height: 16),
                _buildTextField(_countryController, 'País'),
                const SizedBox(height: 16),
                _buildTextField(_bankController, 'Número de cuenta'),
                const SizedBox(height: 16),
                _buildTextField(_holderController, 'Titular de la cuenta'),
                const SizedBox(height: 16),
                _buildTextField(_ifscController, 'Código IFSC'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 15, 172, 106),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Guardar cambios',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
