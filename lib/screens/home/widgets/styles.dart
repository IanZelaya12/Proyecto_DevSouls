// lib/screens/home/styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importar Google Fonts

// Colores de la aplicación
class AppColors {
  static const Color primaryColor = Color(0xFF388E3C); // Verde más oscuro
  static const Color buttonColor = Color(0xFF388E3C); // Verde para los botones
  static const Color textColor = Color(0xFF1F1F1F); // Color de texto principal
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Color de fondo claro
  static const Color linkColor = Color(0xFF007BFF); // Color del link (azul)
  static const Color borderColor = Color(
    0xFFDDDDDD,
  ); // Color de bordes de los campos
  static const Color forgotPasswordColor = Color(
    0xFF388E3C,
  ); // Verde para el texto de "Forgot Password?"
  static Color titleColor = Color.fromARGB(
    255,
    0,
    12,
    24,
  ); // Azul oscuro para "Welcome Back!"
}

// Estilos de texto para los diferentes elementos de la UI
class AppTextStyles {
  static TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 40, // Aumentamos el tamaño
    fontWeight: FontWeight.bold,
    color: AppColors.titleColor, // Azul oscuro casi negro
  );

  static TextStyle subtitleStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor, // Color de texto secundario
  );

  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Color blanco para el texto del botón
  );

  static TextStyle linkTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.linkColor, // Color del link
  );

  static TextStyle forgotPasswordStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.forgotPasswordColor, // Color verde
  );

  static TextStyle createAccountStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor, // Color negro
  );

  static TextStyle signUpStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor, // Verde para el "Sign Up"
    decoration: TextDecoration.underline, // Subrayado
  );
}

// Estilo de los botones y otros componentes comunes
class AppButtonStyles {
  // Estilo para botones principales
  static ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor, // Color de fondo
    foregroundColor: Colors.white, // Color del texto
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Estilo para botones secundarios o links
  static ButtonStyle linkButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.linkColor, // Color del texto (link)
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

// Estilos personalizados para los campos de texto
class AppInputDecoration {
  static InputDecoration inputDecoration = InputDecoration(
    labelStyle: AppTextStyles.subtitleStyle, // Estilo del texto de la etiqueta
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderColor),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderColor),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

// Widget personalizado para los campos de texto
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Icon? icon;

  const AppTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: AppInputDecoration.inputDecoration.copyWith(
        labelText: label,
        prefixIcon: icon, // Agregar el icono al principio
      ),
    );
  }
}
