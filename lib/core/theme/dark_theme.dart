import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      cardColor: AppColors.cardDark,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textDark),
      ),
      dividerColor: AppColors.dividerDark,
    );
  }
}
