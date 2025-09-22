import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPerfilScreen extends StatefulWidget {
  const EditPerfilScreen({super.key});

  @override
  State<EditPerfilScreen> createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  // Controllers – Datos personales
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController(text: '********'); // solo visual

  // Dirección
  final postalCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  String? stateValue;
  final countryCtrl = TextEditingController(text: 'Honduras');

  // Banco
  final accountNumberCtrl = TextEditingController();
  final accountHolderCtrl = TextEditingController();
  final swiftCtrl = TextEditingController();

  bool _saving = false;

  final List<String> estados = const [
    'Atlántida',
    'Choluteca',
    'Colón',
    'Comayagua',
    'Copán',
    'Cortés',
    'El Paraíso',
    'Francisco Morazán',
    'Gracias a Dios',
    'Intibucá',
    'Islas de la Bahía',
    'La Paz',
    'Lempira',
    'Ocotepeque',
    'Olancho',
    'Santa Bárbara',
    'Valle',
    'Yoro',
  ];

  @override
  void initState() {
    super.initState();
    final u = _auth.currentUser;
    emailCtrl.text = u?.email ?? '';
    nombreCtrl.text = u?.displayName ?? '';

    // Cargar datos desde Firestore
    if (u != null) {
      FirebaseFirestore.instance.collection('users').doc(u.uid).get().then((
        doc,
      ) {
        final d = doc.data();
        if (d != null) {
          postalCtrl.text = d['postal'] ?? '';
          addressCtrl.text = d['address'] ?? '';
          cityCtrl.text = d['city'] ?? '';
          stateValue = d['state'];
          countryCtrl.text = d['country'] ?? countryCtrl.text;
          accountNumberCtrl.text = d['bankAccountNumber'] ?? '';
          accountHolderCtrl.text = d['accountHolder'] ?? '';
          swiftCtrl.text = d['swift'] ?? '';
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    postalCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    countryCtrl.dispose();
    accountNumberCtrl.dispose();
    accountHolderCtrl.dispose();
    swiftCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordReset() async {
    if (emailCtrl.text.isEmpty) return;
    await _auth.sendPasswordResetEmail(email: emailCtrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Te enviamos un correo para cambiar tu contraseña.'),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      // 1) Actualizar nombre en Auth
      await _auth.currentUser?.updateDisplayName(nombreCtrl.text.trim());

      // 2) Guardar en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
            'nombre': nombreCtrl.text.trim(),
            'email': emailCtrl.text.trim(),
            'address': addressCtrl.text.trim(),
            'postal': postalCtrl.text.trim(),
            'city': cityCtrl.text.trim(),
            'state': stateValue,
            'country': countryCtrl.text.trim(),
            'bankAccountNumber': accountNumberCtrl.text.trim(),
            'accountHolder': accountHolderCtrl.text.trim(),
            'swift': swiftCtrl.text.trim(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado 🎉')));
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore error (${e.code}): ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF6F7F9),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                children: [
                  // Avatar placeholder (sin imagen)
                  Center(
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== Personal Details =====
                  _sectionTitle('Personal Details'),
                  const SizedBox(height: 8),
                  _field(
                    label: 'Nombre completo',
                    controller: nombreCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    label: 'Email Address',
                    controller: emailCtrl,
                    readOnly: true, // no editable desde aquí
                  ),
                  const SizedBox(height: 12),
                  _passwordRow(),
                  const SizedBox(height: 20),

                  // ===== Address =====
                  _sectionTitle('Business Address Details'),
                  const SizedBox(height: 8),
                  _field(
                    label: 'Postcode',
                    controller: postalCtrl,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _field(label: 'Address', controller: addressCtrl),
                  const SizedBox(height: 12),
                  _field(label: 'City', controller: cityCtrl),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'State',
                    value: stateValue,
                    items: estados,
                    onChanged: (v) => setState(() => stateValue = v),
                  ),
                  const SizedBox(height: 12),
                  _field(label: 'Country', controller: countryCtrl),
                  const SizedBox(height: 20),

                  // ===== Bank =====
                  _sectionTitle('Bank Account Details'),
                  const SizedBox(height: 8),
                  _field(
                    label: 'Bank Account Number',
                    controller: accountNumberCtrl,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    label: 'Account Holder Name',
                    controller: accountHolderCtrl,
                  ),
                  const SizedBox(height: 12),
                  _field(label: 'BIC / Swift', controller: swiftCtrl),
                ],
              ),
            ),

            // Botón Guardar fijo
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== UI helpers =====
  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  );

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          readOnly: readOnly,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green.shade400, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: passwordCtrl,
                readOnly: true,
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: _sendPasswordReset,
              child: const Text('Change Password'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green.shade400, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
