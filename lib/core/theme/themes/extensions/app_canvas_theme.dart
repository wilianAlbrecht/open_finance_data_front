import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppCanvasTheme extends ThemeExtension<AppCanvasTheme> {
  final Color lineColor;
  final Color gridColor;
  final Color axisTextColor;
  final Color openColor;
  final Color highColor;
  final Color lowColor;
  final Color closeColor;
  final Color volumeTopColor;
  final Color volumeBottomColor;

  // ➕ ADICIONADO
  final double widthFactor;  // porcentagem da largura da tela
  final double heightFactor; // porcentagem da altura da tela

  const AppCanvasTheme({
    required this.lineColor,
    required this.gridColor,
    required this.axisTextColor,
    required this.openColor,
    required this.highColor,
    required this.lowColor,
    required this.closeColor,
    required this.volumeTopColor,
    required this.volumeBottomColor,
    this.widthFactor = 0.70,   // padrão 70%
    this.heightFactor = 0.70,  // altura padrão 32%
  });

  static const light = AppCanvasTheme(
    lineColor: AppColors.primaryLight,
    gridColor: AppColors.dividerLight,
    axisTextColor: AppColors.textLightSecondary,
    openColor: AppColors.chartOpen,
    highColor: AppColors.chartHigh,
    lowColor: AppColors.chartLow,
    closeColor: AppColors.chartCloseLight,
    volumeTopColor: AppColors.volumeTopLight,
    volumeBottomColor: AppColors.volumeBottomLight,
    widthFactor: 0.70,
    heightFactor: 0.70,
  );

  static const dark = AppCanvasTheme(
    lineColor: AppColors.primaryDark,
    gridColor: AppColors.dividerDark,
    axisTextColor: AppColors.textDarkSecondary,
    openColor: AppColors.chartOpen,
    highColor: AppColors.chartHigh,
    lowColor: AppColors.chartLow,
    closeColor: AppColors.chartCloseDark,
    volumeTopColor: AppColors.volumeTopDark,
    volumeBottomColor: AppColors.volumeBottomDark,
    widthFactor: 0.70,
    heightFactor: 0.70,
  );

  @override
  AppCanvasTheme copyWith({
    Color? lineColor,
    Color? gridColor,
    Color? axisTextColor,
    Color? openColor,
    Color? highColor,
    Color? lowColor,
    Color? closeColor,
    Color? volumeTopColor,
    Color? volumeBottomColor,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AppCanvasTheme(
      lineColor: lineColor ?? this.lineColor,
      gridColor: gridColor ?? this.gridColor,
      axisTextColor: axisTextColor ?? this.axisTextColor,
      openColor: openColor ?? this.openColor,
      highColor: highColor ?? this.highColor,
      lowColor: lowColor ?? this.lowColor,
      closeColor: closeColor ?? this.closeColor,
      volumeTopColor: volumeTopColor ?? this.volumeTopColor,
      volumeBottomColor: volumeBottomColor ?? this.volumeBottomColor,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AppCanvasTheme lerp(ThemeExtension<AppCanvasTheme>? other, double t) {
    if (other is! AppCanvasTheme) return this;

    return AppCanvasTheme(
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
      gridColor: Color.lerp(gridColor, other.gridColor, t)!,
      axisTextColor: Color.lerp(axisTextColor, other.axisTextColor, t)!,
      openColor: Color.lerp(openColor, other.openColor, t)!,
      highColor: Color.lerp(highColor, other.highColor, t)!,
      lowColor: Color.lerp(lowColor, other.lowColor, t)!,
      closeColor: Color.lerp(closeColor, other.closeColor, t)!,
      volumeTopColor: Color.lerp(volumeTopColor, other.volumeTopColor, t)!,
      volumeBottomColor: Color.lerp(volumeBottomColor, other.volumeBottomColor, t)!,
      widthFactor: lerpDouble(widthFactor, other.widthFactor, t)!,
      heightFactor: lerpDouble(heightFactor, other.heightFactor, t)!,
    );
  }
}
