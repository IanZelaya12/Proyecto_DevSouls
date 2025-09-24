import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Asegúrate de importar Firebase Core
import 'package:proyecto_devsouls/services/FirebaseFirestore.dart'; // Importa el servicio de Firestore
import 'package:proyecto_devsouls/data/sports_data.dart'; // Importa los datos de las canchas
import 'screens/login/login.dart';
import 'screens/register/register.dart';
import 'screens/home/home.dart';
import 'screens/intro/pantalla_principal/intro_screen.dart';
import 'screens/Mapa/mapa.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para autenticación

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  await _initializeNotifications(); // Inicializar las notificaciones

  // Llamar a la función para subir los datos a Firestore después de verificar si el usuario está autenticado
  await uploadVenuesToFirestore();

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

// Función para subir los lugares deportivos a Firestore
Future<void> uploadVenuesToFirestore() async {
  // Verificar si el usuario está autenticado
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Si el usuario está autenticado
    FirestoreService firestoreService = FirestoreService();

    // Recorremos la lista de todos los lugares deportivos
    for (var venue in SportsData.getAllVenues()) {
      try {
        await firestoreService.addSportsVenue(
          venue,
        ); // Subimos cada lugar a Firestore
        print("Lugar deportivo agregado: ${venue.name}");
      } catch (e) {
        print("Error al agregar el lugar deportivo: $e");
      }
    }
  } else {
    // Si el usuario no está autenticado, muestra un mensaje
    print("Usuario no autenticado. No se puede agregar el lugar deportivo.");
  }
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
