import 'package:flutter/material.dart';

// Shared colors, text styles and spacing.
// Same values as the Task List screen so every tab looks the same.

class AppColors {
  static const Color primary = Color(0xFF3D5AFE);
  static const Color primaryLight = Color(0xFFE8EBFF);
  static const Color background = Color(0xFFF6F7FB);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF1C1C28);
  static const Color textGrey = Color(0xFF7A7A8C);
  static const Color border = Color(0xFFE2E3EC);
  static const Color red = Color(0xFFE53935);
  static const Color orange = Color(0xFFFB8C00);
  static const Color green = Color(0xFF43A047);
}

class AppText {
  static const TextStyle title = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle section = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle label = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGrey);
  static const TextStyle cardTitle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const TextStyle small =
      TextStyle(fontSize: 13, color: AppColors.textGrey);
  static const TextStyle body =
      TextStyle(fontSize: 15, color: AppColors.textDark, height: 1.4);
  static const TextStyle error = TextStyle(fontSize: 12, color: AppColors.red);
}

class AppSpacing {
  static const double xs = 4, sm = 8, md = 16, lg = 24;
  static const double page = 20, radius = 14;
}

// Card border used by all list cards.
RoundedRectangleBorder appCardShape() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      side: const BorderSide(color: AppColors.border),
    );

// Input box decoration used by the forms.
InputDecoration appInputDecoration({String? hint, Widget? prefixIcon}) =>
    InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
