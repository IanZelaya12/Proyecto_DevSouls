import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'payment_success_screen.dart';
import '../Perfil/editar_perfil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Controladores para los campos de la tarjeta
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // Controladores para otros métodos de pago
  final _paypalEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPaying = false;
  bool _hasBankInfo = false;
  bool _hasPaymentInfo = false;
  PaymentMethodType _method = PaymentMethodType.stripeCard;
  bool _acceptedTerms = false;
  bool _saveCardInfo = false;

  String get _amountFormatted {
    final f = NumberFormat.simpleCurrency(name: widget.currency);
    return f.format(widget.amountCents / 100);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _paypalEmailController.dispose();
    super.dispose();
  }

  // Método para cargar los datos desde Firestore
  Future<void> _loadPaymentMethods() async {
    final uid = _auth.currentUser!.uid;

    try {
      final userDoc = await _db.collection('users').doc(uid).get();
      final userData = userDoc.data();

      if (userData != null) {
        setState(() {
          // Verificar información bancaria existente
          _hasBankInfo =
              userData['bankAccountNumber'] != null &&
              userData['accountHolder'] != null;

          // Verificar todos los métodos de pago disponibles
          bool hasCardInfo =
              userData['cardHolder'] != null && userData['cardExpiry'] != null;
          bool hasPayPal = userData['paypalEmail'] != null;
          bool hasApplePay = userData['applePay'] == true;

          _hasPaymentInfo =
              _hasBankInfo || hasCardInfo || hasPayPal || hasApplePay;
        });

        // Cargar datos guardados de tarjeta si existen
        if (userData['cardHolder'] != null) {
          _cardHolderController.text = userData['cardHolder'];
        }
        if (userData['cardExpiry'] != null) {
          _expiryController.text = userData['cardExpiry'];
        }
        // Mostrar solo los últimos 4 dígitos como placeholder si existen
        if (userData['cardLastFour'] != null) {
          _cardNumberController.text =
              '**** **** **** ${userData['cardLastFour']}';
        }
        // Cargar email de PayPal si existe
        if (userData['paypalEmail'] != null) {
          _paypalEmailController.text = userData['paypalEmail'];
        }
      }
    } catch (e) {
      print('Error cargando métodos de pago: $e');
      _snack('Error cargando información de pago');
    }
  }

  // Verificar y procesar el pago
  Future<void> _processPayment() async {
    if (!_acceptedTerms) {
      _snack('Debes aceptar los términos y condiciones.');
      return;
    }

    // Validar formulario según el método seleccionado
    if (!_formKey.currentState!.validate()) {
      _snack('Por favor completa todos los campos requeridos.');
      return;
    }

    setState(() => _isPaying = true);

    try {
      // Guardar información según el método de pago si el usuario lo solicitó
      if (_saveCardInfo) {
        await _savePaymentInfoToFirestore();
      }

      // Aquí integrarías con Stripe, PayPal, etc. según el método seleccionado
      await _processPaymentByMethod();

      if (!mounted) return;

      // Registrar el pago en Firestore
      await _recordPaymentInFirestore();

      // Mostrar el diálogo de éxito
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PaymentSuccessScreen(onContinue: _goHome),
      );

      // Notificación de pago exitoso
      await _showPaymentNotification(
        widget.reservationId,
        _amountFormatted,
        widget.courtName,
      );
    } catch (e) {
      _snack('Error al procesar el pago: $e');
      print('Error en processPayment: $e');
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  // Procesar pago según el método seleccionado
  Future<void> _processPaymentByMethod() async {
    switch (_method) {
      case PaymentMethodType.stripeCard:
        // Aquí integrarías con Stripe SDK
        await _processStripePayment();
        break;
      case PaymentMethodType.paypal:
        // Aquí integrarías con PayPal SDK
        await _processPayPalPayment();
        break;
      case PaymentMethodType.applePay:
        // Aquí integrarías con Apple Pay
        await _processApplePayPayment();
        break;
    }
  }

  Future<void> _processStripePayment() async {
    // Simulación - aquí usarías Stripe SDK
    await Future.delayed(const Duration(milliseconds: 800));
    print('Procesando pago con Stripe...');
    // TODO: Implementar integración real con Stripe
  }

  Future<void> _processPayPalPayment() async {
    // Simulación - aquí usarías PayPal SDK
    await Future.delayed(const Duration(milliseconds: 600));
    print('Procesando pago con PayPal...');
    // TODO: Implementar integración real con PayPal
  }

  Future<void> _processApplePayPayment() async {
    // Simulación - aquí usarías Apple Pay
    await Future.delayed(const Duration(milliseconds: 400));
    print('Procesando pago con Apple Pay...');
    // TODO: Implementar integración real con Apple Pay
  }

  // Registrar el pago exitoso en Firestore
  Future<void> _recordPaymentInFirestore() async {
    final uid = _auth.currentUser!.uid;

    try {
      // Crear registro del pago
      await _db.collection('payments').add({
        'userId': uid,
        'reservationId': widget.reservationId,
        'amount': widget.amountCents,
        'currency': widget.currency,
        'courtName': widget.courtName,
        'paymentMethod': _method.toString().split('.').last,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Actualizar la reserva como pagada
      await _db.collection('reservations').doc(widget.reservationId).update({
        'paymentStatus': 'paid',
        'paymentCompletedAt': FieldValue.serverTimestamp(),
        'paymentMethod': _method.toString().split('.').last,
      });

      print('Pago registrado exitosamente en Firestore');
    } catch (e) {
      print('Error registrando pago: $e');
      // No mostramos error al usuario porque el pago ya se procesó
    }
  }

  // Guardar información de pago en Firestore según el método
  Future<void> _savePaymentInfoToFirestore() async {
    final uid = _auth.currentUser!.uid;

    try {
      Map<String, dynamic> updateData = {
        'paymentMethodUpdated': FieldValue.serverTimestamp(),
      };

      switch (_method) {
        case PaymentMethodType.stripeCard:
          final cardNumber = _cardNumberController.text.replaceAll(' ', '');
          final lastFour = cardNumber.length >= 4
              ? cardNumber.substring(cardNumber.length - 4)
              : '';

          updateData.addAll({
            'cardHolder': _cardHolderController.text.trim(),
            'cardExpiry': _expiryController.text.trim(),
            'cardLastFour': lastFour,
            'hasCardInfo': true,
          });
          break;

        case PaymentMethodType.paypal:
          updateData.addAll({
            'paypalEmail': _paypalEmailController.text.trim(),
            'hasPayPalInfo': true,
          });
          break;

        case PaymentMethodType.applePay:
          updateData.addAll({'applePay': true, 'hasApplePayInfo': true});
          break;
      }

      await _db.collection('users').doc(uid).update(updateData);
      print('Información de pago guardada exitosamente');
    } catch (e) {
      print('Error guardando información de pago: $e');
      _snack('Error guardando información de pago');
    }
  }

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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
            child: const Text('Ir a Editar Perfil'),
          ),
        ],
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
  }

  Future<void> _showPaymentNotification(
    String reservationId,
    String amount,
    String courtName,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'payment_channel',
          'Payment Notifications',
          importance: Importance.high,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Pago Confirmado',
      'Reserva #$reservationId en $courtName por $amount ha sido completado.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
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
                  onTap: () =>
                      setState(() => _method = PaymentMethodType.paypal),
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

                // Formularios según el método de pago seleccionado
                if (_method == PaymentMethodType.stripeCard) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información de la tarjeta',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Número de tarjeta
                          TextFormField(
                            controller: _cardNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Número de tarjeta',
                              hintText: '1234 5678 9012 3456',
                              prefixIcon: Icon(Icons.credit_card),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              _CardNumberInputFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el número de tarjeta';
                              }
                              if (value.replaceAll(' ', '').length < 13) {
                                return 'Número de tarjeta inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Nombre del titular
                          TextFormField(
                            controller: _cardHolderController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del titular',
                              hintText: 'Como aparece en la tarjeta',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el nombre del titular';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Fecha de vencimiento y CVV
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _expiryController,
                                  decoration: const InputDecoration(
                                    labelText: 'MM/AA',
                                    hintText: '12/28',
                                    prefixIcon: Icon(Icons.calendar_month),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _ExpiryDateInputFormatter(),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fecha requerida';
                                    }
                                    if (value.length < 5) {
                                      return 'Formato: MM/AA';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  decoration: const InputDecoration(
                                    labelText: 'CVV',
                                    hintText: '123',
                                    prefixIcon: Icon(Icons.security),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'CVV requerido';
                                    }
                                    if (value.length < 3) {
                                      return 'CVV inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Guardar información de la tarjeta
                          CheckboxListTile(
                            value: _saveCardInfo,
                            onChanged: (value) =>
                                setState(() => _saveCardInfo = value ?? false),
                            title: const Text(
                              'Guardar información para futuros pagos',
                            ),
                            subtitle: const Text(
                              'Solo se guardará información básica de forma segura',
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (_method == PaymentMethodType.paypal) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Información de PayPal',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Email de PayPal
                          TextFormField(
                            controller: _paypalEmailController,
                            decoration: const InputDecoration(
                              labelText: 'Email de PayPal',
                              hintText: 'tu-email@ejemplo.com',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                              helperText:
                                  'Ingresa el email asociado a tu cuenta PayPal',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu email de PayPal';
                              }
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Ingresa un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Información adicional
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Serás redirigido a PayPal para completar el pago de forma segura.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Guardar información
                          CheckboxListTile(
                            value: _saveCardInfo,
                            onChanged: (value) =>
                                setState(() => _saveCardInfo = value ?? false),
                            title: const Text(
                              'Guardar email para futuros pagos',
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (_method == PaymentMethodType.applePay) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone_iphone,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Apple Pay',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Información sobre Apple Pay
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  size: 48,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Pago rápido y seguro',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Usa Touch ID, Face ID o tu código de acceso para autorizar el pago.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Estado de disponibilidad
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Apple Pay está disponible en este dispositivo',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

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
                    'Tu pago es seguro y está encriptado.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ],
            ),
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

// Formateador para número de tarjeta (agregar espacios)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formateador para fecha de vencimiento (MM/AA)
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
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
