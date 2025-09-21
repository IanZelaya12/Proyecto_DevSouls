import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;
  final VoidCallback onSignOut;

  const PerfilCard({
    required this.userData,
    required this.onEditProfile,
    required this.onSignOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String name = userData['name'] ?? 'Usuario';
    final String email = userData['email'] ?? 'No disponible';
    final String? photoUrl = userData['photoUrl'];

    // Datos organizados
    final personal = userData['personalDetails'] ?? {};
    final business = userData['businessAddress'] ?? {};
    final bank = userData['bankDetails'] ?? {};

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/img/default_profile.png')
                          as ImageProvider,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),

              // Nombre y correo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Datos personales
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Detalles personales'),
                    _buildDataRow('Correo', personal['email'] ?? ''),
                    _buildDataRow('Contraseña', personal['password'] ?? ''),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Dirección
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Dirección de negocio'),
                    _buildDataRow('Código Postal', business['pincode'] ?? ''),
                    _buildDataRow('Dirección', business['address'] ?? ''),
                    _buildDataRow('Ciudad', business['city'] ?? ''),
                    _buildDataRow('Estado', business['state'] ?? ''),
                    _buildDataRow('País', business['country'] ?? ''),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Datos bancarios
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Detalles bancarios'),
                    _buildDataRow(
                      'Número de cuenta',
                      bank['accountNumber'] ?? '',
                    ),
                    _buildDataRow('Titular', bank['holderName'] ?? ''),
                    _buildDataRow('Código IFSC', bank['ifscCode'] ?? ''),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Botones
              Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: const Color.fromARGB(255, 15, 172, 106),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Editar perfil',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: onEditProfile,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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

  /// 🔹 Estilo de contenedor
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white, width: 2),
    );
  }

  /// 🔹 Título de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 🔹 Fila de datos
  Widget _buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
