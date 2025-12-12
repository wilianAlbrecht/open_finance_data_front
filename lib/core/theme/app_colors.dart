import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // ===============================
  //            BRAND / PRIMARY
  // ===============================

  // Azul (Close / linha principal / botões ativos)
  static const Color primaryLight = Color(0xFF1E88E5); // Blue 600
  static const Color primaryDark  = Color(0xFF42A5F5); // Blue 400

  // ===============================
  //            BACKGROUND
  // ===============================

  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color backgroundDark  = Color(0xFF121212);

  // ===============================
  //            SURFACE / CARDS
  // ===============================

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark  = Color(0xFF1F1F1F);

  // ===============================
  //            DIVIDERS / BORDERS
  // ===============================

  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark  = Color(0xFF2A2A2A);

  // ===============================
  //            TEXT COLORS
  // ===============================

  static const Color textLight = Color(0xFF1A1A1A);
  static const Color textDark  = Color(0xFFEAEAEA);

  static const Color textLightSecondary = Color(0xFF7A7A7A);
  static const Color textDarkSecondary  = Color(0xFF9E9E9E);

  // ===============================
  //            HEADER
  // ===============================

  static const Color headerLight = Color(0xFF66BB6A); // Green 400
  static const Color headerDark  = Color(0xFF1B5E20); // Green 900

  // ===============================
  //        POSITIVE / NEGATIVE
  // ===============================

  static const Color positive = Color(0xFF4CAF50);
  static const Color negative = Color(0xFFE53935);

  // ===============================
  //        BUTTONS - PRIMARY
  // ===============================
  static const Color primaryButton = Color(0xFF4CAF50);


  // ===============================
  //        CHART — MULTI SERIES
  // ===============================

  // Open
  static const Color chartOpen = Color(0xFFFFB300); // Amber 600

  // High
  static const Color chartHigh = Color(0xFF64DD17); // Light Green A700

  // Low
  static const Color chartLow = Color(0xFFE53935); // Red 600 (mesmo negative)

  // Close (puxado do primary)
  static const Color chartCloseLight = primaryLight;
  static const Color chartCloseDark  = primaryDark;

  // ===============================
  //        CHART — GRID / AXIS
  // ===============================

  static const Color chartGridLight = dividerLight;
  static const Color chartGridDark  = dividerDark;

  static const Color chartAxisTextLight = textLightSecondary;
  static const Color chartAxisTextDark  = textDarkSecondary;

  // ===============================
  //        VOLUME (MOUNTAIN)
  // ===============================

  // topo do gradiente (mais claro)
  static const Color volumeTopLight = Color(0xFF1E88E5); // same primary
  static const Color volumeTopDark  = Color(0xFF42A5F5);

  // base do gradiente (mais escuro / opaco)
  static const Color volumeBottomLight = Color(0xFF0D47A1); // Blue 900
  static const Color volumeBottomDark  = Color(0xFF001E3C); // Deep navy

  // (o gradiente real usa opacidade, controlado no CanvasTheme)
}
