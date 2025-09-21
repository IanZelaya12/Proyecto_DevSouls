// lib/screens/register/register.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar Firebase Auth
import 'widgets/styles.dart'; // Importar los estilos

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

  // Función de registro
  void _register() async {
    try {
      // Intenta registrar al usuario con Firebase usando el correo y la contraseña
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text, // Correo ingresado
            password: _passwordController.text, // Contraseña ingresada
          );

      // Si el registro es exitoso, muestra un mensaje y navega a la pantalla principal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registrando...')));

      // Asignar el nombre de usuario al usuario recién registrado
      await userCredential.user?.updateDisplayName(_nameController.text);

      // Navegar a la pantalla de Home después del registro exitoso
      Navigator.pushReplacementNamed(
        context,
        'home', // Cambiar 'main-app' a 'home'
      );
    } on FirebaseAuthException catch (e) {
      // Si hay un error, muestra un mensaje de error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor, // Establecer el color de fondo
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppColors.primaryColor, // Color del AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alineado a la izquierda
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create an', // Título de bienvenida (Create)
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Account', // Título de bienvenida (Account)
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, // Hacer el formulario más ancho
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
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register, // Llama la función de registro
                    style: AppButtonStyles
                        .mainButtonStyle, // Usando los estilos del botón
                    child: Text(
                      'Create Account',
                      style: AppTextStyles.buttonTextStyle,
                    ), // Estilo del texto
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
                  icon: const Icon(Icons.g_mobiledata), // Google icon
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                SocialLoginButton(
                  icon: const Icon(Icons.apple), // Apple icon
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                SocialLoginButton(
                  icon: const Icon(Icons.facebook), // Facebook icon
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
                  onPressed: () {
                    Navigator.pushNamed(context, 'init'); // Redirigir al login
                  },
                  child: Text(
                    'Login',
                    style: AppTextStyles.signUpStyle, // Texto subrayado y verde
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
