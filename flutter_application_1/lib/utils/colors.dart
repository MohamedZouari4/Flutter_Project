import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryContainer = Color(0xFFDEE8FF);
  static const Color accent = Color(0xFF42A5F5);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F9FC);

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFEAF2FF), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
