import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_layout.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/themes/extensions/app_chart_theme.dart';

class PriceChartResult {
  final LineChartData chart;
  final List<LineChartBarData> series;

  PriceChartResult({
    required this.chart,
    required this.series,
  });
}

class PriceChartBuilder {
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;
  final List<int> timestamp;

  final bool showOpen;
  final bool showHigh;
  final bool showLow;
  final bool showClose;

  PriceChartBuilder({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
    required this.showOpen,
    required this.showHigh,
    required this.showLow,
    required this.showClose,
  });

  // =====================================================
  //              SERIES (OHLC)
  // =====================================================

  List<FlSpot> _spots(List<double> data) =>
      List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));

  List<LineChartBarData> _buildSeries(BuildContext context) {
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

  // =====================================================
  //              STATIC PART (GRID / AXIS)
  // =====================================================

  LineChartData _buildStatic(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

    // ======== MIN/MAX ========
    final all = [...open, ...high, ...low, ...close];
    double rawMin = all.reduce(min);
    double rawMax = all.reduce(max);

    final diff = rawMax - rawMin;
    double paddedMin = rawMin - diff * 0.10;
    double paddedMax = rawMax + diff * 0.10;

    if (paddedMin == paddedMax) {
      final pad = rawMin * 0.01 + 0.01;
      paddedMin -= pad;
      paddedMax += pad;
    }

    // ======== NICE STEP ========
    double niceStep(double value) {
      final exp = value == 0 ? 0 : log(value.abs()) / ln10;
      final base = value / pow(10, exp.floor());
      double niceBase;

      if (base <= 1)
        niceBase = 1;
      else if (base <= 2)
        niceBase = 2;
      else if (base <= 5)
        niceBase = 5;
      else
        niceBase = 10;

      return niceBase * pow(10, exp.floor());
    }

    const int ticksY = 6;
    final rawStep = (paddedMax - paddedMin) / (ticksY - 1);
    final stepY = niceStep(rawStep);

    final minY = (paddedMin / stepY).floor() * stepY;
    final maxY = (paddedMax / stepY).ceil() * stepY;

    // ======== EIXO X ========
    final stepX = (timestamp.length / 6).floor();
    final tolerance = 0.3;

    return LineChartData(
      minY: minY,
      maxY: maxY,

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: chartTheme.gridColor, strokeWidth: 1),
        getDrawingVerticalLine: (value) {
          final tickPositions = List.generate(
              timestamp.length, (i) => (i * stepX).toDouble());

          final isTick = tickPositions.any(
            (tick) => (value - tick).abs() < tolerance,
          );

          return FlLine(
            color: isTick ? chartTheme.gridColor : Colors.transparent,
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: stepY,
            reservedSize: AppLayout.axisLeftReserved,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(2),
              style: AppTextStyles.body.copyWith(
                fontSize: 10,
                color: chartTheme.axisLabelColor,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: stepX.toDouble(),
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              if (index < 0 || index >= timestamp.length) {
                return const SizedBox.shrink();
              }

              final dt =
                  DateTime.fromMillisecondsSinceEpoch(timestamp[index] * 1000);

              final label =
                  "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString().substring(2)}";

              return Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 10,
                  color: chartTheme.axisLabelColor,
                ),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),

      borderData: FlBorderData(show: false),
      lineBarsData: const [], // será substituído mais tarde
    );
  }

  // =====================================================
  //                  FINAL RESULT
  // =====================================================

  PriceChartResult build(BuildContext context) {
    final series = _buildSeries(context);
    final chart = _buildStatic(context);

    return PriceChartResult(
      chart: chart,
      series: series,
    );
  }
}
