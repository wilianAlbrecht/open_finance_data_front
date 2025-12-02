import 'package:flutter/material.dart';
import '../core/theme/light_theme.dart';
import '../core/theme/dark_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenFinanceData',
      debugShowCheckedModeBanner: false,
      theme: AppLightTheme.theme,
      darkTheme: AppDarkTheme.theme,

      // Use configuração do sistema
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.indicators,
      routes: AppPages.routes,
    );
  }
}
