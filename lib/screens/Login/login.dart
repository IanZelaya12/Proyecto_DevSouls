// lib/screens/login/login.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/styles.dart'; // tus estilos y widgets personalizados

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Iniciando sesión...')));

      Navigator.pushReplacementNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message ?? 'Error desconocido'}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ocurrió un error.')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;

    // ancho máximo para formularios en pantallas grandes
    final maxFormWidth = width > 700 ? 600.0 : width * 0.95;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Iniciar sesión'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom:
                      media.viewInsets.bottom + 24, // importante para teclado
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Títulos — FittedBox para evitar overflow en pantallas pequeñas
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Welcome',
                            style: AppTextStyles.titleStyle.copyWith(
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Back!',
                            style: AppTextStyles.titleStyle.copyWith(
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Card formulario
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                AppTextField(
                                  controller: _emailController,
                                  label: 'Correo electrónico',
                                  icon: const Icon(Icons.email),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty)
                                      return 'Ingresa un correo';
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(value.trim()))
                                      return 'Correo inválido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: 'Contraseña',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () => setState(
                                        () => _isPasswordVisible =
                                            !_isPasswordVisible,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Ingresa la contraseña';
                                    if (value.length < 6)
                                      return 'La contraseña debe tener al menos 6 caracteres';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      'forgot_password',
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppTextStyles.forgotPasswordStyle,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: AppButtonStyles.mainButtonStyle,
                                    child: Text(
                                      'Login',
                                      style: AppTextStyles.buttonTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

                        // Social buttons en fila — envueltas en Wrap para evitar overflow horizontal
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 12,
                          children: [
                            SocialLoginButton(
                              icon: const Icon(Icons.g_mobiledata),
                              onPressed: () {},
                            ),
                            SocialLoginButton(
                              icon: const Icon(Icons.apple),
                              onPressed: () {},
                            ),
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
                              'Create an Account',
                              style: AppTextStyles.createAccountStyle,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, 'register'),
                              child: Text(
                                'Sign Up',
                                style: AppTextStyles.signUpStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
