import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

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

    return Column(
      children: [
        if (chart.timestamp.isNotEmpty) _ChartControls(chart: chart),

        if (chart.isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LinearProgressIndicator(color: header.background),
          ),

        CanvasChartWidget(
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
    return Row(
      children: [
        const Expanded(child: OhlcFilterBar()),
        Expanded(
          child: Center(
            child: ChartModeSelector(
              selected: chart.chartMode,
              onChanged: chart.setChartMode,
            ),
          ),
        ),
        Expanded(
          child: RangeFilterBar(
            selected: chart.currentRange,
            onSelected: (range) => chart.setRange(context, range),
          ),
        ),
      ],
    );
  }
}
