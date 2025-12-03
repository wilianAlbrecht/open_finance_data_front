import 'package:flutter/material.dart';
import 'dart:ui';
import '../../app_colors.dart';

class AppCardTheme extends ThemeExtension<AppCardTheme> {
  final Color background;
  final Color borderColor;
  final double radius;

  const AppCardTheme({
    required this.background,
    required this.borderColor,
    required this.radius,
  });

  // Light preset
  static const AppCardTheme light = AppCardTheme(
    background: AppColors.cardLight,
    borderColor: AppColors.dividerLight,
    radius: 16,
  );

  // Dark preset
  static const AppCardTheme dark = AppCardTheme(
    background: AppColors.cardDark,
    borderColor: AppColors.dividerDark,
    radius: 16,
  );

  @override
  AppCardTheme copyWith({
    Color? background,
    Color? borderColor,
    double? radius,
  }) {
    return AppCardTheme(
      background: background ?? this.background,
      borderColor: borderColor ?? this.borderColor,
      radius: radius ?? this.radius,
    );
  }

  @override
  AppCardTheme lerp(covariant ThemeExtension<AppCardTheme>? other, double t) {
    if (other is! AppCardTheme) return this;
    return AppCardTheme(
      background: Color.lerp(background, other.background, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
    );
  }
}
