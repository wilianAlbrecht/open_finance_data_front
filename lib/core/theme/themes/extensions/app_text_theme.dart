import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_colors.dart';

class AppTextTheme extends ThemeExtension<AppTextTheme> {
  // ===============================
  //        TIPOGRAFIA COMPLETA
  // ===============================
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle title;
  final TextStyle titleLarge;
  final TextStyle sectionTitle;
  final TextStyle caption;
  final TextStyle number;
  final TextStyle button;
  final TextStyle showMoreButton;

  const AppTextTheme({
    required this.body,
    required this.bodySmall,
    required this.title,
    required this.titleLarge,
    required this.sectionTitle,
    required this.caption,
    required this.number,
    required this.button,
    required this.showMoreButton,
  });

  // ===============================
  //             LIGHT
  // ===============================
  static const light = AppTextTheme(
    body: TextStyle(
      fontSize: 14,
      color: AppColors.textLight,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AppColors.textLightSecondary,
    ),
    title: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),
    sectionTitle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    caption: TextStyle(
      fontSize: 12,
      color: AppColors.textLightSecondary,
    ),
    number: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    showMoreButton: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryButton,
    ),
  );

  // ===============================
  //             DARK
  // ===============================
  static const dark = AppTextTheme(
    body: TextStyle(
      fontSize: 14,
      color: AppColors.textDark,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AppColors.textDarkSecondary,
    ),
    title: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
    sectionTitle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
    caption: TextStyle(
      fontSize: 12,
      color: AppColors.textDarkSecondary,
    ),
    number: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
    showMoreButton: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryButton,
    ),
  );

  // ===============================
  //       COPYWITH / LERP
  // ===============================
  @override
  AppTextTheme copyWith({
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? title,
    TextStyle? titleLarge,
    TextStyle? sectionTitle,
    TextStyle? caption,
    TextStyle? number,
    TextStyle? button,
    TextStyle? showMoreButton,
  }) {
    return AppTextTheme(
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      title: title ?? this.title,
      titleLarge: titleLarge ?? this.titleLarge,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      caption: caption ?? this.caption,
      number: number ?? this.number,
      button: button ?? this.button,
      showMoreButton: showMoreButton ?? this.showMoreButton,
    );
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;

    return AppTextTheme(
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      number: TextStyle.lerp(number, other.number, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      showMoreButton: TextStyle.lerp(button, other.showMoreButton, t)!,
    );
  }
}
