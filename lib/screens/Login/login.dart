// lib/screens/login/login.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar Firebase Auth
import 'widgets/styles.dart'; // Importar los estilos

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Función de inicio de sesión
  void _login() async {
    try {
      // Intenta iniciar sesión con Firebase usando el correo y la contraseña
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text, // Correo ingresado
            password: _passwordController.text, // Contraseña ingresada
          );

      // Si el login es exitoso, muestra un mensaje y navega a la pantalla principal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Iniciando sesión...')));

      // Navegar a la pantalla de Home después del login exitoso
      Navigator.pushReplacementNamed(
        context,
        'home', // Redirigir a Home después de un login exitoso
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
        title: const Text('Iniciar sesión'),
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
              'Welcome', // Título de bienvenida (Welcome)
              style: AppTextStyles.titleStyle.copyWith(fontSize: 50),
            ),
            const SizedBox(height: 5),
            Text(
              'Back!', // Título de bienvenida (Back)
              style: AppTextStyles.titleStyle.copyWith(fontSize: 50),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Aquí iría la lógica para olvidar la contraseña
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.forgotPasswordStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login, // Llama la función de login
                    style: AppButtonStyles
                        .mainButtonStyle, // Usando los estilos del botón
                    child: Text(
                      'Login',
                      style: AppTextStyles.buttonTextStyle,
                    ), // Estilo del texto
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
                  'Create an Account',
                  style: AppTextStyles.createAccountStyle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'register',
                    ); // Redirigir a la pantalla de registro
                  },
                  child: Text(
                    'Sign Up',
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
