import 'package:flutter/material.dart';
import 'package:open_finance_data_front/modules/indicators/controllers/financial_indicators_controller.dart';
import 'package:provider/provider.dart';

import '../core/theme/themes/app_dark_theme.dart';
import '../core/theme/themes/app_light_theme.dart';
import '../core/theme/theme_controller.dart';

import '../modules/indicators/controllers/price_chart_controller.dart';
import '../data/services/history_service.dart';

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
        ChangeNotifierProvider(create: (_) => FinancialIndicatorsController()),
        ChangeNotifierProvider(create: (_) => ThemeController()), 
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            title: 'OpenFinanceData',
            debugShowCheckedModeBanner: false,

            // TEMAS
            theme: AppLightTheme.theme,
            darkTheme: AppDarkTheme.theme,

            // AGORA É CONTROLADO PELO BOTÃO
            themeMode: themeController.themeMode,

            // ROTAS
            initialRoute: AppRoutes.indicators,
            routes: AppPages.routes,
          );
        },
      ),
    );
  }
}
