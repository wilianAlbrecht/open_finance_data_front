import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppHeaderTheme extends ThemeExtension<AppHeaderTheme> {
  final Color background;
  final Color titleColor;
  final double height;

  const AppHeaderTheme({
    required this.background,
    required this.titleColor,
    required this.height,
  });

  static const light = AppHeaderTheme(
    background: AppColors.headerLight,
    titleColor: AppColors.textLight,
    height: 56,
  );

  static const dark = AppHeaderTheme(
    background: AppColors.headerDark,
    titleColor: AppColors.textDark,
    height: 56,
  );

  @override
  AppHeaderTheme copyWith({
    Color? background,
    Color? titleColor,
    double? height,
  }) {
    return AppHeaderTheme(
      background: background ?? this.background,
      titleColor: titleColor ?? this.titleColor,
      height: height ?? this.height,
    );
  }

  @override
  AppHeaderTheme lerp(ThemeExtension<AppHeaderTheme>? other, double t) {
    if (other is! AppHeaderTheme) return this;

    return AppHeaderTheme(
      background: Color.lerp(background, other.background, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      height: height,
    );
  }
}
