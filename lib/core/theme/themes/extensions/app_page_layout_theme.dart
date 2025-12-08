import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/material.dart';


class AppPageLayoutTheme extends ThemeExtension<AppPageLayoutTheme> {
  final double maxContentWidth;
  final EdgeInsets pagePadding;
  final bool centerContent;

  const AppPageLayoutTheme({
    required this.maxContentWidth,
    required this.pagePadding,
    required this.centerContent,
  });

  // Tema para modo claro
  static const AppPageLayoutTheme light = AppPageLayoutTheme(
    maxContentWidth: 1600,
    pagePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    centerContent: true,
  );

  // Tema para modo escuro
  static const AppPageLayoutTheme dark = AppPageLayoutTheme(
    maxContentWidth: 1500,
    pagePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    centerContent: true,
  );

  @override
  AppPageLayoutTheme copyWith({
    double? maxContentWidth,
    EdgeInsets? pagePadding,
    bool? centerContent,
  }) {
    return AppPageLayoutTheme(
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      pagePadding: pagePadding ?? this.pagePadding,
      centerContent: centerContent ?? this.centerContent,
    );
  }

  @override
  AppPageLayoutTheme lerp(ThemeExtension<AppPageLayoutTheme>? other, double t) {
    if (other is! AppPageLayoutTheme) return this;

    return AppPageLayoutTheme(
      maxContentWidth: lerpDouble(maxContentWidth, other.maxContentWidth, t)!,
      pagePadding: EdgeInsets.lerp(pagePadding, other.pagePadding, t)!,
      centerContent: other.centerContent,
    );
  }
}
