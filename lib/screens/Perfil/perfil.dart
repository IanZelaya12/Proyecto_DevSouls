import 'package:flutter/material.dart';
import 'package:proyecto_devsouls/auth/user_service.dart';
import 'editar_perfil.dart';
import 'widgets/perfil_card.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 172, 106),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 172, 106),
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: userService.streamUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'No se encontraron datos del usuario',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final userData = snapshot.data!;

          return PerfilCard(
            userData: userData, // ✅ ahora se pasa el mapa completo
            onEditProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditPerfilScreen()),
              );
            },
            onSignOut: () async {
              await userService.signOut();
              Navigator.pushReplacementNamed(context, 'init');
            },
          );
        },
      ),
    );
  }
}
