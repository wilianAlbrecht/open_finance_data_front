import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';
import '../modules/indicators/indicators_controller.dart';
import '../data/services/openfinance_api.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => OpenFinanceApi()),
        ChangeNotifierProvider(create: (_) => IndicatorsController()),
      ],
      child: MaterialApp(
        title: 'OpenFinanceData',
        debugShowCheckedModeBanner: false,
        theme: AppLightTheme.theme,
        darkTheme: AppDarkTheme.theme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.indicators,
        routes: AppPages.routes,
      ),
    );
  }
}
