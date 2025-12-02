import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppLightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      cardColor: AppColors.cardLight,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textLight),
      ),
      dividerColor: AppColors.dividerLight,
    );
  }
}
