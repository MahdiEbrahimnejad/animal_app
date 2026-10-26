import 'package:flutter/material.dart';

import '../models/animal_category.dart';

/// Central colors. Bright, friendly and with readable contrast.
abstract final class AppColors {
  static const background = Color(0xFFFFF8E7);
  static const surface = Colors.white;
  static const primary = Color(0xFFFF8A3D);
  static const onPrimary = Color(0xFF3B1E00);
  static const secondary = Color(0xFF3DB2FF);
  static const accent = Color(0xFF7BC74D);
  static const text = Color(0xFF2E2A24);
  static const mutedText = Color(0xFF6B6357);

  static const Map<AnimalCategory, Color> category = {
    AnimalCategory.pets: Color(0xFFFFD6A5),
    AnimalCategory.farm: Color(0xFFFDFFB6),
    AnimalCategory.wild: Color(0xFFCAFFBF),
    AnimalCategory.sea: Color(0xFFA0C4FF),
    AnimalCategory.insects: Color(0xFFFFC6FF),
  };

  static Color forCategory(AnimalCategory c) => category[c] ?? surface;
}

/// Spacing scale and sizes.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Big, toddler-friendly touch target (well above the 48dp minimum).
  static const double kidButton = 76;
  static const double kidButtonLarge = 92;
  static const double radius = 28;
}

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      textTheme: base.textTheme
          .copyWith(
            displayMedium: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          )
          .apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      ),
    );
  }
}
