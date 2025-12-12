import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';
import 'package:open_finance_data_front/core/theme/themes/app_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_card_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_filter_button_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_header_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_indicator_card_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_search_bar_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_text_theme.dart';

class AppLightTheme {
  
  static ThemeData get theme => AppTheme.light();

  static ThemeData build() {
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
    );

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,

      extensions: const [
        AppCardTheme.light,
        AppFilterButtonTheme.light,
        AppIndicatorCardTheme.light,
        AppCanvasTheme.light,
        AppSearchBarTheme.light,
        AppHeaderTheme.light,
        AppTextTheme.light,
      ],
    );
  }
}
