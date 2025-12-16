class AppResponsiveConfig {
  // ============================
  // BREAKPOINTS
  // ============================
  static const double phoneMax = 600;
  static const double mobileMax = 800;

  static const double compactMin = 800;
  static const double compactMax = 1300;

  static const double smallMin = 1300;
  static const double mediumMin = 1600;
  static const double ultraWideMin = 2000;

  // ============================
  // LAYOUT (HORIZONTAL)
  // ============================

  static const double layoutUsageFactor = 0.95;
  static const double layoutMobleUsageFactor = 1;

  static const double chartFactorCompact = 0.95;
  static const double chartFactorPhone = 0.95;
  static const double chartFactorMobile = 0.95;

  static const double chartFactorUltraWide = 0.70;
  static const double chartFactorMedium = 0.75;
  static const double chartFactorSmall = 0.80;

  // ============================
  // LAYOUT (VERTICAL)
  // ============================
  static const double chartHeightFactorMobile = 0.50;
  static const double chartHeightFactorCompact = 0.50;
  static const double chartHeightFactorPhone = 0.55; // pode ser levemente maior

  static const double chartHeightFactorDefault = 0.60;
  static const double chartHeightFactorUltraWide = 0.60;

  // ============================
  // HELPERS
  // ============================
  static bool isPhone(double width) => width < phoneMax;

  static bool isMobile(double width) => width >= phoneMax && width < mobileMax;

  static bool isCompact(double width) =>
      width >= compactMin && width < compactMax;

  static bool isSmall(double width) => width >= smallMin && width < mediumMin;

  static bool isMedium(double width) =>
      width >= mediumMin && width < ultraWideMin;

  static bool isUltraWide(double width) => width >= ultraWideMin;

  static double chartWidthFactorFor(double width) {
    if (isUltraWide(width)) return chartFactorUltraWide;
    if (isMedium(width)) return chartFactorMedium;
    if (isSmall(width)) return chartFactorSmall;
    return 1.0; // phone + mobile + compact
  }

  static double chartHeightFactorFor(double width) {
    if (isUltraWide(width)) return chartHeightFactorUltraWide;

    if (isCompact(width)) return chartHeightFactorCompact;
    if (isMobile(width)) return chartHeightFactorMobile;
    if (isPhone(width)) return chartHeightFactorPhone;

    return chartHeightFactorDefault;
  }

  // ============================
  // INDICATORS GRID
  // ============================

  static int indicatorColumnsFor(double width) {
    if (isUltraWide(width)) return 3;
    if (isMedium(width)) return 2;
    if (isSmall(width)) return 1;

    // Compact + Mobile + Phone
    return 3;
  }
}
