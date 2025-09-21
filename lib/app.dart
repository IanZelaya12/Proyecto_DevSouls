import 'package:flutter/material.dart';

class SportsApp extends StatelessWidget {
  const SportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Canchas',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14.0),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
