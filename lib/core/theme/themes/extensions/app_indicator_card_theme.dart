import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppIndicatorCardTheme extends ThemeExtension<AppIndicatorCardTheme> {
  final Color background;
  final Color borderColor;
  final EdgeInsets padding;
  final double radius;

  const AppIndicatorCardTheme({
    required this.background,
    required this.borderColor,
    required this.padding,
    required this.radius,
  });

  static const light = AppIndicatorCardTheme(
    background: AppColors.cardLight,
    borderColor: AppColors.dividerLight,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    radius: 12,
  );

  static const dark = AppIndicatorCardTheme(
    background: AppColors.cardDark,
    borderColor: AppColors.dividerDark,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    radius: 12,
  );

  @override
  AppIndicatorCardTheme copyWith({
    Color? background,
    Color? borderColor,
    EdgeInsets? padding,
    double? radius,
  }) {
    return AppIndicatorCardTheme(
      background: background ?? this.background,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      radius: radius ?? this.radius,
    );
  }

  @override
  AppIndicatorCardTheme lerp(ThemeExtension<AppIndicatorCardTheme>? other, double t) {
    if (other is! AppIndicatorCardTheme) return this;

    return AppIndicatorCardTheme(
      background: Color.lerp(background, other.background, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      radius: radius,
    );
  }
}
