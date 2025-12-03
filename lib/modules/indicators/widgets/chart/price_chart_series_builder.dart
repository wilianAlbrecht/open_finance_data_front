import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/themes/extensions/app_chart_theme.dart';

class PriceChartSeriesBuilder {
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;

  PriceChartSeriesBuilder({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  List<FlSpot> _spots(List<double> data) =>
      List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));

  List<LineChartBarData> build(
    BuildContext context, {
    required bool showOpen,
    required bool showHigh,
    required bool showLow,
    required bool showClose,
  }) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;
    final List<LineChartBarData> series = [];

    if (showClose) {
      series.add(LineChartBarData(
        spots: _spots(close),
        color: chartTheme.closeColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showOpen) {
      series.add(LineChartBarData(
        spots: _spots(open),
        color: chartTheme.openColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showHigh) {
      series.add(LineChartBarData(
        spots: _spots(high),
        color: chartTheme.highColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showLow) {
      series.add(LineChartBarData(
        spots: _spots(low),
        color: chartTheme.lowColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    return series;
  }
}
