import 'package:flutter/material.dart';

class AppDesignSystem {
  // --- Colors ---
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF4F46E5); // Deep Indigo
  static const Color secondary = Color(0xFF7C3AED); // Violet
  static const Color accent = Color(0xFF10B981); // Emerald

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color outline = Color(0xFFE5E7EB);

  // --- Gradients ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Card decoration ---
  static BoxDecoration cardDecoration({
    BorderRadius? borderRadius,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      border: Border.all(color: outline, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
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
