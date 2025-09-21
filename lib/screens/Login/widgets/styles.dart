// lib/widgets/styles.dart
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
  static const Color errorColor = Color(0xFFD32F2F); // Color para errores
  static const Color successColor = Color(0xFF388E3C); // Color para éxito
}

// Estilos de texto para los diferentes elementos de la UI - ADAPTATIVO
class AppTextStyles {
  // Método para obtener el estilo de título adaptativo
  static TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 40, // Base size, se ajustará en el widget
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 15, 31), // Azul oscuro casi negro
  );

  // Método para obtener título adaptativo basado en el contexto
  static TextStyle getTitleStyle(BuildContext context, {double? customSize}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize;
    if (customSize != null) {
      fontSize = customSize;
    } else if (screenHeight < 600) {
      fontSize = 28;
    } else if (screenWidth < 350) {
      fontSize = 32;
    } else {
      fontSize = 40;
    }

    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 0, 15, 31),
      height: 1.1, // Espaciado de línea más compacto
    );
  }

  static TextStyle subtitleStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle linkTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.linkColor,
  );

  static TextStyle forgotPasswordStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.forgotPasswordColor,
  );

  static TextStyle createAccountStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static TextStyle signUpStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );

  // Estilo para mensajes de error
  static TextStyle errorStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.errorColor,
    fontWeight: FontWeight.w400,
  );
}

// Estilo de los botones - ADAPTATIVO
class AppButtonStyles {
  // Estilo para botones principales - ADAPTATIVO
  static ButtonStyle getMainButtonStyle(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight < 600 ? 12.0 : 14.0;

    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: Size(
        double.infinity,
        screenHeight < 600 ? 48 : 50,
      ), // Altura mínima adaptativa
      elevation: 2,
      shadowColor: AppColors.primaryColor.withOpacity(0.3),
    );
  }

  // Versión estática para compatibilidad
  static ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    minimumSize: Size(double.infinity, 50),
    elevation: 2,
    shadowColor: AppColors.primaryColor.withOpacity(0.3),
  );

  static ButtonStyle linkButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.linkColor,
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

// Estilos personalizados para los campos de texto - MEJORADO
class AppInputDecoration {
  static InputDecoration getInputDecoration({
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelStyle: AppTextStyles.subtitleStyle,
      hintStyle: AppTextStyles.subtitleStyle.copyWith(color: Colors.grey[400]),
      errorStyle: AppTextStyles.errorStyle,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Versión estática para compatibilidad
  static InputDecoration inputDecoration = InputDecoration(
    labelStyle: AppTextStyles.subtitleStyle,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderColor),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderColor),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}

// Widget personalizado para los campos de texto - MEJORADO Y ADAPTATIVO
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Icon? icon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final int? maxLines;

  const AppTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si usar TextFormField (para validación) o TextField
    if (validator != null) {
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: AppInputDecoration.getInputDecoration(
          labelText: label,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          hintText: hintText,
        ),
        style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textColor),
      );
    }

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: AppInputDecoration.getInputDecoration(
        labelText: label,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        hintText: hintText,
      ),
      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textColor),
    );
  }
}

// Contenedor para los íconos de Google, Apple y Facebook - ADAPTATIVO
class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;

  const SocialLoginButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Tamaño adaptativo del botón
    final buttonSize = screenHeight < 600
        ? 50.0
        : (screenWidth < 350 ? 55.0 : 60.0);
    final borderRadius = buttonSize / 2;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        iconSize: buttonSize * 0.4, // Icono proporcional al botón
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        highlightColor: AppColors.primaryColor.withOpacity(0.05),
      ),
    );
  }
}

// Clase de utilidades para spacing adaptativo
class AppSpacing {
  static double getVerticalSpacing(BuildContext context, SpacingSize size) {
    final screenHeight = MediaQuery.of(context).size.height;

    switch (size) {
      case SpacingSize.small:
        return screenHeight < 600 ? 8 : 12;
      case SpacingSize.medium:
        return screenHeight < 600 ? 12 : 16;
      case SpacingSize.large:
        return screenHeight < 600 ? 16 : 24;
      case SpacingSize.extraLarge:
        return screenHeight < 600 ? 20 : 32;
    }
  }

  static double getHorizontalSpacing(BuildContext context, SpacingSize size) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (size) {
      case SpacingSize.small:
        return screenWidth < 350 ? 8 : 12;
      case SpacingSize.medium:
        return screenWidth < 350 ? 12 : 16;
      case SpacingSize.large:
        return screenWidth < 350 ? 16 : 20;
      case SpacingSize.extraLarge:
        return screenWidth < 350 ? 20 : 24;
    }
  }
}

enum SpacingSize { small, medium, large, extraLarge }
