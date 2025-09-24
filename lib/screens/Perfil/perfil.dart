import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editar_perfil.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final u = auth.currentUser;
    if (u == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), centerTitle: true),
      backgroundColor: const Color(0xFFF6F7F9),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(u.uid)
            .snapshots(),
        builder: (context, snap) {
          final d = snap.data?.data() ?? {};
          final nombre = d['nombre'] ?? u.displayName ?? 'Usuario';
          final email = d['email'] ?? u.email ?? '—';

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              // Avatar placeholder (sin imagen)
              Center(
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(
                    Icons.person,
                    size: 46,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre'),
                    const SizedBox(height: 6),
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _divider(),
                    const SizedBox(height: 14),
                    _label('Email'),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Editar perfil'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Cambiar contraseña'),
                      onTap: () async {
                        final email = auth.currentUser?.email;
                        if (email == null) return;
                        await auth.sendPasswordResetEmail(email: email);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Te enviamos un correo para cambiar la contraseña.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Cerrar sesión
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final ok = await showModalBottomSheet<bool>(
                      context: context,
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      builder: (ctx) => _LogoutSheet(),
                    );
                    if (ok == true) {
                      await auth.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'init',
                          (_) => false,
                        );
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  Widget _label(String text) =>
      Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 13));
  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);
}

class _LogoutSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.logout, size: 36, color: Colors.red),
          const SizedBox(height: 8),
          const Text(
            'Cerrar sesión',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '¿Seguro que quieres cerrar tu sesión?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
