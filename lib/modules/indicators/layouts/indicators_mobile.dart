import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/layout/app_responsive_config.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_cards.dart';

import '../controllers/price_chart_controller.dart';
import '../controllers/financial_indicators_controller.dart';

import '../widgets/chart/canvas_chart_widget.dart';
import '../widgets/chart/chart_mode_selector.dart';
import '../widgets/chart/filters/ohlc_filter_bar.dart';
import '../widgets/chart/filters/range_filter_bar.dart';

class IndicatorsMobileLayout extends StatelessWidget {
  final IndicatorsController chart;
  final FinancialIndicatorsController indicators;
  final ValueChanged<bool> onScrollLock;

  const IndicatorsMobileLayout({
    super.key,
    required this.chart,
    required this.indicators,
    required this.onScrollLock,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final header = pkg.header;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final chartHeight =
        screenHeight * AppResponsiveConfig.chartHeightFactorFor(screenWidth);

    final chartWidth =
        screenWidth * AppResponsiveConfig.chartWidthFactorFor(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // =====================
        // CONTROLES
        // =====================
        if (chart.timestamp.isNotEmpty) _ChartControls(chart: chart),

        // =====================
        // LOADING (RANGE / SEARCH)
        // =====================
        if (chart.isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LinearProgressIndicator(color: header.background),
          ),

        // =====================
        // GRÁFICO
        // =====================
        SizedBox(
          height: chartHeight,
          child: CanvasChartWidget(
            chartMode: chart.chartMode,
            open: chart.open,
            high: chart.high,
            low: chart.low,
            close: chart.close,
            volume: chart.volume,
            timestamp: chart.timestamp,
            showOpen: chart.showOpen,
            showHigh: chart.showHigh,
            showLow: chart.showLow,
            showClose: chart.showClose,
            onHoverScrollLock: onScrollLock,
            width: chartWidth,
            height: chartHeight,
          ),
        ),

        // =====================
        // INDICADORES
        // =====================
        if (indicators.isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (indicators.data != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IndicatorCards(
              data: indicators.data!,
              columns: AppResponsiveConfig.indicatorColumnsFor(screenWidth),
            ),
          ),
      ],
    );
  }
}

class _ChartControls extends StatelessWidget {
  final IndicatorsController chart;

  const _ChartControls({required this.chart});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pkg = Theme.of(context).extension<AppThemePackage>()!;
        final filterLayout = pkg.filters;

        final gap = (constraints.maxWidth * filterLayout.horizontalGapFactor)
            .clamp(filterLayout.minGap, filterLayout.maxGap);

        return Row(
          children: [
            // ESQUERDA
            OhlcFilterBar(),

            SizedBox(width: gap),
            const Spacer(),

            // CENTRO
            ChartModeSelector(
              selected: chart.chartMode,
              onChanged: chart.setChartMode,
            ),

            const Spacer(),
            SizedBox(width: gap),

            // DIREITA
            RangeFilterBar(
              selected: chart.currentRange,
              onSelected: (range) => chart.setRange(context, range),
            ),
          ],
        );
      },
    );
  }
}
