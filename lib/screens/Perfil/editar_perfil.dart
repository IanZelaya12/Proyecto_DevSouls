import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController =
      TextEditingController(); // Contraseña (solo visual)
  final _paypalEmailController = TextEditingController();
  bool _hasPayPalInfo = false;
  bool _applePay = false;
  bool _hasApplePayInfo = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Función para cargar los datos del usuario
  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Cargar datos desde FirebaseAuth (Nombre y Email)
      _nameController.text = currentUser.displayName ?? '';
      _emailController.text = currentUser.email ?? '';

      // Cargar datos adicionales desde Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          // Asignar valores de Firestore a los controladores
          _paypalEmailController.text = userData['paypalEmail'] ?? '';
          _hasPayPalInfo = userData['hasPayPalInfo'] ?? false;
          _applePay = userData['applePay'] ?? false;
          _hasApplePayInfo = userData['hasApplePayInfo'] ?? false;
        }
      }

      setState(() {});
    }
  }

  // Función para actualizar la información de pago en Firestore
  Future<void> updatePaymentInfo({
    required String paypalEmail,
    required bool hasPayPalInfo,
    required bool applePay,
    required bool hasApplePayInfo,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      await userDocRef.update({
        'paypalEmail': paypalEmail,
        'hasPayPalInfo': hasPayPalInfo,
        'paymentMethodUpdated': FieldValue.serverTimestamp(),
        'applePay': applePay,
        'hasApplePayInfo': hasApplePayInfo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información de pago actualizada.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la información: $e')),
      );
    }
  }

  // Función para actualizar el nombre y correo
  Future<void> updateUserInfo() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );
      await FirebaseAuth.instance.currentUser?.updateEmail(
        _emailController.text.trim(),
      );

      // Actualizar Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'nombre': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información del usuario actualizada.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la información: $e')),
      );
    }
  }

  // Función para enviar correo de restablecimiento de contraseña
  Future<void> sendPasswordResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te enviamos un correo para cambiar tu contraseña.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar el correo de restablecimiento: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre de usuario
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Correo electrónico
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // No editable
            ),
            const SizedBox(height: 16),

            // Contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Botón para cambiar la contraseña
            TextButton(
              onPressed: sendPasswordResetEmail,
              child: const Text('Cambiar Contraseña'),
            ),
            const SizedBox(height: 16),

            // Información de PayPal y Apple Pay
            TextField(
              controller: _paypalEmailController,
              decoration: const InputDecoration(
                labelText: 'Correo de PayPal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('¿Tienes PayPal configurado?'),
              value: _hasPayPalInfo,
              onChanged: (bool value) {
                setState(() {
                  _hasPayPalInfo = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('¿Tienes Apple Pay?'),
              value: _applePay,
              onChanged: (bool value) {
                setState(() {
                  _applePay = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('¿Tienes Apple Pay configurado?'),
              value: _hasApplePayInfo,
              onChanged: (bool value) {
                setState(() {
                  _hasApplePayInfo = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Botón para guardar cambios
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () {
                      setState(() {
                        _loading = true;
                      });

                      // Actualizar la información del usuario
                      updateUserInfo().then((_) {
                        // Actualizar la información de pago
                        updatePaymentInfo(
                          paypalEmail: _paypalEmailController.text.trim(),
                          hasPayPalInfo: _hasPayPalInfo,
                          applePay: _applePay,
                          hasApplePayInfo: _hasApplePayInfo,
                        ).then((_) {
                          setState(() {
                            _loading = false;
                          });
                        });
                      });
                    },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Actualizar Información'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on User? {
  Future<void> updateEmail(String trim) async {}
}
