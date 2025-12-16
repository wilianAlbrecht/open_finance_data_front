import 'package:flutter/material.dart';

enum ScreenSize {
  mobile,
  desktop,
}

class ScreenSizeResolver {
  static ScreenSize resolve(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // ===============================
    // DESKTOP
    // ===============================
    if (width >= 1300) {
      return ScreenSize.desktop;
    }

    // ===============================
    // MOBILE + COMPACT
    // ===============================
    return ScreenSize.mobile;
  }
}
