import 'package:flutter/material.dart';

class AppCanvasBarTheme extends ThemeExtension<AppCanvasBarTheme> {
  final Color barColor;          // cor principal da barra
  final double barWidth;
  final BorderRadius barRadius;

  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const AppCanvasBarTheme({
    required this.barColor,
    required this.barWidth,
    required this.barRadius,
    required this.showBorder,
    required this.borderColor,
    required this.borderWidth,
  });

  // LIGHT THEME
  static const light = AppCanvasBarTheme(
    barColor: Color(0xFF1E88E5), // azul primário (pode ajustar depois)
    barWidth: 6,
    barRadius: BorderRadius.vertical(top: Radius.circular(4)),
    showBorder: false,
    borderColor: null,
    borderWidth: 1.0,
  );

  // DARK THEME
  static const dark = AppCanvasBarTheme(
    barColor: Color(0xFF90CAF9),
    barWidth: 6,
    barRadius: BorderRadius.vertical(top: Radius.circular(4)),
    showBorder: false,
    borderColor: null,
    borderWidth: 1.0,
  );

  @override
  AppCanvasBarTheme copyWith({
    Color? barColor,
    double? barWidth,
    BorderRadius? barRadius,
    bool? showBorder,
    Color? borderColor,
    double? borderWidth,
  }) {
    return AppCanvasBarTheme(
      barColor: barColor ?? this.barColor,
      barWidth: barWidth ?? this.barWidth,
      barRadius: barRadius ?? this.barRadius,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  AppCanvasBarTheme lerp(AppCanvasBarTheme? other, double t) {
    if (other == null) return this;
    return this;
  }
}
