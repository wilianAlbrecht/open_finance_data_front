import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

// Pacote unificado de temas
import 'extensions/app_theme_package.dart';

class AppTheme {
  // ========================
  //        LIGHT THEME
  // ========================
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textLight,
      surface: AppColors.cardLight,
      onSurface: AppColors.textLight,
      error: AppColors.negative,
      onError: Colors.white,
      tertiary: AppColors.headerLight,
      onTertiary: AppColors.textLight,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),

      // 🔥 TEMA UNIFICADO – APENAS ISSO
      extensions: const [
        AppThemePackage.light,
      ],
    );
  }

  // ========================
  //        DARK THEME
  // ========================
  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: Colors.black,
      secondary: AppColors.primaryDark,
      onSecondary: Colors.black,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textDark,
      surface: AppColors.cardDark,
      onSurface: AppColors.textDark,
      error: AppColors.negative,
      onError: Colors.white,
      tertiary: AppColors.headerDark,
      onTertiary: AppColors.textDark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),

      // 🔥 Corrigido — agora o tema dark recebe AppThemePackage.dark
      extensions: const [
        AppThemePackage.dark,
      ],
    );
  }

  // ========================
  //  MODE SYSTEM / SELECTOR
  // ========================
  static ThemeMode fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
