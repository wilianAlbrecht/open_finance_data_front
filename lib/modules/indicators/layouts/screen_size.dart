import 'package:flutter/widgets.dart';

enum ScreenSize {
  mobile,
  desktop,
}

class ScreenSizeResolver {
  /// PONTO ÚNICO DE DECISÃO
  static ScreenSize resolve(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 1024) {
      return ScreenSize.mobile;
    }

    return ScreenSize.desktop;
  }
}
