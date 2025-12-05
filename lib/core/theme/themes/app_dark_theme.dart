import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_bar_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_base_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_line_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_card_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_page_layout_theme.dart';

import '../app_colors.dart';
import 'extensions/app_chart_theme.dart';
import 'extensions/app_chip_theme.dart';

class AppDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),

      cardColor: AppColors.cardDark,

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textDark),
      ),

      dividerColor: AppColors.dividerDark,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          padding: AppLayout.paddingSm,
          shape: RoundedRectangleBorder(borderRadius: AppLayout.radiusSm),
        ),
      ),

      // Extensions
      extensions: [
        AppChipTheme.dark,
        AppChartTheme.dark,
        AppPageLayoutTheme.dark,
        AppCanvasBaseTheme.dark,
        AppCanvasLineTheme.dark,
        AppCanvasBarTheme.dark,
        AppCardTheme.dark,
      ],
    );
  }
}
