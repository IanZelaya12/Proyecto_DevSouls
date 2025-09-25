// lib/screens/Reservation/reservation_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sport_filters/widgets/styles.dart';
import '../payment/checkout_screen.dart';
import '../Reservas/reservas.dart';
import 'package:proyecto_devsouls/services/firebase_firestore.dart';

class ReservationScreen extends StatefulWidget {
  final String venueName;
  final double pricePerHour;

  const ReservationScreen({
    super.key,
    required this.venueName,
    required this.pricePerHour,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != selectedDate)
      setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null && picked != selectedTime)
      setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("Reservar", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lugar seleccionado:",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              widget.venueName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Precio: L. ${widget.pricePerHour.toStringAsFixed(2)} por hora",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Selecciona fecha y hora",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate == null
                    ? "Elige una fecha"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
              onTap: _pickDate,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                selectedTime == null
                    ? "Elige una hora"
                    : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
              ),
              onTap: _pickTime,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Por favor selecciona fecha y hora"),
                      ),
                    );
                    return;
                  }

                  final DateTime reservationDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  final String userId = FirebaseAuth.instance.currentUser!.uid;

                  final newReserva = Reserva(
                    id: '',
                    nombre: widget.venueName,
                    fechaHora:
                        '${reservationDateTime.day}/${reservationDateTime.month}/${reservationDateTime.year} a las ${reservationDateTime.hour}:${reservationDateTime.minute.toString().padLeft(2, '0')}',
                    imageUrl: '',
                    hora:
                        '${reservationDateTime.hour}:${reservationDateTime.minute.toString().padLeft(2, '0')}',
                    userId: userId,
                  );

                  // Navegar al checkout y esperar el id de la reserva creado
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        reservationId:
                            'temp_${DateTime.now().millisecondsSinceEpoch}',
                        amountCents: (widget.pricePerHour * 100).toInt(),
                        courtName: widget.venueName,
                        currency: 'HNL',
                        selectedDate:
                            '${reservationDateTime.day}/${reservationDateTime.month}/${reservationDateTime.year}',
                        selectedTime:
                            '${reservationDateTime.hour}:${reservationDateTime.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  );

                  // Si retorna un id de reserva, redirigimos a la pantalla de reservas.
                  if (result != null && result.isNotEmpty) {
                    // La pantalla Reservas usa StreamBuilder y mostrará la nueva reserva automáticamente.
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const ReservasScreen()),
                      (route) => false,
                    );
                  } else {
                    // Si no se creó la reserva (usuario canceló o error), notificar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No se completó la reserva.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Continuar al pago",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
