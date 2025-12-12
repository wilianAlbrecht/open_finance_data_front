import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppSearchBarTheme extends ThemeExtension<AppSearchBarTheme> {
  final Color background;
  final Color iconColor;
  final Color borderColor;
  final Color focusColor;
  final double radius;
  final EdgeInsets padding;

  const AppSearchBarTheme({
    required this.background,
    required this.iconColor,
    required this.borderColor,
    required this.focusColor,
    required this.radius,
    required this.padding,
  });

  // ======================
  // LIGHT
  // ======================
  static const light = AppSearchBarTheme(
    background: AppColors.cardLight,
    iconColor: AppColors.textLight,
    borderColor: AppColors.dividerLight,
    focusColor: AppColors.primaryLight, // 🔥 ADICIONADO
    radius: 12,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  // ======================
  // DARK
  // ======================
  static const dark = AppSearchBarTheme(
    background: AppColors.cardDark,
    iconColor: AppColors.textDark,
    borderColor: AppColors.dividerDark,
    focusColor: AppColors.primaryDark, // 🔥 ADICIONADO
    radius: 12,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  @override
  AppSearchBarTheme copyWith({
    Color? background,
    Color? iconColor,
    Color? borderColor,
    Color? focusColor,
    double? radius,
    EdgeInsets? padding,
  }) {
    return AppSearchBarTheme(
      background: background ?? this.background,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
      focusColor: focusColor ?? this.focusColor,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
    );
  }

  @override
  AppSearchBarTheme lerp(ThemeExtension<AppSearchBarTheme>? other, double t) {
    if (other is! AppSearchBarTheme) return this;

    return AppSearchBarTheme(
      background: Color.lerp(background, other.background, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      focusColor: Color.lerp(focusColor, other.focusColor, t)!, // 🔥
      radius: lerpDouble(radius, other.radius, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
    );
  }
}
