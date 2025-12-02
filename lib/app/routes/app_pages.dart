import 'package:flutter/material.dart';
import '../../modules/indicators/indicators_page.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.indicators: (context) => const IndicatorsPage(),
    // futuras rotas:
    // AppRoutes.settings: (context) => const SettingsPage(),
  };
}
