// File: lib/utils/colors.dart
// Centralized color constants and gradients used across the UI.

import 'package:flutter/material.dart';

/// Central color palette for the app.
class AppColors {
  /// Primary brand color
  static const Color primary = Color(0xFF1E3A8A);

  /// Subtle primary container used for chips and badges
  static const Color primaryContainer = Color(0xFFDEE8FF);

  /// Accent color used for highlights
  static const Color accent = Color(0xFF42A5F5);

  /// Success/positive color
  static const Color success = Color(0xFF2E7D32);

  /// Warning color
  static const Color warning = Color(0xFFF9A825);

  /// Card surface color
  static const Color surface = Color(0xFFFFFFFF);

  /// App background color
  static const Color background = Color(0xFFF7F9FC);

  /// Reusable gradient for cards
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFEAF2FF), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
