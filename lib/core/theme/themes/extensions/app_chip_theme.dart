import 'package:flutter/material.dart';
import '../../app_colors.dart';

class AppChipTheme extends ThemeExtension<AppChipTheme> {
  final Color selectedBg;
  final Color borderColor;
  final Color labelColor;

  const AppChipTheme({
    required this.selectedBg,
    required this.borderColor,
    required this.labelColor,
  });

  // Light preset
  static const AppChipTheme light = AppChipTheme(
    selectedBg: Color(0x221E88E5), // primary 12%
    borderColor: AppColors.dividerLight,
    labelColor: AppColors.textLightSecondary,
  );

  // Dark preset
  static const AppChipTheme dark = AppChipTheme(
    selectedBg: Color(0x331E88E5), // primary 20%
    borderColor: AppColors.dividerDark,
    labelColor: AppColors.textDarkSecondary,
  );

  @override
  AppChipTheme copyWith({
    Color? selectedBg,
    Color? borderColor,
    Color? labelColor,
  }) {
    return AppChipTheme(
      selectedBg: selectedBg ?? this.selectedBg,
      borderColor: borderColor ?? this.borderColor,
      labelColor: labelColor ?? this.labelColor,
    );
  }

  @override
  AppChipTheme lerp(covariant ThemeExtension<AppChipTheme>? other, double t) {
    if (other is! AppChipTheme) return this;
    return AppChipTheme(
      selectedBg: Color.lerp(selectedBg, other.selectedBg, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
    );
  }
}
