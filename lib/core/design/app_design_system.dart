import 'package:flutter/material.dart';

class AppDesignSystem {
  // --- Colors ---
  static const Color background = Color(0xFFFDFCF9); 
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF2D3436); 
  static const Color accent = Color(0xFF00B894); 
  static const Color mintLight = Color(0xFFA0E8D1);
  static const Color orangeLight = Color(0xFFFED391);
  static const Color charcoal = Color(0xFF2D3436);
  static const Color highlight = Color(0xFFFAB1A0);

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF55E6C1), Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient scanCardGradient = LinearGradient(
    colors: [Color(0xFFE8F9F3), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);

  // --- Card decoration (Organic, soft shadows, no sharp borders) ---
  static BoxDecoration cardDecoration({
    BorderRadius? borderRadius,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: borderRadius ?? BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          color: primary.withValues(alpha: 0.05),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // --- Floating action item decoration ---
  static BoxDecoration floatingItemDecoration({Color? bg}) {
    return BoxDecoration(
      color: bg ?? surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(32),
      ),
      boxShadow: [
        BoxShadow(
          color: primary.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // --- Typography ---
  static TextStyle headline(BuildContext context) => TextStyle(
    color: textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    fontFamily: 'Outfit', // Note: User might need to add this to pubspec
  );

  static TextStyle body(BuildContext context) => const TextStyle(
    color: textSecondary,
    fontSize: 15,
    height: 1.6,
    letterSpacing: 0.2,
  );

  static TextStyle label() => const TextStyle(
    color: textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    textBaseline: TextBaseline.alphabetic,
  );
}
