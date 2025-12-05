import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_layout.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/themes/extensions/app_chart_theme.dart';

class PriceChartResult {
  final LineChartData chart;
  final List<LineChartBarData> series;

  PriceChartResult({required this.chart, required this.series});
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
  // CLEAN INVALID DATA BY INDEX
  // =====================================================

  void cleanAllSeries() {
    final int len = timestamp.length;
    final List<int> remove = [];

    for (int i = 0; i < len; i++) {
      final o = open[i];
      final h = high[i];
      final l = low[i];
      final c = close[i];

      final invalid =
          !o.isFinite || o <= 0 ||
          !h.isFinite || h <= 0 ||
          !l.isFinite || l <= 0 ||
          !c.isFinite || c <= 0;

      if (invalid) remove.add(i);
    }

    // Remove do fim para o começo
    for (int i = remove.length - 1; i >= 0; i--) {
      final idx = remove[i];
      open.removeAt(idx);
      high.removeAt(idx);
      low.removeAt(idx);
      close.removeAt(idx);
      timestamp.removeAt(idx);
    }
  }

  // =====================================================
  // SERIES (OHLC)
  // =====================================================

  List<FlSpot> _spots(List<double> data) =>
      List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));

  List<LineChartBarData> _buildSeries(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;
    final List<LineChartBarData> series = [];

    if (showClose && close.isNotEmpty) {
      series.add(LineChartBarData(
        spots: _spots(close),
        color: chartTheme.closeColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showOpen && open.isNotEmpty) {
      series.add(LineChartBarData(
        spots: _spots(open),
        color: chartTheme.openColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showHigh && high.isNotEmpty) {
      series.add(LineChartBarData(
        spots: _spots(high),
        color: chartTheme.highColor,
        isCurved: true,
        barWidth: 2,
      ));
    }

    if (showLow && low.isNotEmpty) {
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
  // STATIC (GRID + AXIS)
  // =====================================================

  LineChartData _buildStatic(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

    // ======= Garantia: NÃO usar valores inválidos =======
    final allValues = [...open, ...high, ...low, ...close];
    if (allValues.isEmpty) {
      return LineChartData(minY: 0, maxY: 1);
    }

    double rawMin = allValues.reduce(min);
    double rawMax = allValues.reduce(max);

    final diff = rawMax - rawMin;
    double paddedMin = rawMin - diff * 0.25;
    double paddedMax = rawMax + diff * 0.25;

    if (paddedMin == paddedMax) {
      paddedMin -= 1;
      paddedMax += 1;
    }

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

    const ticksY = 6;
    final rawStep = (paddedMax - paddedMin) / (ticksY - 1);
    final stepY = niceStep(rawStep);

    final minY = (paddedMin / stepY).floor() * stepY;
    final maxY = (paddedMax / stepY).ceil() * stepY;

    // ===== DATAS DIVIDIDAS EM 6 PARTES =====
    final stepX = max(1, (timestamp.length / 6).floor());

    return LineChartData(
      minY: minY,
      maxY: maxY,

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: chartTheme.gridColor, strokeWidth: 1),
        getDrawingVerticalLine: (value) {
          final isTick = (value % stepX).abs() < 0.3;
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

              final dt = DateTime.fromMillisecondsSinceEpoch(
                timestamp[index] * 1000,
              );

              return Text(
                "${dt.day.toString().padLeft(2, '0')}/"
                "${dt.month.toString().padLeft(2, '0')}/"
                "${dt.year.toString().substring(2)}",
                style: AppTextStyles.body.copyWith(
                  fontSize: 10,
                  color: chartTheme.axisLabelColor,
                ),
              );
            },
          ),
        ),

        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      borderData: FlBorderData(show: false),
      lineBarsData: const [],
    );
  }

  // =====================================================
  // FINAL RESULT
  // =====================================================

  PriceChartResult build(BuildContext context) {
    cleanAllSeries(); // ← OBRIGATÓRIO e no começo

    final series = _buildSeries(context);
    final chart = _buildStatic(context);

    return PriceChartResult(chart: chart, series: series);
  }
}
