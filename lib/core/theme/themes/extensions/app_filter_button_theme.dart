import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppFilterButtonTheme extends ThemeExtension<AppFilterButtonTheme> {
  final Color background;
  final Color borderColor;
  final Color selectedBackground;
  final Color selectedTextColor;
  final Color textColor;
  final double radius;
  final EdgeInsets padding;
  final double horizontalGapFactor;
  final double minGap;
  final double maxGap;

  // 🔥 Getters adicionais para compatibilidade com o RangeFilterBar
  Color get selectedBg => selectedBackground;
  Color get selectedBorder => selectedBackground; // ou borderColor, sua escolha
  Color get labelColor => textColor;
  Color get selectedLabelColor => selectedTextColor;

  const AppFilterButtonTheme({
    required this.background,
    required this.borderColor,
    required this.selectedBackground,
    required this.textColor,
    required this.selectedTextColor,
    required this.radius,
    required this.padding,
    this.horizontalGapFactor = 0.05,
    this.minGap = 8.0,
    this.maxGap = 24.0,
  });

  static const light = AppFilterButtonTheme(
    background: AppColors.cardLight,
    borderColor: AppColors.dividerLight,
    // selectedBackground: AppColors.primaryLight,
    selectedBackground: AppColors.primaryButton,
    textColor: AppColors.textLight,
    selectedTextColor: Colors.black,
    radius: 12,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    horizontalGapFactor : 0.05,
    minGap : 8.0,
    maxGap : 24.0,
  );

  static const dark = AppFilterButtonTheme(
    background: AppColors.cardDark,
    borderColor: AppColors.dividerDark,
    // selectedBackground: AppColors.primaryDark,
    // selectedBackground: Colors.purple,
    selectedBackground: AppColors.primaryButton,
    textColor: AppColors.textDark,
    selectedTextColor: Colors.white,
    radius: 12,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    horizontalGapFactor : 0.05,
    minGap : 8.0,
    maxGap : 24.0,
  );

  @override
  AppFilterButtonTheme copyWith({
    Color? background,
    Color? borderColor,
    Color? selectedBackground,
    Color? selectedTextColor,
    Color? textColor,
    double? radius,
    EdgeInsets? padding,
  }) {
    return AppFilterButtonTheme(
      background: background ?? this.background,
      borderColor: borderColor ?? this.borderColor,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      textColor: textColor ?? this.textColor,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
    );
  }

  @override
  AppFilterButtonTheme lerp(ThemeExtension<AppFilterButtonTheme>? other, double t) {
    if (other is! AppFilterButtonTheme) return this;

    return AppFilterButtonTheme(
      background: Color.lerp(background, other.background, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      selectedBackground: Color.lerp(selectedBackground, other.selectedBackground, t)!,
      selectedTextColor: Color.lerp(selectedTextColor, other.selectedTextColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      radius: radius,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
    );
  }
}
