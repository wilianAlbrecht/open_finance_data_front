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

class AppDarkTheme {

  static ThemeData get theme => AppTheme.dark();
  
  static ThemeData build() {
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
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,

      extensions: const [
        AppCardTheme.dark,
        AppFilterButtonTheme.dark,
        AppIndicatorCardTheme.dark,
        AppCanvasTheme.dark,
        AppSearchBarTheme.dark,
        AppHeaderTheme.dark,
        AppTextTheme.dark,
      ],
    );
  }
}
