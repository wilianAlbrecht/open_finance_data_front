import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';
import 'extensions/app_card_theme.dart';
import 'extensions/app_chart_theme.dart';
import 'extensions/app_chip_theme.dart';

class AppLightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardLight,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),

      cardColor: AppColors.cardLight,

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textLight),
      ),

      dividerColor: AppColors.dividerLight,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: AppLayout.paddingSm,
          shape: RoundedRectangleBorder(borderRadius: AppLayout.radiusSm),
        ),
      ),

      // Extensions
      extensions: [AppChipTheme.light, AppChartTheme.light, AppCardTheme.light],
    );
  }
}
