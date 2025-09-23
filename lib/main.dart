import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Asegúrate de importar Firebase Core
import 'screens/login/login.dart';
import 'screens/register/register.dart';
import 'screens/home/home.dart';
import 'screens/intro/pantalla_principal/intro_screen.dart';
import 'screens/Mapa/mapa.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  await _initializeNotifications(); // Inicializar las notificaciones
  runApp(const MyApp());
}

// Inicialización de notificaciones
Future<void> _initializeNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto DevSouls',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: 'intro',
      routes: {
        'intro': (context) => const IntroScreen(),
        'init': (context) => LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home': (context) => const HomeScreen(),
        'rutaMapa': (context) => const MapaScreen(),
      },
    );
  }
}
