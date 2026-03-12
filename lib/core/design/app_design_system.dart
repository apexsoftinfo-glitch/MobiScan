import 'package:flutter/material.dart';
import 'dart:ui';

class AppDesignSystem {
  // --- Colors ---
  static const Color background = Color(0xFF0D0D12);
  static const Color surface = Color(0xFF1C1C23);
  static const Color primary = Color(0xFF6366F1); // Modern Indigo
  static const Color secondary = Color(0xFFA855F7); // Purple
  static const Color accent = Color(0xFF10B981); // Emerald
  
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color outline = Color(0xFF2D2D35);

  // --- Gradients ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Glassmorphism ---
  static Widget glassEffect({
    required Widget child,
    double blur = 10,
    double opacity = 0.1,
    Color color = Colors.white,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: color.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // --- Typography ---
  static TextStyle headline(BuildContext context) => const TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle body(BuildContext context) => const TextStyle(
    color: textSecondary,
    fontSize: 14,
    height: 1.5,
  );
}
