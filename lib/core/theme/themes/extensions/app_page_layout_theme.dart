import 'package:flutter/material.dart';
import 'dart:ui';

class AppPageLayoutTheme extends ThemeExtension<AppPageLayoutTheme> {
  final double maxContentWidth;
  final EdgeInsets pagePadding;
  final bool centerContent;

  /// Quando true → página ocupa 100% da largura disponível
  final bool fullWidth;

  const AppPageLayoutTheme({
    required this.maxContentWidth,
    required this.pagePadding,
    required this.centerContent,
    required this.fullWidth,
  });

  /// 🔥 PADRÃO GLOBAL = LAYOUT 100% SEM CENTRALIZAR
  static const AppPageLayoutTheme light = AppPageLayoutTheme(
    maxContentWidth: double.infinity,
    pagePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    centerContent: false,
    fullWidth: true,
  );

  static const AppPageLayoutTheme dark = AppPageLayoutTheme(
    maxContentWidth: double.infinity,
    pagePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    centerContent: false,
    fullWidth: true,
  );

  @override
  AppPageLayoutTheme copyWith({
    double? maxContentWidth,
    EdgeInsets? pagePadding,
    bool? centerContent,
    bool? fullWidth,
  }) {
    return AppPageLayoutTheme(
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      pagePadding: pagePadding ?? this.pagePadding,
      centerContent: centerContent ?? this.centerContent,
      fullWidth: fullWidth ?? this.fullWidth,
    );
  }

  @override
  AppPageLayoutTheme lerp(ThemeExtension<AppPageLayoutTheme>? other, double t) {
    if (other is! AppPageLayoutTheme) return this;

    return AppPageLayoutTheme(
      maxContentWidth: lerpDouble(maxContentWidth, other.maxContentWidth, t)!,
      pagePadding: EdgeInsets.lerp(pagePadding, other.pagePadding, t)!,
      centerContent: other.centerContent,
      fullWidth: other.fullWidth,
    );
  }
}
