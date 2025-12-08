import 'package:flutter/material.dart';

class AppCanvasBaseTheme extends ThemeExtension<AppCanvasBaseTheme> {
  // ----- Eixos & Grid -----
  final Color axisColor;
  final Color gridColor;
  final double axisStrokeWidth;
  final double gridStrokeWidth;

  // ----- Estilos de texto -----
  final TextStyle labelStyle;
  final TextStyle tooltipStyle;

  // ----- Hover -----
  final Color hoverLineColor;
  final double hoverLineWidth;
  final Color hoverPointColor;
  final double hoverPointRadius;

  // ----- Cores das séries -----
  final Color openColor;
  final Color highColor;
  final Color lowColor;
  final Color closeColor;

  // ----- Layout comum -----
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double heightFactor; // porcentagem da altura da tela
  final double widthFactor; // porcentagem da largura da tela

  const AppCanvasBaseTheme({
    required this.axisColor,
    required this.gridColor,
    required this.axisStrokeWidth,
    required this.gridStrokeWidth,
    required this.labelStyle,
    required this.tooltipStyle,
    required this.hoverLineColor,
    required this.hoverLineWidth,
    required this.hoverPointColor,
    required this.hoverPointRadius,
    required this.openColor,
    required this.highColor,
    required this.lowColor,
    required this.closeColor,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.heightFactor,
    required this.widthFactor,
  });

  // ---------------- LIGHT ----------------
  static final AppCanvasBaseTheme light = AppCanvasBaseTheme(
    axisColor: Color(0xFF9E9E9E),
    gridColor: Color(0xFFE0E0E0),
    axisStrokeWidth: 1.2,
    gridStrokeWidth: 0.8,

    labelStyle: TextStyle(fontSize: 11, color: Color(0xFF1A1A1A)),
    tooltipStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),

    hoverLineColor: Color(0xFF1E88E5),
    hoverLineWidth: 1.5,
    hoverPointColor: Color(0xFF1E88E5),
    hoverPointRadius: 4,

    openColor: Color(0xFFFBC02D),
    highColor: Color(0xFF4CAF50),
    lowColor: Color(0xFFE53935),
    closeColor: Color(0xFF1E88E5),

    paddingLeft: 48,
    paddingRight: 20,
    paddingTop: 16,
    paddingBottom: 28,

    heightFactor: 0.60, // 60%
    widthFactor: 0.70, // 70%
  );

  // ---------------- DARK ----------------
  static final AppCanvasBaseTheme dark = AppCanvasBaseTheme(
    axisColor: Color(0xFF9E9E9E),
    gridColor: Color(0xFF2A2A2A),
    axisStrokeWidth: 1.2,
    gridStrokeWidth: 0.8,

    labelStyle: TextStyle(fontSize: 11, color: Color(0xFFEAEAEA)),
    tooltipStyle: TextStyle(fontSize: 12, color: Colors.black),

    hoverLineColor: Color(0xFF64B5F6),
    hoverLineWidth: 1.5,
    hoverPointColor: Color(0xFF64B5F6),
    hoverPointRadius: 4,

    openColor: Color(0xFFFBC02D),
    highColor: Color(0xFF4CAF50),
    lowColor: Color(0xFFE53935),
    closeColor: Color(0xFF1E88E5),

    paddingLeft: 48,
    paddingRight: 20,
    paddingTop: 16,
    paddingBottom: 28,

    heightFactor: 0.60, // 60%
    widthFactor: 0.70, // 70%
  );

  @override
  AppCanvasBaseTheme copyWith({
    Color? axisColor,
    Color? gridColor,
    double? axisStrokeWidth,
    double? gridStrokeWidth,
    TextStyle? labelStyle,
    TextStyle? tooltipStyle,
    Color? hoverLineColor,
    double? hoverLineWidth,
    Color? hoverPointColor,
    double? hoverPointRadius,
    Color? openColor,
    Color? highColor,
    Color? lowColor,
    Color? closeColor,
    double? paddingLeft,
    double? paddingRight,
    double? paddingTop,
    double? paddingBottom,
  }) {
    return AppCanvasBaseTheme(
      axisColor: axisColor ?? this.axisColor,
      gridColor: gridColor ?? this.gridColor,
      axisStrokeWidth: axisStrokeWidth ?? this.axisStrokeWidth,
      gridStrokeWidth: gridStrokeWidth ?? this.gridStrokeWidth,
      labelStyle: labelStyle ?? this.labelStyle,
      tooltipStyle: tooltipStyle ?? this.tooltipStyle,
      hoverLineColor: hoverLineColor ?? this.hoverLineColor,
      hoverLineWidth: hoverLineWidth ?? this.hoverLineWidth,
      hoverPointColor: hoverPointColor ?? this.hoverPointColor,
      hoverPointRadius: hoverPointRadius ?? this.hoverPointRadius,
      openColor: openColor ?? this.openColor,
      highColor: highColor ?? this.highColor,
      lowColor: lowColor ?? this.lowColor,
      closeColor: closeColor ?? this.closeColor,
      paddingLeft: paddingLeft ?? this.paddingLeft,
      paddingRight: paddingRight ?? this.paddingRight,
      paddingTop: paddingTop ?? this.paddingTop,
      paddingBottom: paddingBottom ?? this.paddingBottom,
      heightFactor: heightFactor ?? this.heightFactor,
      widthFactor: widthFactor ?? this.widthFactor,
    );
  }

  @override
  ThemeExtension<AppCanvasBaseTheme> lerp(
    ThemeExtension<AppCanvasBaseTheme>? other,
    double t,
  ) {
    if (other is! AppCanvasBaseTheme) return this;
    return this;
  }
}
