import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/layout/app_responsive_config.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

import '../controllers/price_chart_controller.dart';
import '../controllers/financial_indicators_controller.dart';

import '../widgets/chart/canvas_chart_widget.dart';
import '../widgets/chart/chart_mode_selector.dart';
import '../widgets/chart/filters/ohlc_filter_bar.dart';
import '../widgets/chart/filters/range_filter_bar.dart';
import '../widgets/indicator/indicator_cards.dart';

class IndicatorsDesktopLayout extends StatelessWidget {
  final IndicatorsController chart;
  final FinancialIndicatorsController indicators;
  final ValueChanged<bool> onScrollLock;

  const IndicatorsDesktopLayout({
    super.key,
    required this.chart,
    required this.indicators,
    required this.onScrollLock,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenSize = MediaQuery.of(context).size;

    final chartWidthFactor = AppResponsiveConfig.chartWidthFactorFor(
      screenSize.width,
    );

    final chartHeightFactor = AppResponsiveConfig.chartHeightFactorFor(
      screenSize.width,
    );

    final chartWidth = screenSize.width * chartWidthFactor;
    final chartHeight = screenSize.height * chartHeightFactor;

    final indicatorsWidth =
        screenWidth *
        (AppResponsiveConfig.layoutUsageFactor - chartWidthFactor);

    final indicatorColumns = AppResponsiveConfig.indicatorColumnsFor(
      screenWidth,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================
        // GRÁFICO
        // =====================
        SizedBox(
          width: chartWidth,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (chart.timestamp.isNotEmpty) _ChartControls(chart: chart),

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
                  width: chartWidth,
                  height: chartHeight,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 32),

        // =====================
        // INDICADORES (25%)
        // =====================
        SizedBox(
          width: indicatorsWidth,
          child: Align(
            alignment: Alignment.topCenter,
            child: _IndicatorsSection(indicators: indicators),
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

class _IndicatorsSection extends StatelessWidget {
  final FinancialIndicatorsController indicators;

  const _IndicatorsSection({required this.indicators});

  @override
  Widget build(BuildContext context) {
    if (indicators.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          indicators.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (indicators.data == null) {
      return const SizedBox.shrink();
    }

    return IndicatorCards(data: indicators.data!,);
  }
}
