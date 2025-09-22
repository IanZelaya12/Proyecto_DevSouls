import 'package:flutter/material.dart'; // <- estaba mal escrito (package.flutter)

class Sport {
  final String name;
  final String imagePath;
  final Color color; // <- dale tipo

  const Sport({
    required this.name,
    required this.imagePath,
    required this.color,
  });
}
