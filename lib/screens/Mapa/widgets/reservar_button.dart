import 'package:flutter/material.dart';

class ReservarButton extends StatelessWidget {
  final VoidCallback onTap;
  const ReservarButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('Ver detalles / Reservar'),
      ),
    );
  }
}
