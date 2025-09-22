import 'package:flutter/material.dart';

class ReservarButton extends StatelessWidget {
  final VoidCallback onTap;
  
  const ReservarButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      constraints: BoxConstraints(
        maxWidth: isTablet ? 600 : double.infinity,
      ),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 20 : 16,
            horizontal: isTablet ? 24 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
          ),
          elevation: 2,
          shadowColor: Colors.black26,
        ),
        child: Text(
          'Ver detalles / Reservar',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}