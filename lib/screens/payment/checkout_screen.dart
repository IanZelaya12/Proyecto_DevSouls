import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_success_screen.dart';
import '..//Perfil/editar_perfil.dart';

enum PaymentMethodType { stripeCard, paypal, applePay }

class CheckoutScreen extends StatefulWidget {
  final String reservationId;
  final int amountCents;
  final String currency; // 'HNL', etc.
  final String courtName;

  const CheckoutScreen({
    super.key,
    required this.reservationId,
    required this.amountCents,
    required this.courtName,
    this.currency = 'HNL',
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isPaying = false;
  bool _hasBankInfo =
      false; // Para verificar si tiene los datos bancarios completos
  bool _hasPaymentInfo = false; // Verificar si tiene tarjeta, PayPal, etc.
  PaymentMethodType _method = PaymentMethodType.stripeCard;
  bool _acceptedTerms = false;

  String get _amountFormatted {
    final f = NumberFormat.simpleCurrency(name: widget.currency);
    return f.format(widget.amountCents / 100);
  }

  // Método para cargar los datos desde Firestore (perfil + métodos de pago)
  Future<void> _loadPaymentMethods() async {
    final uid = _auth.currentUser!.uid;

    // Cargar los datos de perfil (nombre, email, etc.)
    final userDoc = await _db.collection('users').doc(uid).get();
    final userData = userDoc.data();
    if (userData != null) {
      setState(() {
        // Verificar los datos bancarios
        _hasBankInfo =
            userData['bankAccountNumber'] != null &&
            userData['accountHolder'] != null;
        _hasPaymentInfo =
            _hasBankInfo ||
            userData['paypalEmail'] != null ||
            userData['applePay'] != null;
      });
    }
  }

  // Verificar los datos bancarios antes de permitir el pago
  Future<void> _processPayment() async {
    if (!_acceptedTerms) {
      _snack('Debes aceptar los términos y condiciones.');
      return;
    }

    // Verificar si tiene datos de pago completos (banco, tarjeta, etc.)
    if (!_hasPaymentInfo) {
      _showMissingPaymentInfoModal();
      return;
    }

    setState(() => _isPaying = true);

    try {
      // Simulación del proceso de pago
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!_hasPaymentInfo) {
        // Si no hay información de pago, no se debería continuar
        _snack('No tienes los datos de pago completos.');
        return;
      }

      if (!mounted) return;

      // Mostrar el diálogo de éxito solo si todo es válido
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PaymentSuccessScreen(onContinue: _goHome),
      );
    } catch (e) {
      _snack('Error al procesar el pago: $e');
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  // Mostrar ventana emergente si falta información de pago
  void _showMissingPaymentInfoModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Información de Pago Requerida'),
        content: const Text(
          'Por favor, ingresa o completa tu información de pago en tu perfil.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el modal
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditPerfilScreen(),
                ), // Redirigir a editar perfil
              );
            },
            child: const Text('Ir a Editar Perfil'),
          ),
        ],
      ),
    );
  }

  // Redirigir al home después de un pago exitoso
  void _goHome() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('home', (route) => false); // Redirige a Home
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods(); // Cargar datos de Firestore
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumen
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.receipt_long, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reserva #${widget.reservationId}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cancha: ${widget.courtName}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _amountFormatted,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.currency,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Métodos de pago
              Text(
                'Métodos de pago',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _PaymentMethodTile(
                selected: _method == PaymentMethodType.stripeCard,
                title: 'Tarjeta (Stripe)',
                subtitle: 'Visa, Mastercard, AmEx',
                icon: Icons.credit_card,
                onTap: () =>
                    setState(() => _method = PaymentMethodType.stripeCard),
              ),
              _PaymentMethodTile(
                selected: _method == PaymentMethodType.paypal,
                title: 'PayPal',
                subtitle: 'Paga con tu cuenta PayPal',
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => setState(() => _method = PaymentMethodType.paypal),
              ),
              _PaymentMethodTile(
                selected: _method == PaymentMethodType.applePay,
                title: 'Apple Pay',
                subtitle: 'Disponible en dispositivos compatibles',
                icon: Icons.phone_iphone,
                onTap: () =>
                    setState(() => _method = PaymentMethodType.applePay),
              ),

              const SizedBox(height: 16),

              // Términos
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (v) =>
                        setState(() => _acceptedTerms = v ?? false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'He leído y acepto los Términos y Condiciones de la reserva y el procesamiento del pago.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botón pagar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_outline),
                  onPressed: _isPaying ? null : _processPayment,
                  label: Text(
                    _isPaying ? 'Procesando…' : 'Pagar $_amountFormatted',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tu pago es seguro.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ),
            ],
          ),
          if (_isPaying)
            Container(
              color: Colors.black.withOpacity(0.08),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? theme.colorScheme.primary : theme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
