import 'package:flutter/material.dart';

class AppCanvasLineTheme extends ThemeExtension<AppCanvasLineTheme> {
  final Color lineColor; // <-- required
  final Color shadeColor; // <-- required
  final double lineStrokeWidth;
  final bool smoothCurves;
  final bool showShadedArea;
  final double shadeOpacity;
  final bool showPoints; // <-- required
  final double pointRadius; // <-- required
  final Color pointColor; // <-- required

  const AppCanvasLineTheme({
    required this.lineColor,
    required this.shadeColor,
    required this.lineStrokeWidth,
    required this.smoothCurves,
    required this.showShadedArea,
    required this.shadeOpacity,
    required this.showPoints, // <-- required
    required this.pointRadius, // <-- required
    required this.pointColor, // <-- required
  });

  // LIGHT THEME
  static const light = AppCanvasLineTheme(
    lineColor: Color(0xFF1E88E5),
    shadeColor: Color(0xFF1E88E5),

    lineStrokeWidth: 2.0,
    smoothCurves: true,
    showShadedArea: false,
    shadeOpacity: 0.15,

    showPoints: true,
    pointRadius: 3.0,
    pointColor: Color(0xFF90CAF9),
  );
  // DARK THEME
  static const dark = AppCanvasLineTheme(
    lineColor: Color(0xFF90CAF9),
    shadeColor: Color(0xFF90CAF9),

    lineStrokeWidth: 2.0,
    smoothCurves: true,
    showShadedArea: false,
    shadeOpacity: 0.15,

    showPoints: true,
    pointRadius: 3.0,
    pointColor: Color(0xFF64B5F6),
  );

  @override
  AppCanvasLineTheme copyWith({
    Color? lineColor,
    Color? shadeColor,
    double? lineStrokeWidth,
    bool? smoothCurves,
    bool? showShadedArea,
    double? shadeOpacity,
  }) {
    return AppCanvasLineTheme(
      lineColor: lineColor ?? this.lineColor,
      shadeColor: shadeColor ?? this.shadeColor,
      lineStrokeWidth: lineStrokeWidth ?? this.lineStrokeWidth,
      smoothCurves: smoothCurves ?? this.smoothCurves,
      showShadedArea: showShadedArea ?? this.showShadedArea,
      shadeOpacity: shadeOpacity ?? this.shadeOpacity,
      showPoints: showPoints, // <-- required
      pointRadius: pointRadius, // <-- required
      pointColor: pointColor, // <-- required
    );
  }

  @override
  AppCanvasLineTheme lerp(AppCanvasLineTheme? other, double t) {
    if (other == null) return this;
    return this;
  }
}
