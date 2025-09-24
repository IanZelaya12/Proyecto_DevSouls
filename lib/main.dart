import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login/login.dart';
import 'screens/register/register.dart';
import 'screens/home/home.dart';
import 'screens/intro/pantalla_principal/intro_screen.dart';
import 'screens/Mapa/mapa.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeNotifications();
  runApp(const MyApp());
}

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
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        'intro': (context) => const IntroScreen(),
        'init': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home': (context) => const HomeScreen(),
        'rutaMapa': (context) => const MapaScreen(),
      },
    );
  }
}

// Widget que decide qué pantalla mostrar al iniciar
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _showIntro = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    // 1. Verificar usuario logueado
    _user = FirebaseAuth.instance.currentUser;

    // 2. Verificar si es primera vez que abre la app
    final prefs = await SharedPreferences.getInstance();
    _showIntro = prefs.getBool('showIntro') ?? true;

    if (_showIntro) {
      await prefs.setBool('showIntro', false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_showIntro) {
      return const IntroScreen();
    }

    if (_user != null) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
