import 'package:flutter/material.dart';

class AppDesignSystem {
  // --- Colors ---
  static const Color background = Color(0xFFF2F0EB); // warm cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF111111); // near-black
  static const Color secondary = Color(0xFF444444);
  static const Color accent = Color(0xFF111111);

  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF888888);
  static const Color outline = Color(0xFFD0CFC9);

  // --- "Gradient" (now a flat black fill) ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Card decoration (sharp corners, no shadow) ---
  static BoxDecoration cardDecoration({
    BorderRadius? borderRadius,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: borderRadius ?? BorderRadius.zero,
      border: Border.all(color: outline, width: 1.5),
    );
  }

  // --- Accent left-border decoration ---
  static BoxDecoration accentLeftBorder({Color? bg}) {
    return BoxDecoration(
      color: bg ?? surface,
      border: const Border(
        left: BorderSide(color: primary, width: 4),
        top: BorderSide(color: outline, width: 1),
        right: BorderSide(color: outline, width: 1),
        bottom: BorderSide(color: outline, width: 1),
      ),
    );
  }

  // --- Typography ---
  static TextStyle headline(BuildContext context) => const TextStyle(
    color: textPrimary,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static TextStyle body(BuildContext context) => const TextStyle(
    color: textSecondary,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle label() => const TextStyle(
    color: textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
  );
}
