// lib/screens/payment/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String reservationId;
  final int amountCents; // monto en centavos
  final String currency;
  final String courtName;
  const CheckoutScreen({
    super.key,
    required this.reservationId,
    required this.amountCents,
    this.currency = 'usd',
    required this.courtName,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethodType { stripeCard, paypal, applePay }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final functions = FirebaseFunctions.instance;
  final auth = FirebaseAuth.instance;
  bool loading = false;
  PaymentMethodType selected = PaymentMethodType.stripeCard;

  // minimal form fields for display (we rely on Stripe Payment Sheet; no card fields)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final padding = isWide
              ? const EdgeInsets.symmetric(horizontal: 64, vertical: 24)
              : const EdgeInsets.all(16);

          return Padding(
            padding: padding,
            child: Column(
              children: [
                if (isWide)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildOrderSummary()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildPaymentChoices()),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildOrderSummary(),
                          const SizedBox(height: 16),
                          _buildPaymentChoices(),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading ? null : _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary() {
    final total = (widget.amountCents / 100).toStringAsFixed(2);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courtName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Order', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('\$ $total'), const Text('USD')],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$ $total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _paymentTile(PaymentMethodType.stripeCard, 'Card (Stripe)'),
        _paymentTile(PaymentMethodType.paypal, 'PayPal'),
        _paymentTile(PaymentMethodType.applePay, 'Apple / Google Pay'),
        const SizedBox(height: 12),
        const Text('Selecciona el método y presiona Continue.'),
      ],
    );
  }

  Widget _paymentTile(PaymentMethodType method, String title) {
    final selectedColor = selected == method
        ? Colors.green
        : Colors.grey.shade200;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected == method ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Icon(
          method == PaymentMethodType.paypal
              ? Icons.account_balance_wallet
              : Icons.payment,
        ),
        title: Text(title),
        trailing: selected == method
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () => setState(() => selected = method),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (selected == PaymentMethodType.stripeCard) {
      await _handleStripePayment();
    } else if (selected == PaymentMethodType.paypal) {
      await _handlePayPalFlow();
    } else {
      // Apple/Google Pay normalmente se configura en Stripe PaymentSheet (si está habilitado para merchant)
      await _handleStripePayment(useApplePay: true);
    }
  }

  Future<void> _handleStripePayment({bool useApplePay = false}) async {
    setState(() => loading = true);
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');
      // Llamar callable function createPaymentIntent
      final callable = functions.httpsCallable('createPaymentIntent');
      final result = await callable.call(<String, dynamic>{
        'amountCents': widget.amountCents,
        'currency': widget.currency,
        'reservationId': widget.reservationId,
        'description': 'Reserva cancha ${widget.reservationId}',
      });

      final data = result.data as Map<String, dynamic>;
      final clientSecret = data['clientSecret'] as String;
      final paymentIntentId = data['paymentIntentId'] as String;

      // Init Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Canchas App',
          // enableGooglePay and applePay available if configured in Stripe account
          applePay: useApplePay,
          googlePay: useApplePay,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      // opcional: llamar markPaymentComplete (backup). Prefer webhooks.
      final mark = functions.httpsCallable('markPaymentComplete');
      await mark.call({'paymentIntentId': paymentIntentId});

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PaymentSuccessScreen(),
      );
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Stripe: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error proceso: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _handlePayPalFlow() async {
    setState(() => loading = true);
    try {
      final callable = functions.httpsCallable('createPayPalOrder');
      final result = await callable.call(<String, dynamic>{
        'reservationId': widget.reservationId,
        'amount': (widget.amountCents / 100).toStringAsFixed(2),
      });

      // approveLink es la URL de PayPal para aprobación de usuario
      final data = result.data as Map<String, dynamic>;
      final approveLink = data['approveLink'] as String?;
      final orderId = data['orderId'] as String?;

      if (approveLink == null) throw Exception('No approve link from server');

      // Abrir navegador para que el usuario apruebe
      final uri = Uri.parse(approveLink);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir PayPal');
      }

      // Después que el usuario apruebe, la app debería recibir un callback (deep link) o el usuario retornará.
      // Aquí simple: luego de abrir PayPal esperamos que el usuario confirme y llame capturePayPalOrder desde cliente.
      // En un flujo real deberías usar redirect URLs configuradas y manejarlas en la app.
      // Para simplificar, pedimos al usuario que presione OK para intentar capturar la orden:
      if (!mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Continuar'),
          content: const Text(
            'Después de aprobar el pago en PayPal, presiona Confirmar para completar la captura.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );

      if (ok == true && orderId != null) {
        final capture = functions.httpsCallable('capturePayPalOrder');
        await capture.call({'orderId': orderId});
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const PaymentSuccessScreen(),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PayPal error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }
}
