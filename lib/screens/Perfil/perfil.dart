import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener datos del usuario
import 'widgets/perfil_card.dart'; // Usamos el widget creado anteriormente
import 'editar_perfil.dart';
import 'package:google_fonts/google_fonts.dart'; // Usar Google Fonts

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener los datos del usuario desde Firebase
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? 'Usuario';
    String email = user?.email ?? 'No disponible';
    String photoURL = user?.photoURL ?? ''; // Foto de perfil (opcional)

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 83, 63),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PerfilCard(
            name: displayName,
            email: email,
            onEditProfile: () {
              // Navegar a la pantalla de editar perfil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditPerfilScreen(),
                ),
              );
            },
            onSignOut: () {
              // Mostrar la ventana emergente para confirmar cerrar sesión
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      '¿Cerrar sesión?',
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Text(
                      'Podrás volver a iniciar más tarde. Se guardarán tus cambios.',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Cerrar sesión
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(
                            context,
                            'init', // Redirigir al login
                          );
                        },
                        child: Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
