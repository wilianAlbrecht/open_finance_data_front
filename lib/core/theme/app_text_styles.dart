import 'package:flutter/material.dart';

class AppTextStyles {
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  // BODY SMALL – ideal para indicadores compactos
  static TextStyle bodySm(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodySmBold(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  // BODY EXTRA SMALL – opcional para mobile
  static TextStyle bodyXs(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodyXsBold(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}
