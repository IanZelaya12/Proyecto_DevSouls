import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Para permitir la selección de imágenes
import 'package:firebase_storage/firebase_storage.dart'; // Para subir imágenes a Firebase Storage
import 'package:google_fonts/google_fonts.dart'; // Para fuentes personalizadas
import 'widgets/styles.dart'; // Para usar los colores

class EditPerfilScreen extends StatefulWidget {
  const EditPerfilScreen({super.key});

  @override
  _EditPerfilScreenState createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _imageUrl;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar los datos del usuario al inicio
  }

  // Cargar los datos del usuario (nombre, correo, teléfono y foto)
  void _loadUserData() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _nameController.text = _user!.displayName ?? ''; // Cargar nombre actual
      _emailController.text = _user!.email ?? ''; // Cargar correo actual
      _phoneController.text =
          _user!.phoneNumber ?? ''; // Cargar teléfono actual
      _imageUrl = _user!.photoURL; // Cargar foto actual
    }
  }

  // Función para actualizar el nombre de usuario, correo y número de teléfono
  Future<void> _updateProfile() async {
    try {
      // Actualizar el nombre
      await _user!.updateDisplayName(_nameController.text);

      // Actualizar el correo (si es posible)
      if (_emailController.text.isNotEmpty &&
          _emailController.text != _user!.email) {
        await _user!.updateEmail(_emailController.text);
      }

      // Actualizar el número de teléfono (si es posible)
      if (_phoneController.text.isNotEmpty) {
        await _user!.updatePhoneNumber(
          PhoneAuthProvider.credential(
            verificationId: '',
            smsCode: _phoneController.text,
          ),
        );
      }

      // Si hay una nueva foto, actualizarla
      if (_imageUrl != null) {
        await _user!.updatePhotoURL(_imageUrl);
      }

      // Confirmar que los cambios fueron guardados
      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado exitosamente!')),
      );

      // Redirigir al perfil después de guardar los cambios
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Función para seleccionar una nueva foto de perfil
  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      // Subir la imagen a Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${_user!.uid}.jpg');
        await storageRef.putFile(File(pickedFile.path));
        String downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl; // Guardar la URL de la nueva foto
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 4,
              ), // Borde blanco alrededor
              borderRadius: BorderRadius.circular(25), // Bordes más circulares
              color: const Color.fromARGB(255, 42, 109, 91), // Fondo verde
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Foto de perfil y botón para cambiarla
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : const AssetImage(
                                      'assets/img/default_profile.png',
                                    )
                                    as ImageProvider,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Texto para cambiar foto
                  TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      'Cambiar foto de perfil',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo para editar el nombre de usuario
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                      ), // Estilo del texto
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white24, // Fondo transparente
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo para editar el correo electrónico
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      labelStyle: GoogleFonts.poppins(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white24,
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Campo para editar el número de teléfono
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Número de Teléfono',
                      labelStyle: GoogleFonts.poppins(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white24,
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Botón para guardar los cambios
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Guardar cambios',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
