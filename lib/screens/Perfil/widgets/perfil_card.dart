import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEditProfile;
  final VoidCallback onSignOut;

  const PerfilCard({
    required this.name,
    required this.email,
    required this.onEditProfile,
    required this.onSignOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromARGB(0, 231, 102, 102), // Sin color de fondo aquí
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ), // Borde blanco alrededor del contenedor principal
          borderRadius: BorderRadius.circular(15), // Redondeo de los bordes
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ), // Espaciado interno del contenido
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ??
                      'https://www.w3schools.com/w3images/avatar2.png',
                ),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),

              // Contenedor del nombre y disponible con borde blanco interno
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ), // Borde blanco interno
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 40, // Nombre más grande
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: GoogleFonts.inter(
                        fontSize: 22, // Texto más grande para el correo
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 8),
                        Text(
                          'Disponible',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20, // Texto "Disponible" más grande
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Mini contenedores para Teléfono y Usuario con bordes blancos
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ), // Borde blanco
                ),
                child: _buildDataRow('Teléfono', '+34 612 345 678'),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ), // Borde blanco
                ),
                child: _buildDataRow('Usuario', '@$name'.toLowerCase()),
              ),
              const SizedBox(height: 30),
              // Botones: Primero Editar perfil, luego Cerrar sesión con bordes blancos y más grandes
              Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        200,
                        50,
                      ), // Aumento el tamaño de los botones
                      backgroundColor: const Color.fromARGB(255, 15, 172, 106),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ), // Borde blanco
                      ),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Editar perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ), // Letra más grande
                    ),
                    onPressed: onEditProfile,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        200,
                        50,
                      ), // Aumento el tamaño de los botones
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ), // Borde blanco
                      ),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ), // Letra más grande
                    ),
                    onPressed: onSignOut,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title:',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
