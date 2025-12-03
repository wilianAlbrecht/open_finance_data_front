import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/themes/extensions/app_chart_theme.dart';

class PriceChartStaticBuilder {
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;
  final List<int> timestamp;

  PriceChartStaticBuilder({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
  });

  LineChartData build(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

    // ========= EIXO Y =========

    final allValues = [...open, ...high, ...low, ...close];

    double rawMin = allValues.reduce(min);
    double rawMax = allValues.reduce(max);

    double diff = rawMax - rawMin;

    // margem visual: +10% no topo e –10% embaixo
    double paddedMin = rawMin - diff * 0.10;
    double paddedMax = rawMax + diff * 0.10;

    // Caso raro: valores iguais
    if (paddedMin == paddedMax) {
      final pad = rawMin * 0.01 + 0.01;
      paddedMin -= pad;
      paddedMax += pad;
    }

    // NICE STEP (1,2,5 × 10^n)
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

    const int desiredTicks = 6;
    final rawStep = (paddedMax - paddedMin) / (desiredTicks - 1);
    final stepY = niceStep(rawStep);

    // Expande limites para múltiplos do step
    final graphMin = (paddedMin / stepY).floor() * stepY;
    final graphMax = (paddedMax / stepY).ceil() * stepY;

    final minY = graphMin;
    final maxY = graphMax;

    // ========= EIXO X (NÃO ALTERAR, COMO PEDIU) =========

    final stepX = (timestamp.length / 6).floor();
    final tickPositions = List.generate(
      timestamp.length,
      (i) => (i * stepX).toDouble(),
    );

    const tolerance = 0.3;

    return LineChartData(
      minY: minY,
      maxY: maxY,

      // ===== GRID =====
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: chartTheme.gridColor, strokeWidth: 1),
        getDrawingVerticalLine: (value) {
          final isTick = tickPositions.any(
            (tick) => (value - tick).abs() < tolerance,
          );
          return FlLine(
            color: isTick ? chartTheme.gridColor : Colors.transparent,
            strokeWidth: 1,
          );
        },
      ),

      // ===== TITLES =====
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: stepY,
            reservedSize: AppLayout.axisLeftReserved,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(2),
                style: AppTextStyles.body.copyWith(
                  fontSize: 10,
                  color: chartTheme.axisLabelColor,
                ),
              );
            },
          ),
        ),

        // ===== EIXO X — APENAS EXIBIR AS DATAS (intervalo intacto) =====
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (timestamp.length / 6).floorToDouble(),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();

              // fora dos limites → não exibe
              if (index < 0 || index >= timestamp.length) {
                return const SizedBox.shrink();
              }

              // formata a data
              final dt = DateTime.fromMillisecondsSinceEpoch(
                timestamp[index] * 1000,
              );

              final label =
                  "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString().substring(2)}"; ///

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
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: AppLayout.axisRightReserved,
          ),
        ),

        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      borderData: FlBorderData(show: false),

      lineBarsData: const [],
    );
  }
}
