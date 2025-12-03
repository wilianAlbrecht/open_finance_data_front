import 'package:flutter/material.dart';
import '../../app_colors.dart';

class AppChartTheme extends ThemeExtension<AppChartTheme> {
  final Color gridColor;
  final Color closeColor;
  final Color openColor;
  final Color highColor;
  final Color lowColor;

  const AppChartTheme({
    required this.gridColor,
    required this.closeColor,
    required this.openColor,
    required this.highColor,
    required this.lowColor,
  });

  // Light preset
  static final AppChartTheme light = AppChartTheme(
    gridColor: AppColors.dividerLight,
    closeColor: AppColors.primary,
    openColor: Colors.orange,
    highColor: Colors.green,
    lowColor: Colors.red,
  );

  // Dark preset
  static final AppChartTheme dark = AppChartTheme(
    gridColor: AppColors.dividerDark,
    closeColor: AppColors.primary,
    openColor: Colors.orange,
    highColor: Colors.green,
    lowColor: Colors.red,
  );

  @override
  AppChartTheme copyWith({
    Color? gridColor,
    Color? closeColor,
    Color? openColor,
    Color? highColor,
    Color? lowColor,
  }) {
    return AppChartTheme(
      gridColor: gridColor ?? this.gridColor,
      closeColor: closeColor ?? this.closeColor,
      openColor: openColor ?? this.openColor,
      highColor: highColor ?? this.highColor,
      lowColor: lowColor ?? this.lowColor,
    );
  }

  @override
  AppChartTheme lerp(covariant ThemeExtension<AppChartTheme>? other, double t) {
    if (other is! AppChartTheme) return this;
    return AppChartTheme(
      gridColor: Color.lerp(gridColor, other.gridColor, t)!,
      closeColor: Color.lerp(closeColor, other.closeColor, t)!,
      openColor: Color.lerp(openColor, other.openColor, t)!,
      highColor: Color.lerp(highColor, other.highColor, t)!,
      lowColor: Color.lerp(lowColor, other.lowColor, t)!,
    );
  }
}
