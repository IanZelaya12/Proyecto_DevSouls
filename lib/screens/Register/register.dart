// lib/screens/register/register.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'widgets/styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _loading = false;

  Future<void> _register() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final email = _emailController.text.trim();
      final pass = _passwordController.text.trim();
      final name = _nameController.text.trim();

      // 1) Crear cuenta en Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // 2) Nombre visible en Auth
      await cred.user?.updateDisplayName(name);

      // 3) Crear/actualizar documento en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'email': email,
            'nombre': name,
            'photoURL': cred.user?.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      // 4) Ir a Home
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. ¡Bienvenido!')),
      );
      Navigator.pushReplacementNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      // 👈 aquí va "catch (e)" y no "as e"
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } catch (e, _) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create an',
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Account',
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: 'Nombre completo',
                    icon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    icon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    obscureText: !_isPasswordVisible,
                    icon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: AppButtonStyles.mainButtonStyle,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Create Account',
                            style: AppTextStyles.buttonTextStyle,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                '- Or Continue with -',
                style: AppTextStyles.subtitleStyle,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialLoginButton(
                  icon: const Icon(Icons.g_mobiledata),
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                SocialLoginButton(
                  icon: const Icon(Icons.apple),
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                SocialLoginButton(
                  icon: const Icon(Icons.facebook),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I Already have an Account?',
                  style: AppTextStyles.createAccountStyle,
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, 'init'),
                  child: Text('Login', style: AppTextStyles.signUpStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
