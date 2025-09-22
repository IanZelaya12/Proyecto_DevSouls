import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Asegúrate de importar Firebase Core
import 'screens/login/login.dart'; // Pantalla de login
import 'screens/register/register.dart'; // Pantalla de registro
import 'screens/home/home.dart'; // Pantalla de home
import 'screens/intro/pantalla_principal/intro_screen.dart'; // Pantalla de introducción (nuevo)
import 'screens/Mapa/mapa.dart';

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
        primarySwatch:
            Colors.green, // Usamos un tema más relacionado con el color verde
      ),
      initialRoute: 'intro', // Cambiar la ruta inicial a 'intro'
      routes: {
        'intro': (context) =>
            const IntroScreen(), // Ruta para las pantallas de introducción
        'init': (context) => LoginScreen(), // Ruta para el login
        'register': (context) =>
            const RegisterScreen(), // Ruta para el registro
        'home': (context) =>
            const HomeScreen(), // Ruta para la pantalla de Home
        'rutaMapa': (context) => const MapaScreen(),
      },
    );
  }
}
