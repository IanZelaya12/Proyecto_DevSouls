import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Asegúrate de importar Firebase Core
import 'screens/login/login.dart'; // Pantalla de login
import 'screens/register/register.dart'; // Pantalla de registro
import 'screens/home/home.dart'; // Pantalla de home

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto DevSouls',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ), // Usamos un tema más relacionado con el color verde
      initialRoute: 'init', // Ruta inicial
      routes: {
        'init': (context) =>
            const LoginScreen(), // Pantalla de login actualizada
        'register': (context) =>
            const RegisterScreen(), // Ruta para el registro
        'home': (context) =>
            const HomeScreen(), // Ruta para la pantalla de Home
      },
    );
  }
}
