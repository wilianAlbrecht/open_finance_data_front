import 'package:flutter/material.dart';
import 'package:open_finance_data_front/modules/indicators/layouts/screen_size.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/page_loding_bar.dart';
import 'package:provider/provider.dart';

import 'package:open_finance_data_front/core/widgets/page_container.dart';
import 'package:open_finance_data_front/core/widgets/theme_toggle_button.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

import 'controllers/price_chart_controller.dart';
import 'controllers/financial_indicators_controller.dart';

import 'layouts/indicators_desktop.dart';
import 'layouts/indicators_mobile.dart';
import 'widgets/search_bar.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  bool _lockScroll = false;

  void _setScrollLock(bool locked) {
    setState(() => _lockScroll = locked);
  }

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final header = pkg.header;
    final screen = ScreenSizeResolver.resolve(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: header.background,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 180,
        title: Center(
          child: Image.asset(
            'assets/images/logo_open_finance_data.png',
            height: 150,
          ),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: PageContainer(
        fullWidth: true,
        child: Consumer2<IndicatorsController, FinancialIndicatorsController>(
          builder: (context, chart, indicators, _) {
            final Widget layout = screen == ScreenSize.desktop
                ? IndicatorsDesktopLayout(
                    chart: chart,
                    indicators: indicators,
                    onScrollLock: _setScrollLock,
                  )
                : IndicatorsMobileLayout(
                    chart: chart,
                    indicators: indicators,
                    onScrollLock: _setScrollLock,
                  );

            return ListView(
              physics: _lockScroll
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: [
                const SearchBarWidget(),

                if (chart.isLoading) PageLoadingBar(color: header.background),

                const SizedBox(height: 12),

                layout,
              ],
            );
          },
        ),
      ),
    );
  }
}
