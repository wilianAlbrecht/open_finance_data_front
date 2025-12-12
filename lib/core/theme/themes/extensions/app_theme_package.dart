import 'package:flutter/material.dart';

import 'app_card_theme.dart';
import 'app_filter_button_theme.dart';
import 'app_indicator_card_theme.dart';
import 'app_canvas_theme.dart';
import 'app_search_bar_theme.dart';
import 'app_header_theme.dart';
import 'app_text_theme.dart';

class AppThemePackage extends ThemeExtension<AppThemePackage> {
  final AppCardTheme card;
  final AppFilterButtonTheme filters;
  final AppIndicatorCardTheme indicatorCard;
  final AppCanvasTheme canvas;
  final AppSearchBarTheme searchBar;
  final AppHeaderTheme header;
  final AppTextTheme text;

  const AppThemePackage({
    required this.card,
    required this.filters,
    required this.indicatorCard,
    required this.canvas,
    required this.searchBar,
    required this.header,
    required this.text,
  });

  // ============================
  //            LIGHT
  // ============================
  static const light = AppThemePackage(
    card: AppCardTheme.light,
    filters: AppFilterButtonTheme.light,
    indicatorCard: AppIndicatorCardTheme.light,
    canvas: AppCanvasTheme.light,
    searchBar: AppSearchBarTheme.light,
    header: AppHeaderTheme.light,
    text: AppTextTheme.light,
  );

  // ============================
  //            DARK
  // ============================
  static const dark = AppThemePackage(
    card: AppCardTheme.dark,
    filters: AppFilterButtonTheme.dark,
    indicatorCard: AppIndicatorCardTheme.dark,
    canvas: AppCanvasTheme.dark,
    searchBar: AppSearchBarTheme.dark,
    header: AppHeaderTheme.dark,
    text: AppTextTheme.dark,
  );

  // ============================
  //          COPY WITH
  // ============================
  @override
  AppThemePackage copyWith({
    AppCardTheme? card,
    AppFilterButtonTheme? filters,
    AppIndicatorCardTheme? indicatorCard,
    AppCanvasTheme? canvas,
    AppSearchBarTheme? searchBar,
    AppHeaderTheme? header,
    AppTextTheme? text,
  }) {
    return AppThemePackage(
      card: card ?? this.card,
      filters: filters ?? this.filters,
      indicatorCard: indicatorCard ?? this.indicatorCard,
      canvas: canvas ?? this.canvas,
      searchBar: searchBar ?? this.searchBar,
      header: header ?? this.header,
      text: text ?? this.text,
    );
  }

  // ============================
  //            LERP
  // ============================
  @override
  AppThemePackage lerp(ThemeExtension<AppThemePackage>? other, double t) {
    if (other is! AppThemePackage) return this;

    return AppThemePackage(
      card: card.lerp(other.card, t),
      filters: filters.lerp(other.filters, t),
      indicatorCard: indicatorCard.lerp(other.indicatorCard, t),
      canvas: canvas.lerp(other.canvas, t),
      searchBar: searchBar.lerp(other.searchBar, t),
      header: header.lerp(other.header, t),
      text: text.lerp(other.text, t),
    );
  }
}
