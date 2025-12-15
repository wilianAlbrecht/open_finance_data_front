import 'package:flutter/material.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================
        // GRÁFICO
        // =====================
        Expanded(
          child: Column(
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
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // =====================
        // INDICADORES
        // =====================
        SizedBox(width: 380, child: _IndicatorsSection(indicators: indicators)),
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
          child: Align(
            alignment: Alignment.centerRight,
            child: RangeFilterBar(
              selected: chart.currentRange,
              onSelected: (range) => chart.setRange(context, range),
            ),
          ),
        ),
      ],
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

    return IndicatorCards(data: indicators.data!);
  }
}
